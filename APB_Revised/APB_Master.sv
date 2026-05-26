`timescale 1ns / 1ps
module apb_master(
  
   //Clock and active-low async reset
   input preset, pclk,
   //APB Bus outputs (to slave)
    output reg  pwrite, psel, penable,
    output reg [31:0] paddr, pwdata,
  
    //User side output
    output reg [31:0]prdata,
  
    //User side inputs
    input  [31:0] SWDATA, SADDR,
    input swrite, ptransfer,
   
    //APB Bus inputs from slave
    input pready,
    input [31:0] SRDATA   
);
  
 reg [1:0] state, nextstate;
 parameter idle=2'b00, setup=2'b01, access=2'b10;
 
  always @(posedge pclk or negedge preset) begin
         if(!preset) begin
               state   <= idle;
                     end 
    
         else begin
               state <= nextstate;
              end
  end

  
  //Nest state logic
    always @(*) begin
       nextstate = state;

       case(state)
         
         //IDLE STATE
          idle: begin
                  if(ptransfer) begin
                        nextstate = setup;
                                end 
     
                  else begin
                 nextstate = idle;
                       end
                end
         //SETUP STATE
          setup: begin
                 nextstate = access;
                 end
    
         //ACCESS STATE
          access: begin
                 if(pready) begin
                    if(ptransfer)
                       nextstate = setup;
                    else
                       nextstate = idle;
                            end 
                 else begin
                       nextstate = access;
                      end
                  end
         default:nextstate=idle;
       endcase      
end
  //Sequential Output Logic
  always@(posedge pclk or negedge preset)begin
    if(!preset)begin
         psel<=1'b0;
         penable<=1'b0;
         pwrite<=1'b0;
         paddr<=32'b0;
         pwdata<=32'b0;
    end
    
    else begin
      case(state)
        idle:begin
              psel<=1'b0;
              penable<=1'b0;
        end
        
        setup:begin
             psel<=1'b1;
             penable<=1'b0;
             pwrite<=swrite;
             paddr<=SADDR;
             pwdata<=SWDATA;
        end
        
        access:begin
          if(pready)begin
             penable<=1'b0;
            if(ptransfer)begin
              psel<=1'b1;
              pwrite<=swrite;
              paddr<=SADDR;
              pwdata<=SWDATA;
            end
            else begin
              psel<=1'b0;
            end
         
        end
          else begin
            psel<=1'b1;
            penable<=1'b1;
          end
        end
        default:begin
          psel<=1'b0;
          penable<=1'b0;
        end
        
      endcase
    end
  end
  //Read Data Capture block
  always@(posedge pclk or negedge preset)begin
    if(!preset)begin
      prdata<=32'b0;
               end
     
    else begin
      if((state==access)&& pready && !pwrite)begin
        $display($time,"Read activated");
         prdata<=SRDATA;
        $display($time,"Read activated prdata=%b,SRDATA=%b",prdata,SRDATA);
      end
    end
  end
  
endmodule
