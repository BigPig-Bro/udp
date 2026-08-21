// RGMII ↔ GMII 桥接
//260819    v1.1.0   补全TX/RX数据与控制通路，支持RGMII 1G/DDR模式，125MHz；RGMII编码：上升沿低半字节/TX_EN，下降沿高半字节/TX_EN^TX_ER
//260821    v1.2.0   由1G版本升级为10/100/1000M三速版本，新增10/100M SDR模式
module gmii2rgmii #(
    parameter [ 1:0] P_RGMII_MODE  = 2'd1  // 0:10M SDR, 1:100M SDR, 2:1G DDR
    ) (
    input                               i_rst_n,
    // RGMII 引脚侧
    input                               i_rgmii_rxc,
    input                       [ 3:0]  i_rgmii_rxd,
    input                               i_rgmii_rxctl,
    output      logic           [ 3:0]  o_rgmii_txd,
    output      logic                   o_rgmii_txctl,
    output      logic                   o_rgmii_txc,

    output      logic                   o_usr_clk,
    // GMII RX (字节流输出)
    output      logic           [ 7:0]  o_rx_data,
    output      logic                   o_rx_dv,
    output      logic                   o_rx_er,
    // GMII TX (字节流输入)
    input                       [ 7:0]  i_tx_data,
    input                               i_tx_en,
    input                               i_tx_er
    );

genvar gi;

