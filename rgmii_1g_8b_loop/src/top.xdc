set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# XI050AB
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  U17} [get_ports {i_rst_n}]
# XI050AB
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  H2} [get_ports {o_rgmii_rst_n}]
# XI050AB UART
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN J6} [get_ports {i_uart_rx}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN J5} [get_ports {o_uart_tx}]
# XI050AB RJ2
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  H4} [get_ports {i_rgmii_rxc}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  F1} [get_ports {i_rgmii_rxctl}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  E3} [get_ports {i_rgmii_rxd[0]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  E2} [get_ports {i_rgmii_rxd[1]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  E1} [get_ports {i_rgmii_rxd[2]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  F3} [get_ports {i_rgmii_rxd[3]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  A1} [get_ports {o_rgmii_txc}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  D1} [get_ports {o_rgmii_txctl}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  B2} [get_ports {o_rgmii_txd[0]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  B1}  [get_ports {o_rgmii_txd[1]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  C2} [get_ports {o_rgmii_txd[2]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  D2} [get_ports {o_rgmii_txd[3]}]
# # XI050AB RJ1
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  L3} [get_ports {i_rgmii_rxc}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  R1} [get_ports {i_rgmii_rxctl}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  N2} [get_ports {i_rgmii_rxd[0]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  N3} [get_ports {i_rgmii_rxd[1]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  P1} [get_ports {i_rgmii_rxd[2]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  P2} [get_ports {i_rgmii_rxd[3]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  M6} [get_ports {o_rgmii_txc}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  N5} [get_ports {o_rgmii_txctl}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  M5} [get_ports {o_rgmii_txd[0]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  M2}  [get_ports {o_rgmii_txd[1]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  N4} [get_ports {o_rgmii_txd[2]}]
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  P4} [get_ports {o_rgmii_txd[3]}]

# # XI050CD
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  V18} [get_ports {i_rst_n}]
# # XI050CD
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  W22} [get_ports {o_rgmii_rst_n}]
# # XI050CD UART
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN R16} [get_ports {i_uart_rx}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN V17} [get_ports {o_uart_tx}]
# # # XI050CD U11
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  V4} [get_ports {i_rgmii_rxc}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA1} [get_ports {i_rgmii_rxctl}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB1} [get_ports {i_rgmii_rxd[0]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB2} [get_ports {i_rgmii_rxd[1]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  Y3} [get_ports {i_rgmii_rxd[2]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB3} [get_ports {i_rgmii_rxd[3]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  W4} [get_ports {o_rgmii_txc}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  Y4} [get_ports {o_rgmii_txctl}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA3} [get_ports {o_rgmii_txd[0]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA4} [get_ports {o_rgmii_txd[1]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB5} [get_ports {o_rgmii_txd[2]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA5} [get_ports {o_rgmii_txd[3]}]
# # XI050CD U13
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  Y18} [get_ports {i_rgmii_rxc}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB18} [get_ports {i_rgmii_rxctl}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA18} [get_ports {i_rgmii_rxd[0]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  Y19} [get_ports {i_rgmii_rxd[1]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA19} [get_ports {i_rgmii_rxd[2]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB20} [get_ports {i_rgmii_rxd[3]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  W20} [get_ports {o_rgmii_txc}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA20} [get_ports {o_rgmii_txctl}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB21} [get_ports {o_rgmii_txd[0]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AA21} [get_ports {o_rgmii_txd[1]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN AB22} [get_ports {o_rgmii_txd[2]}]
# set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN  Y21} [get_ports {o_rgmii_txd[3]}]




set_property SLEW FAST [get_ports {o_rgmii_txd[*]}]
set_property SLEW FAST [get_ports o_rgmii_txc]
set_property SLEW FAST [get_ports o_rgmii_txctl]
create_clock -period 8.000 -name rx_clk [get_ports i_rgmii_rxc]
create_clock -period 8.000 -name tx_clk [get_ports o_rgmii_txc]