module bus( input clk,
 input [3:0] read_en,
 input [7:0] r,
 input [7:0] dr,
 input [15:0] tr,
 input [7:0] pc,
 input [15:0] ac,
 input [7:0] dm,
 input [7:0] im,
 input [7:0] r1,
 input [7:0] r2,
 input [7:0] ri,
 input [7:0] rj,
 input [7:0] rk,
 
 output reg [15:0] busout ) ;
 
 always @( r or dr or tr or pc or ac or im or read_en or dm)
	begin
	 case(read_en)
	 4'd0: busout <= im ;
	 4'd1: busout <= dm + 8'd0 ;
	 4'd2: busout <= pc;
	 4'd3: busout <= dr;
	 4'd4: busout <= r;
	 4'd5: busout <= ac;
	 4'd6: busout <= tr;
	 4'd7: busout <= r1;
	 4'd8: busout <= r2;
	 4'd9: busout <= ri;
	 4'd10: busout <= rj;
	 4'd11: busout <= rk;
	 default: busout <= 8'd0;
	 endcase
	end
endmodule