generate
    /////////////////////////////////////////////////////////////////////////////
    // 1G DDR 模式：RXC=125MHz，altddio_in/altddio_out 完成4bit DDR转换
    /////////////////////////////////////////////////////////////////////////////
    if (P_RGMII_MODE == 2'd2) begin : gen_rgmii_1g
        // TXD: 下降沿输出高半字节[7:4], 上升沿输出低半字节[3:0]
        logic [3:0]                     txd_datain_h;
        logic [3:0]                     txd_datain_l;
        logic [3:0]                     txd_dataout;
        // TXCTL: 下降沿输出TX_EN^TX_ER, 上升沿输出TX_EN
        logic                           txctl_datain_h;
        logic                           txctl_datain_l;
        logic                           txctl_dataout;
        // TXC: DDIO输出固定{1,0} -> 与数据边沿对齐的125MHz方波
        logic                           txc_datain_h;
        logic                           txc_datain_l;
        logic                           txc_dataout;

        // RXD: 下降沿采样高半字节[7:4], 上升沿采样低半字节[3:0]
        logic [3:0]                     rxd_dataout_h;
        logic [3:0]                     rxd_dataout_l;
        // RXCTL: 下降沿采样RX_DV^RX_ER, 上升沿采样RX_DV
        logic                           rxctl_dataout_h;
        logic                           rxctl_dataout_l;

        assign o_usr_clk = i_rgmii_rxc;

        // GMII TX → RGMII
        assign txd_datain_h = i_tx_data[3:0];   // 上升沿 -> 低半字节
        assign txd_datain_l = i_tx_data[7:4];   // 下降沿 -> 高半字节
        assign o_rgmii_txd  = txd_dataout;

        assign txctl_datain_h = i_tx_en;
        assign txctl_datain_l = i_tx_en ^ i_tx_er;
        assign o_rgmii_txctl = txctl_dataout;

        assign txc_datain_h = 1'b1;
        assign txc_datain_l = 1'b0;
        assign o_rgmii_txc  = txc_dataout;

        // RGMII → GMII RX
        assign o_rx_data = {rxd_dataout_h, rxd_dataout_l};
        assign o_rx_dv   = rxctl_dataout_l;
        assign o_rx_er   = rxctl_dataout_h ^ rxctl_dataout_l;

        //Altera DDIO OUT: TXD
        altddio_out #(
            .WIDTH(4),
            .POWER_UP_HIGH("OFF"),
            .INTENDED_DEVICE_FAMILY("Cyclone V")
        ) u_altddio_out (
            .datain_h  (txd_datain_h   ),
            .datain_l  (txd_datain_l   ),
            .outclock  (o_usr_clk      ),
            .aclr      (1'b0           ),
            .dataout   (txd_dataout    )
        );

        //Altera DDIO OUT: TXCTL
        altddio_out #(
            .WIDTH(1),
            .POWER_UP_HIGH("OFF"),
            .INTENDED_DEVICE_FAMILY("Cyclone V")
        ) u_altddio_out_ctl (
            .datain_h  (txctl_datain_h ),
            .datain_l  (txctl_datain_l ),
            .outclock  (o_usr_clk      ),
            .aclr      (1'b0           ),
            .dataout   (txctl_dataout  )
        );

        //Altera DDIO OUT: TXC
        altddio_out #(
            .WIDTH(1),
            .POWER_UP_HIGH("OFF"),
            .INTENDED_DEVICE_FAMILY("Cyclone V")
        ) u_altddio_out_txc (
            .datain_h  (txc_datain_h   ),
            .datain_l  (txc_datain_l   ),
            .outclock  (o_usr_clk      ),
            .aclr      (1'b0           ),
            .dataout   (txc_dataout    )
        );

        //Altera DDIO IN: RXD
        altddio_in #(
            .WIDTH(4),
            .POWER_UP_HIGH("OFF"),
            .INTENDED_DEVICE_FAMILY("Cyclone V")
        ) u_altddio_in (
            .datain    (i_rgmii_rxd    ),
            .inclock   (o_usr_clk      ),
            .aclr      (1'b0           ),
            .dataout_h (rxd_dataout_h  ),
            .dataout_l (rxd_dataout_l  )
        );

        //Altera DDIO IN: RXCTL
        altddio_in #(
            .WIDTH(1),
            .POWER_UP_HIGH("OFF"),
            .INTENDED_DEVICE_FAMILY("Cyclone V")
        ) u_altddio_in_ctl (
            .datain    (i_rgmii_rxctl  ),
            .inclock   (o_usr_clk      ),
            .aclr      (1'b0           ),
            .dataout_h (rxctl_dataout_h),
            .dataout_l (rxctl_dataout_l)
        );
    end else begin : gen_rgmii_10_100
        /////////////////////////////////////////////////////////////////////////////
        // 10/100M SDR 模式：RXC=25MHz(100M)/2.5MHz(10M)，RXC 2分频作为 o_usr_clk
        /////////////////////////////////////////////////////////////////////////////
        logic                           usr_clk_div;
        logic [3:0]                     rxd_q;
        logic                           rxctl_q;
        logic [3:0]                     rxd_lo;
        logic                           rxctl_lo;
        logic                           rx_phase;
        logic                           rxctl_sdr_prev;
        logic [7:0]                     rx_data_rxc;
        logic                           rx_dv_rxc;
        logic                           rx_er_rxc;
        logic [7:0]                     tx_data_usr;
        logic                           tx_en_usr, tx_er_usr;
        logic [7:0]                     tx_data_q;
        logic                           tx_en_q, tx_er_q;

        assign o_usr_clk = usr_clk_div;

        // 用户时钟：RXC 2分频 (12.5M/1.25M)
        always_ff @(posedge i_rgmii_rxc) begin
            if (!i_rst_n)
                usr_clk_div <= 1'b0;
            else
                usr_clk_div <= ~usr_clk_div;
        end

        // RGMII RX 输入先在 RXC 域打一拍，再做半字节拼接；RX_DV 上升沿强制对齐到低半字节，
        // 之后两个半字节拼成一个 8bit 字节输出到 o_usr_clk(RXC/2) 域。
        always_ff @(posedge i_rgmii_rxc) begin
            if (!i_rst_n) begin
                rxd_q   <= 4'd0;
                rxctl_q <= 1'b0;
            end else begin
                rxd_q   <= i_rgmii_rxd;
                rxctl_q <= i_rgmii_rxctl;
            end
        end

        always_ff @(posedge i_rgmii_rxc) begin
            if (!i_rst_n) begin
                rx_phase        <= 1'b0;
                rxd_lo          <= 4'd0;
                rxctl_lo        <= 1'b0;
                rxctl_sdr_prev  <= 1'b0;
                rx_data_rxc     <= 8'h00;
                rx_dv_rxc       <= 1'b0;
                rx_er_rxc       <= 1'b0;
            end else begin
                rxctl_sdr_prev  <= rxctl_q;

                if (rxctl_q && !rxctl_sdr_prev) begin
                    // RX_DV 上升沿：本拍是字节的低半字节
                    rx_phase    <= 1'b1;
                    rxd_lo      <= rxd_q;
                    rxctl_lo    <= rxctl_q;
                end else if (!rx_phase) begin
                    // 低半字节
                    rx_phase    <= 1'b1;
                    rxd_lo      <= rxd_q;
                    rxctl_lo    <= rxctl_q;
                end else begin
                    // 高半字节：拼成一个字节
                    rx_phase    <= 1'b0;
                    rx_data_rxc <= {rxd_q, rxd_lo};
                    rx_dv_rxc   <= rxctl_q && rxctl_lo;
                    rx_er_rxc   <= 1'b0; // SDR 模式无独立 RX_ER
                end
            end
        end

        // RX 输出在 o_usr_clk 域重采样（打拍）
        always_ff @(posedge usr_clk_div) begin
            if (!i_rst_n) begin
                o_rx_data   <= 8'h00;
                o_rx_dv     <= 1'b0;
                o_rx_er     <= 1'b0;
            end else begin
                o_rx_data   <= rx_data_rxc;
                o_rx_dv     <= rx_dv_rxc;
                o_rx_er     <= rx_er_rxc;
            end
        end

        // TX GMII 8bit → RGMII 4bit SDR 串行化
        // 先在 o_usr_clk 域对 GMII TX 输入重采样，避免在 RXC 边沿直接采到正在变化的用户数据；
        // 再在 RXC 域按 SDR 串行化：低半字节 → 高半字节。TXC 直接使用 RXC。
        always_ff @(posedge usr_clk_div) begin
            if (!i_rst_n) begin
                tx_data_usr <= 8'h00;
                tx_en_usr   <= 1'b0;
                tx_er_usr   <= 1'b0;
            end else begin
                tx_data_usr <= i_tx_data;
                tx_en_usr   <= i_tx_en;
                tx_er_usr   <= i_tx_er;
            end
        end

        always_ff @(posedge i_rgmii_rxc) begin
            if (!i_rst_n) begin
                o_rgmii_txd     <= 4'd0;
                o_rgmii_txctl   <= 1'b0;
                tx_data_q       <= 8'h00;
                tx_en_q         <= 1'b0;
                tx_er_q         <= 1'b0;
            end else begin
                if (!usr_clk_div) begin
                    // 低半字节（o_usr_clk 上升沿对应的 RXC 上升沿）
                    o_rgmii_txd   <= tx_data_q[3:0];
                    o_rgmii_txctl <= tx_en_q;
                end else begin
                    // 高半字节（o_usr_clk 下降沿对应的 RXC 上升沿），并锁存 o_usr_clk 域打拍后的下一字节
                    o_rgmii_txd   <= tx_data_q[7:4];
                    o_rgmii_txctl <= tx_en_q ^ tx_er_q;
                    tx_data_q     <= tx_data_usr;
                    tx_en_q       <= tx_en_usr;
                    tx_er_q       <= tx_er_usr;
                end
            end
        end

        // TXC：SDR 模式直接使用 RXC 作为输出时钟（不使用 DDIO）
        assign o_rgmii_txc = (P_RGMII_MODE == 2'd0) ? ~i_rgmii_rxc : i_rgmii_rxc;
    end
endgenerate

endmodule
