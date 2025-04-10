`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2024 15:54:55
// Design Name: 
// Module Name: uart_rx
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

module UART_rx(
   input clk,
   input rst,
   input uart_rx_in,
   output reg done,
   output reg [7:0] uart_rx_data
    );
    
 reg uart_rx_reg;
 reg rx_reg1;
 reg rx_reg2;
 reg [10:0] baud_cnt;
 reg bit_flag ='d0;
 reg [3:0] bit_count;

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

/** Adding dealy to rx input**/
 always@(posedge clk) begin  
  if(!rst) begin
    uart_rx_reg<='b0;
//    rx_reg1 <='b0;
//    rx_reg2<='b0;
  end
  else begin
//    rx_reg1 <=uart_rx_in;
//    rx_reg2<=rx_reg1;
    uart_rx_reg<= uart_rx_in;
  end
 end
 
  /** Data reception**/
 always@(posedge clk) begin
   if(!rst) begin
      uart_rx_data<='b0;
   end
   else if(bit_flag)begin  
        case(bit_count)
          4'd1: begin
            uart_rx_data[0]<= uart_rx_reg; 
           end
          4'd2: begin
            uart_rx_data[1] <= uart_rx_reg;
           end
          4'd3: begin
            uart_rx_data[2] <= uart_rx_reg;
           end
          4'd4: begin
            uart_rx_data[3] <= uart_rx_reg;
           end
          4'd5:  begin
            uart_rx_data[4] <= uart_rx_reg;
           end
          4'd6: begin
            uart_rx_data[5] <= uart_rx_reg;
           end
          4'd7: begin
            uart_rx_data[6] <= uart_rx_reg;
           end
          4'd8: begin
            uart_rx_data[7] <= uart_rx_reg;
           end
          default : begin
            uart_rx_data<=uart_rx_data; 
           end
        endcase
       end  
    end 
    
    
 always@(posedge clk) begin   
  if(bit_flag) begin
    if(bit_count==9) begin
        bit_count<='d0; 
        done<='b1;   
        end
       else begin
          bit_count=bit_count+1;
          done<='b0;
      end 
   end
end
 
endmodule

