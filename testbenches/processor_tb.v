`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module processor_tb();
    reg clk = 1'b1;
    wire [15:0] to_mem;


    always
        begin
            #10 clk = 1'b0;
            #10 clk = 1'b1;
        end

    localparam period = 20; 

    processor dut(
        .clk(clk),
        .to_mem(to_mem)
    );

    initial 
        begin
            #period;

            #200000;

            $stop;
            
        end

endmodule


