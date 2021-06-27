module data_mem #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)
	(input wire clk,
	input wire we,
	input wire[(DATA_WIDTH-1):0] w_data, 
	input wire[(ADDR_WIDTH-1):0] w_addr, r_addr,
	output wire[(DATA_WIDTH-1):0] r_data);

	//signal declaration
	reg[DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0]; //2D-array for storage
	reg[DATA_WIDTH-1:0] data_reg; //read output register

//	//RAM initialization from an output file
//	initial
//		$readmemh("initialRAM.txt",mem);

	initial begin
		mem[0] = 8'd2;	//m
		mem[1] = 8'd3;	//n
		mem[2] = 8'd2;	//l
		mem[3] = 8'd0;	//i
		mem[4] = 8'd0;	//j
		mem[5] = 8'd0;	//k
		mem[6] = 8'd8;
		mem[7] = 8'd100;
		mem[8] = 8'd1;	//val1
		mem[9] = 8'd2;
		mem[10] = 8'd3;
		mem[11] = 8'd4;
		mem[12] = 8'd5;
		mem[13] = 8'd6;
		mem[14] = 8'd7; //val1
		mem[15] = 8'd8;
		mem[16] = 8'd9;
		mem[17] = 8'd10;
		mem[18] = 8'd11;
		mem[19] = 8'd12;
	end
		
	//body
	//write operation
	always@(posedge clk)
		begin
			if(we)
				mem[w_addr] <= w_data;
			data_reg <= mem[r_addr];
		end
		
		//read operation
		assign r_data = data_reg;
endmodule
