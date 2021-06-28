`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module data_mem_tb();

    reg clk;
	reg we;
	reg [15:0] w_data;
	reg [7:0] w_addr, r_addr;
	wire [7:0] r_data;

    always
        begin
            #10 clk = 1'd1;
            #10 clk = 1'd0;
        end

    data_mem dut(
        .clk(clk),
        .we(we),
        .w_data(w_data),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .r_data(r_data)

    );

    initial 
        begin
            #10

            we = 0;
            r_addr = 8'd0;
            #40;

            we = 0;
            r_addr = 8'd1;
            #40;
            
            we = 0;
            r_addr = 8'd2;
            #40;
            
            we = 0;
            r_addr = 8'd3;
            #40;

            we = 1;
            w_data = 8'd15;
            w_addr = 8'd30;
            r_addr = 8'd30;
            #40;

            we = 1;
            w_data = 8'd16;
            w_addr = 8'd31;
            r_addr = 8'd31;
            #40;

            we = 1;
            w_data = 8'd17;
            w_addr = 8'd32;
            r_addr = 8'd32;
            #40;

            $stop;    

        end

        
endmodule