`timescale 1ns / 1ps

module tb_apb;
reg preset,pclk,swrite,ptransfer;
reg [31:0] SADDR;
reg [31:0] SWDATA;
wire [31:0] f_data;
wire pready_out;
    
apb_top DUT (.preset(preset),
             .pclk(pclk),     
.swrite(swrite),
.ptransfer(ptransfer),
.SADDR(SADDR),
.SWDATA(SWDATA),
.f_data(f_data),
.pready_out(pready_out));

initial begin
pclk = 0;
forever #5 pclk = ~pclk;
end

initial begin
  $monitor("Time=%0t | SADDR=%h SWDATA=%h swrite=%b ptransfer=%b pready_out=%b f_data=%h",$time, SADDR, SWDATA, swrite, ptransfer, pready_out, f_data);
end

initial begin
preset = 0;
swrite = 0;
ptransfer = 0;
SADDR = 0;
SWDATA = 0;
#15;
preset = 1;

@(posedge pclk);
  //Transaction 1: Write to the given address
SADDR = 32'h00000004;
SWDATA = 32'h1234;
swrite = 1;
ptransfer = 1;

  @(posedge pclk);//SETUP
  @(posedge pclk);//ACCESS Stall
  @(posedge pclk);//ACCESS Complete
  @(posedge pclk);
  //Transaction 2:Write to the given address
SADDR = 32'h00000003;
SWDATA = 32'h2234;
swrite = 1;
ptransfer = 1;

@(posedge pclk);
@(posedge pclk);
@(posedge pclk);
 
  //Transaction 3:Write to the given address
SADDR = 32'h0000000a;
SWDATA = 32'h1334;
swrite = 1;
ptransfer = 1;
  
@(posedge pclk);
@(posedge pclk);
@(posedge pclk);
 
  //Transaction 4:Read from the given address
SADDR = 32'h00000003;
swrite = 0;
ptransfer = 1;
  
@(posedge pclk);
@(posedge pclk);
@(posedge pclk);
 
  //Go to the idle state
ptransfer = 0;
@(posedge pclk);

  
  //Transaction 5:Write to the given address
SADDR = 32'h00000008;
SWDATA = 32'h1337;
swrite = 1;
ptransfer = 1;

@(posedge pclk);
@(posedge pclk);
@(posedge pclk);
 
  //Transaction 6:Read from the given address
SADDR = 32'h00000004;
swrite = 0;
ptransfer = 1;
@(posedge pclk);
@(posedge pclk);
@(posedge pclk);

 //Return to idle state
//ptransfer = 0;
@(posedge pclk);
ptransfer = 0;
$display("F_data = %h", f_data);
end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    #1000;
    $finish;
  end
endmodule
