`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2024 10:53:12
// Design Name: 
// Module Name: SPI_master
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


module SPI_master(
   input sclk,
   output reg  ss,
   output reg MOSI, 
   input MISO
   );
    

    integer i;
    reg [5:0] bit_count;
    reg [7:0] clk_count;
    reg [5:0] sw_bit_count;                                                                                       
    reg  [6:0] present_state;
    reg [3:0] byte_count;
    reg  adrs_data; 
    reg [23:0] sw_buf_data;
    reg [7:0] MOSI_data = 8'hbc;
    reg [16:0] buffer;
    reg [31:0] sr_data_out;
    reg [100:0] br_data_out;
    reg [5:0] sr_bit_count;
    reg [7:0] br_bit_count;
    reg [15:0] burst_buffer;
    reg [13:0] adrs_i = 14'h0;
    reg [7:0] data [0:9];
    reg [3:0] adrs_count ;

    parameter idle = 0;
    parameter read_write = 1;
    parameter burst_write = 2;  
    parameter single_write = 3;
    parameter burst_read = 4;
    parameter single_read = 5;
    parameter tx_end = 6;
    
  wire en;  
  wire ainc;
  wire r_w ;
  
  
 vio_0 spi_vio (
  .clk(sclk),                
  .probe_out0(en),
  .probe_out1(ainc),
  .probe_out2(r_w)  
);   
    
  
   
always@(negedge sclk) begin   

if (en) begin
   case(present_state) 
     idle:begin 
        ss<='b1;
        byte_count <= 'b0;
        adrs_count <='d15;
        clk_count <='d0;
        sw_bit_count <= 'd32;
        sr_bit_count <= 'd32;
        br_bit_count <= 'd0;
        burst_buffer<='d0;
        buffer<='b0;
        bit_count<='d7; 
        sr_data_out<= 'd0;
        br_data_out<= 'd0;
        present_state<= read_write;
     end
     
     read_write : begin
         case ( {r_w,ainc}) 
         2'b00 : present_state <= single_write; 
         2'b01 : present_state <= burst_write; 
         2'b10 :present_state <= single_read;
         2'b11 :present_state <= burst_read; 
         default :  present_state <= idle; 
        endcase
     end
     burst_write: begin
        ss<=0;
        burst_buffer[15] <= 0; // r/w
		burst_buffer[14] <= 1;  // AINC  
		burst_buffer[13:0] <= adrs_i;
	
		  clk_count<=1'b0;
	      clk_count<=clk_count+1'b1; 
	      
        adrs_data<= burst_buffer[adrs_count];
        adrs_count <= adrs_count-1;
        
		for( i=0; i<=9 ; i=i+1) begin     
           data[i] <= i;   
        end
        
        
         bit_count <= 'd7;
        if ( clk_count <17 ) begin
             MOSI<=adrs_data;
        end  
        else if (byte_count < 10 ) begin
            MOSI <=  data[byte_count][bit_count]; 
            bit_count <= bit_count - 1;
            if (bit_count == 0) begin
                bit_count <= 7;
                byte_count <= byte_count + 1;    
            end
         end else begin
          MOSI <= 'b0;
         end
 
          if( clk_count > 100) begin
             present_state<= tx_end;
           end
          else
             present_state <= burst_write; 
      end

     single_write: begin
       
        ss<=0; 
        buffer[15] <= 0; // r/w
		buffer[14] <= 0;  // AINC  
		buffer[13:0] <= adrs_i;
         sw_buf_data <={buffer, MOSI_data};	 
         MOSI<= sw_buf_data[sw_bit_count];
         sw_bit_count<=sw_bit_count-1'b1;
          if( sw_bit_count==0 ) 
             present_state<= tx_end;
          else
             present_state<=single_write; 
      end
    
    burst_read : begin
       //if(ss==1'b0) 
         
       if ( clk_count >16 ) begin
         br_data_out[br_bit_count] <= MISO;
         br_bit_count <=br_bit_count+1;
    
        end
        else begin
         clk_count <= clk_count+1;
        end
    end
    
    single_read : begin
      // if(ss==1'b0) 
         
       if ( clk_count >16 ) begin
         sr_data_out[sr_bit_count] <= MISO;
         sr_bit_count <=sr_bit_count-1;
        end
        else begin
         clk_count <= clk_count+1;
        end
    end
    
      tx_end: begin
          clk_count<=0;
          ss<= 'b1;
          MOSI<=0;
          present_state<=idle;
      end
      
      default : begin
         present_state<=idle;
      end
      
   endcase
  end
end
endmodule
