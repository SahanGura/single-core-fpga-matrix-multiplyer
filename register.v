module register#(parameter data_width = 8)
(input clk, 
input we, 
input [data_width-1:0] data_in, 
output reg[data_width-1:0] data_out);
 
always @(posedge clk)
	begin 
		if(we==1)
			data_out <= data_in;
	end
endmodule