module instr_mem #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)
	(input wire clk,
	input wire we,
	input wire[(DATA_WIDTH-1):0] w_instr, 
	input wire[(ADDR_WIDTH-1):0] w_addr, r_addr,
	output wire[(DATA_WIDTH-1):0] r_instr);

	//signal declaration
	reg[DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0]; //2D-array for storage
	reg[DATA_WIDTH-1:0] data_reg; //read output register

	//RAM initialization from an output file
	initial
		$readmemh("initialRAM.txt",mem);
		
	parameter LDAC1 = 8'd3;
	parameter LDAC2 = 8'd4;
	parameter LDAC3 = 8'd5;
	parameter LDAC4 = 8'd6;
	parameter MVAC1 = 8'd7;
	parameter ADDTR1 = 8'd8;
	parameter ADDTR2 = 8'd9;
	parameter STTR1 = 8'd10;
	parameter STTR2 = 8'd11;
	parameter STTR3 = 8'd12;
	parameter MULT1 = 8'd13;
	parameter SUB1 = 8'd14;
	parameter CLR1 = 8'd15;
	parameter INAC1 = 8'd16;
	parameter JUMP1 = 8'd17;
	parameter JUMP2 = 8'd18;
	parameter JMPZY1 = 8'd19;
	parameter JMPZY2 = 8'd20;
	parameter JMPZN1 = 8'd21;
	parameter JPNZY1 = 8'd22;
	parameter JPNZY2 = 8'd23;
	parameter JPNZN1 = 8'd24;
	parameter ENDOP1 = 8'd25;
	parameter NOP1 = 8'd26;
		
		
	// Instruction set to be executed
	initial begin
	mem[1] = 16'd257;
	mem[2] = LDAC1;
	mem[3] = NOP1;
	mem[4] = NOP1;
	mem[5] = NOP1;
	mem[6] = NOP1;
	mem[7] = NOP1;
	mem[8] = NOP1;
	mem[9] = NOP1;
	mem[10] = NOP1;
	mem[11] = NOP1;
	mem[12] = NOP1;
	mem[13] = NOP1;
	mem[14] = NOP1;
	mem[15] = NOP1;
	mem[16] = NOP1;
	mem[17] = NOP1;
	mem[18] = NOP1;
	mem[19] = NOP1;
		
		
	end
		
		
		
	//body
	//write operation
	always@(posedge clk)
		begin
			if(we)
				mem[w_addr] <= w_instr;
			data_reg <= mem[r_addr];
		end
		
		//read operation
		assign r_instr = data_reg;
endmodule
