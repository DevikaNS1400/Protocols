module apb_slave(
  
input pclk,preset,
  
//APB Bus input from master to slave
input pwrite, psel, penable, 
input  [31:0] paddr, pwdata,
 
//APB Bus Outputs from slave to master
output reg   pready,
output  [31:0] prdata);
    
reg [31:0] mem [0:31]; 
reg ready_d;//To track internal wait state

assign prdata=(psel&&penable)?mem[paddr[4:0]]:32'b0;
  
integer i;

always @(posedge pclk or negedge preset) begin
    if(!preset) begin
       pready <=1'b0;
       ready_d<=1'b0;
      
      for(i=0;i<32;i=i+1)begin
        mem[i]<=32'b0;
      end
    end
     
     else begin
          if(psel && penable) begin
           
             if(!ready_d) begin
                pready<=1'b0;
                ready_d<=1'b1;
             end
            
             else begin
               pready<=1'b1;
                
                 if(pwrite) begin
                   mem[paddr[4:0]] <= pwdata; 
                 end
             end 
          end
       
      else begin
        pready <= 1'b0;
        ready_d <=1'b0;
      end
     end
end

endmodule
