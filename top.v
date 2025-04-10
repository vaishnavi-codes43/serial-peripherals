`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2024 15:38:12
// Design Name: 
// Module Name: top
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


module top(
   input clk,
   output ss,
   input MISO,
   output clk_10mhz,
   output MOSI
);

reg [3:0] byte_count;

 clk_wiz_0 clk_wiz10mhz( .clk_out1(clk_10mhz), .clk_in1(clk) );
 
 SPI_master spi_ins (clk_10mhz,ss,MOSI,MISO);
  
 
 ila_0 spi_ila (
	.clk(clk_10mhz), 
	.probe0(clk_10mhz), 
	.probe1(MISO),  
	.probe2(ss),
	.probe3(MOSI),
	.probe4(byte_count)
	
);
 
 
endmodule
