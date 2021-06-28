module address_reg#(parameter data_width = 16)
(input clk, 
input we, 
input dm_addr,
input [data_width-1:0] data_in, 
output reg[data_width-1:0] data_out_im, data_out_dm);
 
always @(posedge clk)
	begin 
		if(we==1)
			begin
                if(dm_addr)
                    begin
			        data_out_dm <= data_in;
                    end
                else
                    begin
                    data_out_im <= data_in;
                    end
			end
	end
endmodule