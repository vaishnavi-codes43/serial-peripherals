`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2024 11:09:35
// Design Name: 
// Module Name: UART_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_tx(
 input clk,
 input rst,
 output reg uart_tx_out
    );
  
 reg [7:0] tx_buf = 8'h55;
 reg [10:0] baud_cnt;
 reg bit_flag ='d0;
 reg [3:0] bit_count ='d0;
 

 /** Baud count generation **/
always@(posedge clk ) begin
   if (! rst)
     baud_cnt <= 'd0;
   else if (baud_cnt == 'd1042) begin
          bit_flag <= 'd1;
          baud_cnt <= 'd0;
   end  
   else begin 
       bit_flag<='d0;
       baud_cnt <= baud_cnt + 1'b1;
   end
end

 /**Data  transmission **/
 always@(posedge clk) begin  
    if(!rst) 
      uart_tx_out <=1'b1;
    else if(bit_flag)begin      
      case(bit_count)
          4'd0: begin
           uart_tx_out<=1'b0; // start bit
          end
          4'd1: begin
           uart_tx_out <=tx_buf[0];
           end
          4'd2: begin
           uart_tx_out <=tx_buf[1];
           end
          4'd3: begin
           uart_tx_out <=tx_buf[2];
           end
          4'd4:  begin
           uart_tx_out <=tx_buf[3];
           end
          4'd5: begin
            uart_tx_out <=tx_buf[4];
           end
          4'd6: begin
            uart_tx_out <=tx_buf[5];
            end
          4'd7: begin
            uart_tx_out <=tx_buf[6];
           end
          4'd8: begin
            uart_tx_out <=tx_buf[7];
           end
          4'd9:  begin
             uart_tx_out <=1'b1; // stop bit
          end
          default : begin
            uart_tx_out<=1'b1;
           end
        endcase
      end
   end  
   
 /** incrementing bit count **/  
 always@(posedge clk) begin   
 if(bit_flag) begin
   if(bit_count==9) begin
         bit_count<='d0; 
    end
     else begin
          bit_count=bit_count+1;
     end 
   end
end
  
endmodule
