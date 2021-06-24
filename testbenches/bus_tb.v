`timescale 1ns/1ps  // time-unit = 1 ns, precision = 10 ps

module bus_tb ();
    reg clk;
    reg [3:0] read_en;
    reg [7:0] r;
    reg [7:0] dr;
    reg [15:0] tr;
    reg [7:0] pc;
    reg [15:0] ac;
    reg [7:0] dm;
    reg [7:0] im;
	 reg [7:0] r1;
	 reg [7:0] r2;
	 reg [7:0] ri;
	 reg [7:0] rj;
    reg [7:0] rk;
    wire [15:0] busout;

    always
        begin
            #10 clk = 1'd1;
            #10 clk = 1'd0;
        end
    localparam period = 20; 

    bus dut(
        .read_en(read_en),
        .r(r),
        .dr(dr),
        .tr(tr),
        .pc(pc),
        .ac(ac),
        .dm(dm),
        .im(im),
		  .r1(r1),
		  .r2(r2),
		  .ri(ri),
		  .rj(rj),
		  .rk(rk),
		  .out(busout)
    );

    initial 
        begin
        
            #20;
            read_en = 3'd0;
				r = 8'd10;
				dr = 8'd11;
				tr = 16'd12;
				pc = 8'd13;
				ac = 16'd14;
				dm = 8'd09;
				im = 8'd08;
				r1 = 8'd15;
				r2 = 8'd16;
				ri = 8'd17;
				rj = 8'd18;
				rk = 8'd19;
            #period;

				read_en = 3'd1;
				#period;
				
				read_en = 3'd2;
				#period;
				
				read_en = 3'd3;
				#period;
				
				read_en = 3'd4;
				#period;
				
				read_en = 3'd5;
				#period;
				
				read_en = 3'd6;
				#period;
				
				read_en = 3'd7;
				#period;
				

            $stop;
        end

endmodule