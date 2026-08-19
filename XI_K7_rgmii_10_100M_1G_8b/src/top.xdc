set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# HDU 7K325T K2
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  V19} [get_ports {i_rst_n}]
# HDU 7K325T UART NC
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN U27} [get_ports {i_uart_rx}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN U28} [get_ports {o_uart_tx}]
# HDU 7K325T 
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  N21} [get_ports {o_rgmii_rst_n}]
# HDU 7K325T U11
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  K28} [get_ports {i_rgmii_rxc}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  K29} [get_ports {i_rgmii_rxctl}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  M28} [get_ports {i_rgmii_rxd[0]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  L28} [get_ports {i_rgmii_rxd[1]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  M29} [get_ports {i_rgmii_rxd[2]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  M30} [get_ports {i_rgmii_rxd[3]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  K30} [get_ports {o_rgmii_txc}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  L30} [get_ports {o_rgmii_txctl}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  J29} [get_ports {o_rgmii_txd[0]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  H29} [get_ports {o_rgmii_txd[1]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  J27} [get_ports {o_rgmii_txd[2]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  J28} [get_ports {o_rgmii_txd[3]}]


set_property SLEW FAST [get_ports {o_rgmii_txd[*]}]
set_property SLEW FAST [get_ports o_rgmii_txc]
set_property SLEW FAST [get_ports o_rgmii_txctl]
create_clock -period 8.000 -name rx_clk [get_ports i_rgmii_rxc]