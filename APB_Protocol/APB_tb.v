`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 10:07:43 PM
// Design Name: 
// Module Name: tb_apb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:Final
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_apb;
reg preset,pclk,swrite,ptransfer;
reg [31:0] SADDR;
reg [31:0] SWDATA;
wire [31:0] f_data;
wire pready;
    
apb_top DUT (.preset(preset),
.pclk(pclk),
.swrite(swrite),
.ptransfer(ptransfer),
.SADDR(SADDR),
.SWDATA(SWDATA),
.f_data(f_data),
.pready(pready));

initial begin
pclk = 0;
forever #5 pclk = ~pclk;
end

initial begin
$monitor("Time=%0t | SADDR=%h SWDATA=%h swrite=%b ptransfer=%b pready=%b f_data=%h",$time, SADDR, SWDATA, swrite, ptransfer, pready, f_data);
end

initial begin
preset = 0;
swrite = 0;
ptransfer = 0;
SADDR = 0;
SWDATA = 0;
#15;
preset = 1;

SADDR = 32'h00000004;
SWDATA = 32'h1234;
swrite = 1;
ptransfer = 1;
 #20;

SADDR = 32'h00000003;
SWDATA = 32'h2234;
swrite = 1;
ptransfer = 1;
 #20;
 
 SADDR = 32'h0000000a;
SWDATA = 32'h1334;
swrite = 1;
ptransfer = 1;
 #20;
 
 SADDR = 32'h00000003;
//SWDATA = 32'h2234;
swrite = 0;
ptransfer = 1;
 #20;
 
ptransfer = 0;
SADDR = 32'h00000008;
SWDATA = 32'h1337;
swrite = 1;
ptransfer = 1;
#20;

SADDR = 32'h0000000a;
//SWDATA = 32'h2234;
swrite = 0;
ptransfer = 1;
 #20;
 
ptransfer = 0;
#50;
 $display("F_data = %h", f_data);
 $finish;
end

endmodule
