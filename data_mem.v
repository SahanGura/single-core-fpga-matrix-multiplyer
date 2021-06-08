module data_mem #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)
	(input wire clk,
	input wire we,
	input wire[(DATA_WIDTH-1):0] w_data, 
	input wire[(ADDR_WIDTH-1):0] w_addr, r_addr,
	output wire[(DATA_WIDTH-1):0] r_data);

	//signal declaration
	reg[DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0]; //2D-array for storage
	reg[DATA_WIDTH-1:0] data_reg; //read output register

	//RAM initialization from an output file
	initial
		$readmemh("initialRAM.txt",mem);
		
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
