`timescale 1ns / 1ps



module SPI_slave( clk,sclk,ss,mosi,miso,mosi_data);
input clk,sclk,ss;
input mosi;
output reg miso;
output reg [15:0] mosi_data=0;
reg [3:0] bit_count;
reg [3:0] bit_count1;
reg [15:0] tx_buf=0;//transmit data slave output
reg [15:0] rx_buf=0;// receive data slave input




//**MOSI**//
always@(negedge sclk) begin
if(ss==0) begin
     if(bit_count==0) begin
        mosi_data<=rx_buf;
        bit_count<=15;
      end
      else
       bit_count<=bit_count-1;
       rx_buf[bit_count]<= mosi;    
 end
  else begin
   bit_count<=15;
   rx_buf<=0;
  end
end


/*** MISO ***/

always@(posedge sclk) begin
 if(ss==0) begin
   tx_buf<=rx_buf;
    if(bit_count1==0) begin   
        bit_count1<=15;
    end  
     else
       bit_count1<=bit_count1-1;
       miso<= tx_buf[bit_count1];  
  end
   else begin
   bit_count1<=15;
   tx_buf<=0;
  end

end  
endmodule



