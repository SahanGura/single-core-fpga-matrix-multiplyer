module processor
(
input clk,
output reg [7:0] ins
);

wire [7:0] dm_out;
wire [7:0] im_out;
wire [7:0] addr_out_im, addr_out_dm;
wire [15:0] mem_in;
wire dm_we;
wire im_we;

core core1(
.dm_in(dm_out),
.im_in(im_out),
.clk(clk),
.addr_im(addr_out_im),
.addr_dm(addr_out_dm),
.dm_wr(dm_we),
.im_wr(im_we),
.to_mem(mem_in)
);

data_mem data_mem1(
.clk(clk),
.we(dm_we),
.w_data(mem_in),
.r_data(dm_out),
.w_addr(addr_out_dm),
.r_addr(addr_out_dm)
);

instr_mem instr_mem1(
.clk(clk),
.we(im_we),
.w_instr(mem_in),
.r_instr(im_out),
.w_addr(addr_out_im),
.r_addr(addr_out_im)
);

always @ (posedge clk)
begin
ins <= im_out;
end

endmodule 