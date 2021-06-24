module alu(input [15:0] in1,
	input [15:0] in2,
	input [2:0] alu_op,
	output [15:0] alu_out,
	output z );

	reg [15:0] alu_res;
	assign alu_out = alu_res;

	reg z_temp;
	assign z = z_temp;

	always @(*)
		begin
			case(alu_op)
			3'd0: alu_out = in1 + in2;
			3'd1: alu_out = in2 - in1;
			3'd2: alu_out = in1 * in2;
			3'd3: alu_out = in1 / in2;
			3'd4: alu_out = in2;
			default: alu_out = in1 + in2;
			endcase

			if (z_temp == 0)
				z_temp <= 1;
			else
				z_temp <= 0;
		end
endmodule


