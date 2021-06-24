module register_inc#(parameter data_width = 8)
(input clk, 
input we, 
input clr,
input inc,
input [data_width-1:0] data_in, 
output reg[data_width-1:0] data_out);
 
always @(posedge clk)
	begin 
		if(we==1)
			data_out <= data_in;
		else if(inc==1)
			data_out <= data_in + 8'd1;
		else if (clr==1)
			data_out <= 8'd0;
			
	end
endmodule
