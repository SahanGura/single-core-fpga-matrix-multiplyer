`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module mux2_tb();

    // reg clk;
	reg [15:0] in1;
    reg [15:0] in2;
    reg sel;
    wire [15:0] out;

    // always
    //     begin
    //         #10 clk = 1'd1;
    //         #10 clk = 1'd0;
    //     end

    localparam period = 10; 

    mux2 dut(
        .in1(in1),
        .in2(in2),
        .sel(sel),
        .out(out)
    );

    initial 
        begin
           #10;
            
            in1 = 16'd10;
            in2 = 16'd1;
            sel = 0;
            #period;

            in1 = 16'd10;
            in2 = 16'd1;
            sel = 1;
            #period;

            in1 = 16'd0;
            in2 = 16'd231;
            sel = 0;
            #period;

            in1 = 16'd10;
            in2 = 16'd1;
            sel = 1;
            #period;

            $stop;

            

        end

        
endmodule