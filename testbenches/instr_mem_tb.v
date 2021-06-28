`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module instr_mem_tb();

    reg clk;
	reg we;
	reg [15:0] w_instr;
	reg [7:0] w_addr, r_addr;
	wire [7:0] r_instr;

    always
        begin
            #10 clk = 1'd1;
            #10 clk = 1'd0;
        end

    instr_mem dut(
        .clk(clk),
        .we(we),
        .w_instr(w_instr),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .r_instr(r_instr)

    );

    initial 
        begin
            #10

            we = 0;
            r_addr = 8'd0;
            #20;

            we = 0;
            r_addr = 8'd1;
            #20;
            
            we = 0;
            r_addr = 8'd2;
            #20;
            
            we = 0;
            r_addr = 8'd3;
            #20;

            we = 0;
            r_addr = 8'd4;
            #20;

            we = 0;
            r_addr = 8'd5;
            #20;

            we = 0;
            r_addr = 8'd6;
            #20;

            we = 0;
            r_addr = 8'd7;
            #20;

            we = 0;
            r_addr = 8'd8;
            #20;

            $stop;    

        end

        
endmodule