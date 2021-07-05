module data_mem #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)
	(input wire clk,
	input wire we,
	input wire[(2*DATA_WIDTH-1):0] w_data, 
	input wire[(ADDR_WIDTH-1):0] w_addr, r_addr,
	output wire[(DATA_WIDTH-1):0] r_data);

	//signal declaration
	reg[DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0]; //2D-array for storage
	reg[DATA_WIDTH-1:0] data_reg; //read output register

	//RAM initialization from an output file
    initial begin
        $display("Loading rom.");
        $readmemh("initial_files/data_mem.txt", mem);
    end

	// initial begin
	// 	mem[0] = 8'd5;	//m			15 14 13 12 11 10 9     7 6 5 4 3 2 1 0
	// 	mem[2] = 8'd3;	//n
	// 	mem[4] = 8'd4;	//l
	// 	mem[6] = 8'd0;	//i
	// 	mem[8] = 8'd0;	//j
	// 	mem[10] = 8'd0;	//k
	// 	mem[12] = 8'd15;
	// 	mem[14] = 8'd70;
	// 	mem[15] = 8'd1;	//val1
	// 	mem[16] = 8'd2;
	// 	mem[17] = 8'd3;
	// 	mem[18] = 8'd4;
	// 	mem[19] = 8'd5;
	// 	mem[20] = 8'd6;
	// 	mem[21] = 8'd7; 
	// 	mem[22] = 8'd8;
	// 	mem[23] = 8'd9;
	// 	mem[24] = 8'd4;
	// 	mem[25] = 8'd5;
	// 	mem[26] = 8'd3;
	// 	mem[27] = 8'd0;
	// 	mem[28] = 8'd9;
	// 	mem[29] = 8'd7;
	// 	mem[30] = 8'd3; //val2
	// 	mem[31] = 8'd8;
	// 	mem[32] = 8'd2;
	// 	mem[33] = 8'd3;
	// 	mem[34] = 8'd5;
	// 	mem[35] = 8'd4;
	// 	mem[36] = 8'd0;
	// 	mem[37] = 8'd9;
	// 	mem[38] = 8'd3;
	// 	mem[39] = 8'd9;
	// 	mem[40] = 8'd1;
	// 	mem[41] = 8'd4;
	// end
		
	//body
	//write operation
	always@(posedge clk)
		begin
			if(we)
				begin
				mem[w_addr] <= w_data[7:0];
				mem[w_addr+1'b1] <= w_data[15:8];
				end
			else if(!we)
				begin
				data_reg <= mem[r_addr];
				end
		end
		
		//read operation
		assign r_data = data_reg;
endmodule
