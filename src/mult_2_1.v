module mult_2_1(
input [15:0] in1,
input [15:0] in2,
input sel,
input clk,
output reg [15:0] out);

always@(posedge clk)
begin
	if (sel==1)
		out <= in2;
	else
		out <= in1;
end
endmodule


