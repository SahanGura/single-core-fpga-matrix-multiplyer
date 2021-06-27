`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module control_unit_tb();

    reg [7:0] ir;
    reg clk;
    reg z;

    wire end_op; wire [1:0] inc; wire [3:0] alu_mode; wire [3:0] bus_ld;
    wire [13:0] write_en; wire [3:0] clr; wire dm_wr ;wire  im_wr;

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

            #60; 			//FOR FETCHING CYCLES
				
            ir = 8'd1; //LDAC
            z = 0;
            #40; 			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
				
				#60; 			//FOR FETCHING CYCLES

            ir = 8'd2;	//LDARR1
            z = 0;
            #20; 			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
				
				#60;			//FOR FETCHING CYCLES

            ir = 8'd10;	//ADDTR
            z = 0;
            #40;			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
				
				#60;			//FOR FETCHING CYCLES
				
				ir = 8'd13;	//STACI
            z = 0;
            #60;			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
				
				#60;			//FOR FETCHING CYCLES
				
				ir = 8'd15;	//MULT
            z = 0;
            #20;			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
				
				#60;			//FOR FETCHING CYCLES
				
				ir = 8'd27;	//JPNZ	WHEN Z = 0
            z = 0;
            #40;			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
				
				#60;			//FOR FETCHING CYCLES
				
				ir = 8'd27;	//JPNZ WHEN Z = 1
            z = 1;
            #20;			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
	
				#60;			//FOR FETCHING CYCLES
			
				ir = 8'd28;	//ENDOP
            z = 1;
            #20;			//FOR EXECUTING CYCLES OF RELEVANT HIGH LEVEL INSTRUCTION
            $stop;


            
        end

endmodule


