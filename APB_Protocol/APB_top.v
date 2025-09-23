`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Swetha S
// 
// Create Date: 08/28/2025 10:06:21 PM
// Design Name: 
// Module Name: apb_top
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


module apb_top(
input preset,pclk,swrite,ptransfer,
input [31:0] SADDR,
input [31:0] SWDATA,
output [31:0] f_data,
output pready
);
wire pwrite, psel, penable;
wire [31:0] paddr, pwdata,srdata;

apb_master U_master (.pwrite(pwrite),
.psel(psel),
.penable(penable),
.paddr(paddr),
.pwdata(pwdata),
.SWDATA(SWDATA),
.SADDR(SADDR),
.SRDATA(srdata),
.prdata(f_data),
.preset(preset),
.pclk(pclk),
.swrite(swrite),
.ptransfer(ptransfer),
.pready(pready)
);

spb_slave U_slave (.pwrite(pwrite),
.psel(psel),
.penable(penable),
.pclk(pclk),
.preset(preset),
.paddr(paddr),
.pwdata(pwdata),
.pready(pready),
.prdata(srdata));

endmodule
