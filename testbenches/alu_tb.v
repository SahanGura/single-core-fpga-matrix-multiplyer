`timescale 1ns/1ps  // time-unit = 1 ns, precision = 10 ps

module alu_tb();

	reg clock;
   reg [15:0] in1;
	reg [15:0] in2; 
	reg [2:0] alu_op;
	wire [15:0] alu_out;
	wire z;

    always
        begin
            #10 clock = 1'd1;
            #10 clock = 1'd0;
        end
    localparam period = 20; 

    alu dut(
        .in1(in1),
        .in2(in2),
        .alu_op(alu_op),
        .alu_out(alu_out),
        .z(z)
    );

    initial 
        begin
            #70;
            
            in1 = 16'd1;
            in2 = 16'd2;
            alu_op = 2'd0;
            #period;

            in1 = 16'd20;
            in2 = 16'd100;
            alu_op = 2'd0;
            #period;

            in1 = 16'd3;
            in2 = 16'd3;
            alu_op = 2'd1;
            #period;

            in1 = 16'd5;
            in2 = 16'd6;
            alu_op = 2'd2;
            #period;

            in1 = 16'd2;
            in2 = 16'd8;
            alu_op = 2'd1;
            #period;

            in1 = 16'd10;
            in2 = 16'd1;
            alu_op = 2'd3;
            #period;

            in1 = 16'd1;
            in2 = 16'd1;
            alu_op = 2'd0;
            #period;
				
			$stop;

        end

        
endmodule