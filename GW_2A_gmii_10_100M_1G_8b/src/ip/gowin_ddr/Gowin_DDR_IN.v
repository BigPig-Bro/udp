//
//Written by GowinSynthesis
//Product Version "V1.9.9 Beta-5"
//Sun Aug 23 01:04:07 2026

//Source file index table:
//file0 "\D:/Gowin/Gowin_V1.9.9Beta-5/IDE/ipcore/DDR/data/ddr.v"
`timescale 100 ps/100 ps
module Gowin_DDR_IN (
  din,
  clk,
  q
)
;
input [9:0] din;
input clk;
output [19:0] q;
wire \iodelay_gen[0].iodelay_inst_1_DF ;
wire \iodelay_gen[1].iodelay_inst_1_DF ;
wire \iodelay_gen[2].iodelay_inst_1_DF ;
wire \iodelay_gen[3].iodelay_inst_1_DF ;
wire \iodelay_gen[4].iodelay_inst_1_DF ;
wire \iodelay_gen[5].iodelay_inst_1_DF ;
wire \iodelay_gen[6].iodelay_inst_1_DF ;
wire \iodelay_gen[7].iodelay_inst_1_DF ;
wire \iodelay_gen[8].iodelay_inst_1_DF ;
wire \iodelay_gen[9].iodelay_inst_1_DF ;
wire [9:0] iodly_o;
wire VCC;
wire GND;
  IODELAY \iodelay_gen[0].iodelay_inst  (
    .DO(iodly_o[0]),
    .DF(\iodelay_gen[0].iodelay_inst_1_DF ),
    .DI(din[0]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[0].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[1].iodelay_inst  (
    .DO(iodly_o[1]),
    .DF(\iodelay_gen[1].iodelay_inst_1_DF ),
    .DI(din[1]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[1].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[2].iodelay_inst  (
    .DO(iodly_o[2]),
    .DF(\iodelay_gen[2].iodelay_inst_1_DF ),
    .DI(din[2]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[2].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[3].iodelay_inst  (
    .DO(iodly_o[3]),
    .DF(\iodelay_gen[3].iodelay_inst_1_DF ),
    .DI(din[3]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[3].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[4].iodelay_inst  (
    .DO(iodly_o[4]),
    .DF(\iodelay_gen[4].iodelay_inst_1_DF ),
    .DI(din[4]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[4].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[5].iodelay_inst  (
    .DO(iodly_o[5]),
    .DF(\iodelay_gen[5].iodelay_inst_1_DF ),
    .DI(din[5]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[5].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[6].iodelay_inst  (
    .DO(iodly_o[6]),
    .DF(\iodelay_gen[6].iodelay_inst_1_DF ),
    .DI(din[6]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[6].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[7].iodelay_inst  (
    .DO(iodly_o[7]),
    .DF(\iodelay_gen[7].iodelay_inst_1_DF ),
    .DI(din[7]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[7].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[8].iodelay_inst  (
    .DO(iodly_o[8]),
    .DF(\iodelay_gen[8].iodelay_inst_1_DF ),
    .DI(din[8]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[8].iodelay_inst .C_STATIC_DLY=79;
  IODELAY \iodelay_gen[9].iodelay_inst  (
    .DO(iodly_o[9]),
    .DF(\iodelay_gen[9].iodelay_inst_1_DF ),
    .DI(din[9]),
    .SDTAP(GND),
    .VALUE(GND),
    .SETN(GND) 
);
defparam \iodelay_gen[9].iodelay_inst .C_STATIC_DLY=79;
  IDDR \iddr_gen[0].iddr_inst  (
    .Q0(q[0]),
    .Q1(q[10]),
    .D(iodly_o[0]),
    .CLK(clk) 
);
  IDDR \iddr_gen[1].iddr_inst  (
    .Q0(q[1]),
    .Q1(q[11]),
    .D(iodly_o[1]),
    .CLK(clk) 
);
  IDDR \iddr_gen[2].iddr_inst  (
    .Q0(q[2]),
    .Q1(q[12]),
    .D(iodly_o[2]),
    .CLK(clk) 
);
  IDDR \iddr_gen[3].iddr_inst  (
    .Q0(q[3]),
    .Q1(q[13]),
    .D(iodly_o[3]),
    .CLK(clk) 
);
  IDDR \iddr_gen[4].iddr_inst  (
    .Q0(q[4]),
    .Q1(q[14]),
    .D(iodly_o[4]),
    .CLK(clk) 
);
  IDDR \iddr_gen[5].iddr_inst  (
    .Q0(q[5]),
    .Q1(q[15]),
    .D(iodly_o[5]),
    .CLK(clk) 
);
  IDDR \iddr_gen[6].iddr_inst  (
    .Q0(q[6]),
    .Q1(q[16]),
    .D(iodly_o[6]),
    .CLK(clk) 
);
  IDDR \iddr_gen[7].iddr_inst  (
    .Q0(q[7]),
    .Q1(q[17]),
    .D(iodly_o[7]),
    .CLK(clk) 
);
  IDDR \iddr_gen[8].iddr_inst  (
    .Q0(q[8]),
    .Q1(q[18]),
    .D(iodly_o[8]),
    .CLK(clk) 
);
  IDDR \iddr_gen[9].iddr_inst  (
    .Q0(q[9]),
    .Q1(q[19]),
    .D(iodly_o[9]),
    .CLK(clk) 
);
  VCC VCC_cZ (
    .V(VCC)
);
  GND GND_cZ (
    .G(GND)
);
  GSR GSR (
    .GSRI(VCC) 
);
endmodule /* Gowin_DDR_IN */
