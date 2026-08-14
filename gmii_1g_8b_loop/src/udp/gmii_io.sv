//  GMII IO — MMCME2 + IDELAYCTRL + IDELAYE2 
// V1.0.0
//
module gmii_io #(
    parameter [ 4:0] P_IDELAY_TAPS = 5'd12
    ) (
    input                               i_sys_clk,
    input                               i_rst_n,
    // GMII 引脚侧
    input                               i_gmii_rx_clk,
    input                               i_gmii_rx_valid,
    input                               i_gmii_rx_err,
    input                       [ 7:0]  i_gmii_rx_data,
    output                              o_gmii_tx_clk,
    output                              o_gmii_tx_valid,
    output                              o_gmii_tx_err,
    output                      [ 7:0]  o_gmii_tx_data,
    // User GMII
    output      logic           [ 7:0]  o_rx_data,
    output      logic                   o_rx_dv,
    output      logic                   o_rx_er,
    input                       [ 7:0]  i_tx_data,
    input                               i_tx_en
    );
/////////////////////////////////////////////////////////////////////////////////////////
////////////////////                 内部信号                /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
logic                           clk_200m, pll_locked;

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////          rx_dly_pll (125M→200MHz)     /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
rx_dly_pll rx_dly_pll_m0 (
    .clk_in1                    (i_sys_clk                  ),
    .reset                      (~i_rst_n                   ),
    .clk_out1                   (clk_200m                   ),
    .locked                     (pll_locked                 )
);
/////////////////////////////////////////////////////////////////////////////////////////
////////////////////              IDELAYCTRL              /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
IDELAYCTRL idelay_ctrl (
    .REFCLK                     (clk_200m                   ),
    .RST                        (~pll_locked                ),
    .RDY                        (                           )
);

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////         IDELAYE2 +  RXD[7:0]     /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
genvar gi;
generate
    for (gi = 0; gi < 8; gi++) begin : gen_rxd
        logic rxd_delayed;

        IDELAYE2 #(
            .CINVCTRL_SEL           ("FALSE"        ),
            .DELAY_SRC              ("IDATAIN"      ),
            .HIGH_PERFORMANCE_MODE  ("TRUE"         ),
            .IDELAY_TYPE            ("FIXED"        ),
            .IDELAY_VALUE           (P_IDELAY_TAPS   ),
            .PIPE_SEL               ("FALSE"        ),
            .REFCLK_FREQUENCY       (200.0           ),
            .SIGNAL_PATTERN         ("DATA"         )
        ) idelay_rxd (
            .DATAOUT                (rxd_delayed     ),
            .DATAIN                 (1'b0            ),
            .C                      (i_sys_clk       ),
            .CE                     (1'b0            ),
            .INC                    (1'b0            ),
            .IDATAIN                (i_gmii_rx_data[gi]),
            .CNTVALUEIN             (5'd0            ),
            .CNTVALUEOUT            (                ),
            .LD                     (1'b0            ),
            .LDPIPEEN               (1'b0            ),
            .REGRST                 (1'b0            )
        );

        // 输入打拍：IDELAY 延迟后同步到系统时钟域
        always_ff @(posedge i_sys_clk) begin
            if (!i_rst_n)
                o_rx_data[gi] <= 1'b0;
            else
                o_rx_data[gi] <= rxd_delayed;
        end
    end
endgenerate

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////        IDELAYE2 +  RXCTL        /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
logic rxctl_delayed;

IDELAYE2 #(
    .CINVCTRL_SEL           ("FALSE"        ),
    .DELAY_SRC              ("IDATAIN"      ),
    .HIGH_PERFORMANCE_MODE  ("TRUE"         ),
    .IDELAY_TYPE            ("FIXED"        ),
    .IDELAY_VALUE           (P_IDELAY_TAPS   ),
    .PIPE_SEL               ("FALSE"        ),
    .REFCLK_FREQUENCY       (200.0           ),
    .SIGNAL_PATTERN         ("DATA"         )
) idelay_rxctl (
    .DATAOUT                (rxctl_delayed   ),
    .DATAIN                 (1'b0            ),
    .C                      (i_sys_clk       ),
    .CE                     (1'b0            ),
    .INC                    (1'b0            ),
    .IDATAIN                (i_gmii_rx_valid ),
    .CNTVALUEIN             (5'd0            ),
    .CNTVALUEOUT            (                ),
    .LD                     (1'b0            ),
    .LDPIPEEN               (1'b0            ),
    .REGRST                 (1'b0            )
);


// RX_DV 输入打拍（对应 GMII 的 RX_DV）
always_ff @(posedge i_sys_clk) begin
    if (!i_rst_n)
        o_rx_dv <= 1'b0;
    else
        o_rx_dv <= rxctl_delayed;
end

// RX_ER IDELAY + 输入打拍 (Who Cares)
// logic rxer_delayed;

// IDELAYE2 #(
//     .CINVCTRL_SEL           ("FALSE"        ),
//     .DELAY_SRC              ("IDATAIN"      ),
//     .HIGH_PERFORMANCE_MODE  ("TRUE"         ),
//     .IDELAY_TYPE            ("FIXED"        ),
//     .IDELAY_VALUE           (P_IDELAY_TAPS   ),
//     .PIPE_SEL               ("FALSE"        ),
//     .REFCLK_FREQUENCY       (200.0           ),
//     .SIGNAL_PATTERN         ("DATA"         )
// ) idelay_rxer (
//     .DATAOUT                (rxer_delayed   ),
//     .DATAIN                 (1'b0            ),
//     .C                      (i_sys_clk       ),
//     .CE                     (1'b0            ),
//     .INC                    (1'b0            ),
//     .IDATAIN                (i_gmii_rx_err   ),
//     .CNTVALUEIN             (5'd0            ),
//     .CNTVALUEOUT            (                ),
//     .LD                     (1'b0            ),
//     .LDPIPEEN               (1'b0            ),
//     .REGRST                 (1'b0            )
// );

// // RX_ER 输入打拍
// always_ff @(posedge i_sys_clk) begin
//     if (!i_rst_n)
//         o_rx_er <= 1'b0;
//     else
//         o_rx_er <= rxer_delayed;
// end

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////           ODDR TXD[7:0] + TXCTL        /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
assign o_gmii_tx_clk   = i_sys_clk; //gmii_rxc
assign o_gmii_tx_data  = i_tx_data;
assign o_gmii_tx_err   = 1'b0;
assign o_gmii_tx_valid = i_tx_en;

endmodule
