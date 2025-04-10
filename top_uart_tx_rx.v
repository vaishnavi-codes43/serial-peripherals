module Top_UART(
  input    clk, 
  input    rst, // reset switch
  input   wire  uart_rx_in, // UART Recieve pin.
  output  wire  uart_tx_out, // UART transmit pin.
  output wire done
    );
    
wire [7:0] uart_rx_data;  


 UART_tx uart_tx_ins (.clk(clk_out1),.rst(rst),.uart_tx_out(uart_tx_out));
 UART_rx uart_rx_ins (.clk(clk_out1),.rst(rst),.uart_rx_in(uart_rx_in),
             .uart_rx_data(uart_rx_data),.done(done));
   
    ila_0 uart_ila (
	.clk(clk), 
	.probe0(clk_out1), 
	.probe1(rst), 
	.probe2(uart_rx_in), 
	.probe3(uart_tx_out),
	.probe4(uart_rx_data),
	.probe5(done)
     );
     
   clk_wiz_0 clk_10mhz (
    .clk_out1(clk_out1),          
    .clk_in1(clk)      
    ); 
endmodule