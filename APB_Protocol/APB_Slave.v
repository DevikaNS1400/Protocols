`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 10:04:45 PM
// Design Name: 
// Module Name: spb_slave
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
module spb_slave(
input pwrite, psel, penable, pclk, preset,
input  [31:0] paddr, pwdata,
output reg   pready,
output [31:0] prdata);
    
reg [31:0] mem [0:31]; 
reg [31:0] dout;
assign prdata = dout;

always @(*) begin
if(!preset) begin
pready = 0;
end 
else begin
   if(psel && penable) begin
      pready = 1;
        if(pwrite) begin
           mem[paddr[4:0]] = pwdata; 
        end
           else begin
           dout=mem[paddr[4:0]];  
        end
    end 

    else begin
        pready = 0;
    end
end
end

endmodule
