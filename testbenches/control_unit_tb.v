`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module control_unit_tb();

    reg [7:0] ir;
    reg clk;
    reg z;

    wire end_op; wire [1:0] inc; wire [3:0] alu_mode; wire [3:0] bus_ld;
    wire [12:0] write_en; wire [2:0] clr; wire dm_wr ;wire  im_wr;

    always
        begin
            #10 clk = 1'd1;
            #10 clk = 1'd0;
        end

    localparam period = 20; 

    control_unit dut(
        .clk(clk),
        .ir(ir),
        .z(z),
        .end_op(end_op),
        .inc(inc),
        .alu_mode(alu_mode),
        .bus_ld(bus_ld),
        .write_en(write_en),
        .clr(clr),
        .dm_wr(dm_wr),
        .im_wr(im_wr)
    );

    initial 
        begin

            #60;
				
            ir = 8'd1;
            z = 0;
            #period;

            ir = 8'd2;
            z = 0;
            #period;

            ir = 8'd3;
            z = 0;
            #period;

            ir = 8'd4;
            z = 0;
            #period;

            $stop;


            
        end

endmodule


