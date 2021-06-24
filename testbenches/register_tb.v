`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module register_tb ();

    
    reg data_width = 8;
    reg clk;
    reg we;
    reg [7:0] data_in; 
    wire [7:0] data_out;

    always
        begin
            #10 clk = 1'd1;
            #10 clk = 1'd0;
        end
    localparam period = 20; 

    register dut(
        .clk(clk),
        .we(we),
        .data_in(data_in),
	     .data_out(data_out)
    );

    initial 
        begin
            #period;

            we = 1;
            data_in = 8'd1;
            #period;

            we = 0;
            data_in = 8'd2;
            #period;

            we = 0;
            data_in = 8'd5;
            #period;
				
				we = 1;
            data_in = 8'd7;
            #period;
			$stop;

        end
    
    
endmodule