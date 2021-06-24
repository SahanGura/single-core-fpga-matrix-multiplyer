`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module register_inc_tb ();

    
    reg data_width = 8;
    reg clk;
    reg we;
    reg clr;
    reg inc;
    reg [7:0] data_in; 
    wire [7:0] data_out;

    always
        begin
            #10 clk = 1;
            #10 clk = 0;
        end
    localparam period = 20; 

    register_inc dut(
        .clk(clk),
        .we(we),
        .clr(clr),
        .inc(inc),
        .data_in(data_in),
		  .data_out(data_out)
    );

    initial 
        begin
            #period;

            we = 1;
            clr = 0;
            inc = 1;
            data_in = 8'd1;
            #period;

            we = 0;
            clr = 0;
            inc = 1;
            data_in = 8'd2;
            #period;

            we = 0;
            clr = 1;
            inc = 0;
            data_in = 8'd5;
            #period;
				
            we = 1;
            clr = 0;
            inc = 0;
            data_in = 8'd12;
            #period;
				
            we = 0;
            clr = 1;
            inc = 0;
            data_in = 8'd5;
            #period;
				
            we = 0;
            clr = 1;
            inc = 1;
            data_in = 8'd5;
            #period;
				
				$stop;

        end
    
    
endmodule