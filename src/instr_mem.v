module instr_mem #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)
	(input clk,
	input we,
	input [(2*DATA_WIDTH-1):0] w_instr, 
	input [(ADDR_WIDTH-1):0] w_addr, r_addr,
	output [(DATA_WIDTH-1):0] r_instr);

	//signal declaration
	reg[DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0]; //2D-array for storage
	reg[DATA_WIDTH-1:0] data_reg; //read output register

	// //RAM initialization from an output file
	// initial
	// 	$readmemh("initialRAM.txt",mem);
		
	parameter LDACI = 8'd0;
	parameter LDAC = 8'd1;
	parameter LDARR1 = 8'd2;
	parameter LDARR2 = 8'd3;
	parameter MVAC = 8'd4;
	parameter MVACRi = 8'd5;
	parameter MVACRj = 8'd6;
	parameter MVACRk = 8'd7;
	parameter MVACR1 = 8'd8;
	parameter MVACR2 = 8'd9;
	parameter ADDTR = 8'd10;
	parameter ADDR1 = 8'd11;
	parameter ADDR2 = 8'd12;
	parameter STACI = 8'd13;
	parameter STTR = 8'd14;
	parameter MULT = 8'd15;
	parameter MULTRi = 8'd16;
	parameter MULTRj = 8'd17;
	parameter MULTRk = 8'd18;
	parameter SUB = 8'd19;
	parameter SUBRi = 8'd20;
	parameter SUBRj = 8'd21;
	parameter SUBRk = 8'd22;
	parameter CLRR = 8'd23;
	parameter CLRAC = 8'd24;
	parameter CLRTR = 8'd25;
	parameter INAC = 8'd26;
	parameter JPNZ = 8'd27;
	parameter ENDOP = 8'd28;
	parameter LDACRi = 8'd29;
	parameter LDACRj = 8'd30;
	parameter LDACRk = 8'd31;
	parameter LDACR3 = 8'd32;
	parameter MVACR3 = 8'd33;
	parameter NOP = 8'd34;
	
	// Instruction set to be executed
	initial begin
	mem[0] = LDACI;
	mem[1] = 8'd0;
	mem[2] = MVAC;
	mem[3] = LDACI;
	mem[4] = 8'd1;
	mem[5] = MULT;
	mem[6] = MVACR3;
	mem[7] = LDACI;	//loop1
	mem[8] = 8'd3;
	mem[9] = MVACRi;
	mem[10] = LDACI;
	mem[11] = 8'd0;
	mem[12] = MULTRi;
	mem[13] = MVACR1;
	mem[14] = CLRAC;
	mem[15] = STACI;
	mem[16] = 8'd4;
	mem[17] = LDACI;	//loop2
	mem[18] = 8'd4;
	mem[19] = MVACRj;
	mem[20] = LDACI;
	mem[21] = 8'd2;
	mem[22] = MULTRj;
	mem[23] = MVACR2;
	mem[24] = CLRAC;
	mem[25] = STACI;
	mem[26] = 8'd5;
	mem[27] = LDACI;	//loop3
	mem[28] = 8'd5;
	mem[29] = MVACRk;
	mem[30] = ADDR1;
	mem[31] = ADDR2;
	mem[32] = LDACI;
	mem[33] = 8'd6;
	mem[34] = ADDR1;
	mem[35] = LDARR1;
	mem[36] = LDAC;
	mem[37] = MVAC;	
	mem[38] = LDACI;
	mem[39] = 8'd6;
	mem[40] = ADDR2;
	mem[41] = LDACR3;
	mem[42] = ADDR2;
	mem[43] = LDARR2;
	mem[44] = LDAC;
	mem[45] = MULT;
	mem[46] = ADDTR;
	mem[47] = LDACRk;	
	mem[48] = INAC;
	mem[49] = STACI;
	mem[50] = 8'd5;
	mem[51] = LDACI;
	mem[52] = 8'd1;
	mem[53] = SUBRk;
	mem[54] = CLRR;
	mem[55] = JPNZ;	
	mem[56] = 8'd27; //loop3 ends here
	mem[57] = LDACRj;
	mem[58] = MVACR1;
	mem[59] = LDACI;
	mem[60] = 8'd7;
	mem[61] = ADDR1;
	mem[62] = LDACRi;
	mem[63] = MVAC;
	mem[64] = LDACI;
	mem[65] = 8'd0;	
	mem[66] = MULT;
	mem[67] = ADDR1;
	mem[68] = LDARR1;
	mem[69] = STTR;
	mem[70] = CLRTR;
	mem[71] = LDACRj;
	mem[72] = INAC;
	mem[73] = STACI;
	mem[74] = 8'd4;
	mem[75] = LDACI;	
	mem[76] = 8'd2;
	mem[77] = SUBRj;
	mem[78] = CLRR;
	mem[79] = JPNZ;
	mem[80] = 8'd17; //loop2 ends here
	mem[81] = LDACI;
	mem[82] = 8'd3;
	mem[83] = INAC;
	mem[84] = STACI;
	mem[85] = 8'd3;	
	mem[86] = LDACI;
	mem[87] = 8'd0;
	mem[88] = SUBRi;
	mem[89] = CLRR;
	mem[90] = JPNZ;
	mem[91] = 8'd7; //loop1 ends here
	mem[92] = ENDOP;
		
	end
		
		
		
	//body
	//write operation
	always@(posedge clk)
		begin
			if(we)
				mem[w_addr] <= w_instr[7:0];
				mem[w_addr+1'b1] <= w_instr[15:8];
			data_reg <= mem[r_addr];
		end
		
		//read operation
		assign r_instr = data_reg;
endmodule
