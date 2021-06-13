module bus( input clk,
 input [2:0] read_en,
 input [7:0] r,
 input [7:0] dr,
 input [15:0] tr,
 input [7:0] pc,
 input [15:0] ac,
 input [7:0] dm,
 input [7:0] im,
 output reg [15:0] busout ) ;
 
 always @( r or dr or tr or pc or ac or im or read_en or dm)
	begin
	 case(read_en)
	 4'd0: busout <= im ;
	 4'd1: busout <= pc;
	 4'd2: busout <= dr;
	 4'd4: busout <= tr;
	 4'd5: busout <= ac;
	 4'd6: busout <= r;
	 4'd7: busout <= dm + 8'd0; 
	 default: busout <= 8'd0;
	 endcase
	end
endmodule