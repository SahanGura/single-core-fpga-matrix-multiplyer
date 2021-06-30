module core
(input [7:0] dm_in,
input [7:0] im_in,
input clk,
output [15:0] addr_dm, addr_im,
output dm_wr,
output im_wr,
output reg [15:0] to_mem
);

wire [15:0] we;
wire [5:0] clr;
wire [3:0] bus_ld;
wire [2:0] alu_mode;
wire [1:0] inc;
wire [15:0] bus_out;
wire [15:0] ar_in;
wire z;
wire dm_addr;

//wire [15:0] ar_out;
wire [7:0] ir_out;
wire [15:0] pc_out;
wire [15:0]dr_out;
wire [7:0] r_out;
wire [7:0] r1_out;
wire [7:0] r2_out;
wire [7:0] r3_out;
wire [7:0] ri_out;
wire [7:0] rj_out;
wire [7:0] rk_out;
wire [7:0] ra_out;
wire [7:0] rb_out;
wire [15:0] tr_out;
wire [15:0] ac_out;
wire [15:0] alu_out;


address_reg #(.data_width(16)) ar
(
.clk (clk),
.we (we[12]),
.dm_addr(dm_addr),
.data_in(ar_in),
.data_out_im(addr_im),
.data_out_dm(addr_dm)
);

register_inc #(.data_width(16)) pc
(
.clk (clk),
.we (we[11]),
.clr(clr[0]),
.inc(inc[0]),
.data_in(bus_out[15:0]),
.data_out(pc_out)
);

register dr(
.clk (clk),
.we (we[10]),
.data_in(bus_out[15:0]),
.data_out(dr_out)
);

register ir(
.clk (clk),
.we (we[9]),
.data_in(bus_out[15:0]),
.data_out(ir_out)
);

register_inc r(
.clk (clk),
.we (we[8]),
.clr(clr[3]),
.inc(0),
.data_in(bus_out[15:0]),
.data_out(r_out)
);

register_inc r1(
.clk (clk),
.we (we[5]),
.clr(clr[5]),
.inc(0),
.data_in(bus_out[15:0]),
.data_out(r1_out)
);

register_inc r2(
.clk (clk),
.we (we[4]),
.clr(clr[4]),
.inc(0),
.data_in(bus_out[15:0]),
.data_out(r2_out)
);

register r3(
.clk (clk),
.we (we[0]),
.data_in(bus_out[15:0]),
.data_out(r3_out)
);

register ri(
.clk (clk),
.we (we[3]),
.data_in(bus_out[15:0]),
.data_out(ri_out)
);

register rj(
.clk (clk),
.we (we[2]),
.data_in(bus_out[15:0]),
.data_out(rj_out)
);

register rk(
.clk (clk),
.we (we[1]),
.data_in(bus_out[15:0]),
.data_out(rk_out)
);

register ra(
.clk (clk),
.we (we[15]),
.data_in(bus_out[15:0]),
.data_out(ra_out)
);

register rb(
.clk (clk),
.we (we[14]),
.data_in(bus_out[15:0]),
.data_out(rb_out)
);

register_inc #(.data_width(16)) tr
(
.clk (clk),
.we (we[7]),
.clr(clr[1]),
.inc(0),
.data_in(bus_out[15:0]),
.data_out(tr_out)
);

accumulator #(.data_width(16)) ac
(
.clk (clk),
.we (we[6]),
.clr(clr[2]),
.inc(inc[1]),
.data_in(alu_out[15:0]),
.data_out(ac_out),
.z(z)
);

alu alu1(
.in1(ac_out),
.in2(bus_out),
.alu_op(alu_mode),
.alu_out(alu_out)
);

bus bus(
.read_en(bus_ld),
.r(r_out),
.pc(pc_out),
.dr(dr_out),
.tr(tr_out),
.ac(ac_out),
.dm(dm_in),
.im(im_in),
.r1(r1_out),
.r2(r2_out),
.ri(ri_out),
.rj(rj_out),
.rk(rk_out),
.r3(r3_out),
.ra(ra_out),
.rb(rb_out),
.out(bus_out)
);

control_unit cu(
.ir(ir_out),
.clk(clk),
.z(z),
.write_en(we),
.clr(clr),
.bus_ld(bus_ld),
.alu_mode(alu_mode),
.inc(inc),
.dm_wr(dm_wr),
.im_wr(im_wr),
.dm_addr(dm_addr)
);

mux2 mux1 (
.in1(pc_out),
.in2(bus_out),
.sel(we[13]),
.out(ar_in)
);


always @ (posedge clk)
begin
to_mem <= bus_out;
end


endmodule
