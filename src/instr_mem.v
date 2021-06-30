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
	parameter LDACRa = 8'd34;
	parameter LDACRb = 8'd35;
	parameter MVACRa = 8'd36;
	parameter MVACRb = 8'd37;
	parameter CLRR1 = 8'd38;
	parameter CLRR2 = 8'd39;
	parameter NOP = 8'd40;
	
	
	// //Instructions	increment
	// initial begin
	// mem[0] = CLRAC; //24
	// mem[1] = LDACI; //0
	// mem[2] = 8'd9;
	// mem[3] = INAC; //26
	// mem[4] = INAC;
	// mem[5] = STACI; //13
	// mem[6] = 8'd1;
	// mem[7] = ENDOP;
	// end



	// // //Instructions	counter
	// initial begin
	// mem[0] = CLRAC; //24
	// mem[1] = STACI; //0
	// mem[2] = 8'd52;
	// mem[3] = LDACI; //26
	// mem[4] = 8'd50;
	// mem[5] = MVACRi; //13
	// mem[6] = LDACI;
	// mem[7] = 8'd52;
	// mem[1] = INCAC; //0
	// mem[2] = STACI;
	// mem[3] = ; //26
	// mem[4] = 8'd50;
	// mem[5] = MVACRi; //13
	// mem[6] = LDACI;
	// mem[7] = 8'd51;

	// end
	
	// // //Instructions mult
	// initial begin
	// mem[0] = CLRAC; //24
	// mem[1] = LDACI; //0
	// mem[2] = 8'd2;
	// mem[3] = MVAC; //26
	// mem[4] = LDACI;
	// mem[5] = 8'd4; //13
	// mem[6] = MULT;
	// mem[7] = STACI;
	// mem[8] = 8'd150;

	// mem[9] = ADDTR;
	// mem[10] = LDACI; //0
	// mem[11] = 8'd2;
	// mem[12] = MVAC; //26
	// mem[13] = LDACI;
	// mem[14] = 8'd4; //13
	// mem[15] = MULT;
	// mem[16] = ADDTR;
	// mem[17] = STTR;
	// mem[18] = LDACI;
	// mem[19] = 8'd14;
	// mem[20] = INAC;
	// mem[21] = INAC;
	// mem[22] = MVACR1;
	// mem[23] = LDARR1;
	// mem[24] = STTR;
	// mem[25] = LDACI;
	// mem[26] = 8'd150;
	// mem[27] = MVACRi;
	// mem[28] = MULTRi;
	// mem[29] = STACI;
	// mem[30] = 8'd154; //verified
	// mem[31] = MVACRj;
	// mem[32] = INAC;
	// mem[33] = MULTRj;
	// mem[34] = STACI;
	// mem[35] = 8'd156; //1332
	// mem[36] = LDACRi; //6
	// mem[37] = MVACRk;
	// mem[38] = INAC; //7
	// mem[39] = INAC; //8
	// mem[40] = SUBRk;
	// mem[41] = STACI;
	// mem[42] = 8'd158; //2
	// mem[43] = LDACRj; //36
	// mem[44] = MVACR1; //36
	// mem[45] = ADDR1; 
	// mem[46] = LDARR1; 
	// mem[47] = LDAC; 
	// mem[48] = STACI;
	// mem[49] = 8'd160;
	// mem[50] = LDACI;
	// mem[51] = 8'd70;
	// mem[52] = MVACRi;
	// mem[53] = LDACI;
	// mem[54] = 8'd2;
	// mem[55] = MVAC;
	// mem[56] = MULT;
	// mem[57] = LDACI;
	// mem[58] = 8'd70;
	// mem[59] = INAC;
	// mem[60] = MVACRi;
	// mem[61] = STACI;
	// mem[62] = 8'd70;
	// mem[63] = LDACI;
	// mem[64] = 8'd150;
	// mem[65] = CLRR;
	// mem[66] = SUBRi;
	// mem[67] = JPNZ;
	// mem[68] = 8'd50;
	// mem[69] = ENDOP;

	// end
	
	
	// Instruction set to be executed
	initial begin
	mem[0] = LDACI;
	mem[1] = 8'd0;
	mem[2] = MVAC;
	mem[3] = LDACI;
	mem[4] = 8'd2;
	mem[5] = MULT;
	mem[6] = MVACR3;
	mem[7] = LDACI;	//loop1
	mem[8] = 8'd6;
	mem[9] = MVACRi;
	mem[10] = LDACI;
	mem[11] = 8'd2;
	mem[12] = MULTRi;
	mem[13] = MVACRa;
	mem[14] = CLRAC;
	mem[15] = STACI;
	mem[16] = 8'd8;
	mem[17] = LDACI;	//loop2
	mem[18] = 8'd8;
	mem[19] = MVACRj;
	mem[20] = LDACI;
	mem[21] = 8'd2;
	mem[22] = MULTRj;
	mem[23] = MVACRb;
	mem[24] = CLRAC;
	mem[25] = STACI;
	mem[26] = 8'd10;
	mem[27] = LDACRa;	//loop3
	mem[28] = MVACR1;	
	mem[29] = LDACRb;	
	mem[30] = MVACR2;	
	mem[31] = LDACI;
	mem[32] = 8'd10;
	mem[33] = MVACRk;
	mem[34] = ADDR1;
	mem[35] = LDACRk;
	mem[36] = ADDR2;
	mem[37] = LDACI;
	mem[38] = 8'd12;
	mem[39] = ADDR1;
	mem[40] = LDARR1;
	mem[41] = LDAC;
	mem[42] = MVAC;	
	mem[43] = LDACI;
	mem[44] = 8'd12;
	mem[45] = ADDR2;
	mem[46] = LDACR3;
	mem[47] = ADDR2;
	mem[48] = LDARR2;
	mem[49] = LDAC;
	mem[50] = MULT;
	mem[51] = ADDTR;
	mem[52] = LDACRk;	
	mem[53] = INAC;
	mem[54] = MVACRk;
	mem[55] = STACI;
	mem[56] = 8'd10;
	mem[57] = LDACI;
	mem[58] = 8'd2;
	mem[59] = CLRR;
	mem[60] = SUBRk;
	mem[61] = JPNZ;	
	mem[62] = 8'd27; //loop3 ends here
	mem[63] = LDACRj;
	mem[64] = MVACR1;
	mem[65] = LDACI;
	mem[66] = 8'd14;
	mem[67] = ADDR1;
	mem[68] = LDACRi;
	mem[69] = MVAC;
	mem[70] = LDACI;
	mem[71] = 8'd4;	
	mem[72] = MULT;
	mem[73] = ADDR1;
	mem[74] = ADDR1;
	mem[75] = LDARR1;
	mem[76] = STTR;
	mem[77] = CLRTR;
	mem[78] = LDACRj;
	mem[79] = INAC;
	mem[80] = MVACRj;
	mem[81] = STACI;
	mem[82] = 8'd8;
	mem[83] = LDACI;	
	mem[84] = 8'd4;
	mem[85] = CLRR;
	mem[86] = SUBRj;
	mem[87] = JPNZ;
	mem[88] = 8'd17; //loop2 ends here
	mem[89] = LDACI;
	mem[90] = 8'd6;
	mem[91] = INAC;
	mem[92] = MVACRi;
	mem[93] = STACI;
	mem[94] = 8'd6;	
	mem[95] = LDACI;
	mem[96] = 8'd0;
	mem[97] = CLRR;
	mem[98] = SUBRi;
	mem[99] = JPNZ;
	mem[100] = 8'd7; //loop1 ends here
	mem[101] = ENDOP;
		
	end
		
		
		
	//body
	//write operation
	always@(posedge clk)
		begin
			if(we)
				begin 
				mem[w_addr] <= w_instr[7:0];
				mem[w_addr+1'b1] <= w_instr[15:8];
				end
			else
				begin
				data_reg <= mem[r_addr];
				end
		end
		
		//read operation
		assign r_instr = data_reg;
endmodule
