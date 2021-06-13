module processor
(input [7:0] dm_in,
input [7:0] im_in,
input clk,
output [15:0] addr,
output dm_wr,
output im_wr,
output reg [15:0] to_mem
);

wire [7:0] we;
wire [2:0] clr;
wire [2:0] bus_ld;
wire [2:0] alu_mode;
wire [1:0] inc;
wire [15:0] bus_out;
wire [15:0] ar_in;
wire z;

//wire [15:0] ar_out;
wire [7:0] ir_out;
wire [7:0] pc_out;
wire [15:0]dr_out;
wire [7:0] r_out;
wire [15:0] tr_out;
wire [15:0] ac_out;
wire [15:0] alu_out;


register #(.data_width(16)) ar
(
.clk (clk),
.we (we[1]),
.data_in(ar_in[15:0]),
.data_out(addr)
);

register_inc #(.data_width(16)) pc
(
.clk (clk),
.we (we[2]),
.clr(clr[0]),
.inc(inc[0]),
.data_in(ar_in[15:0]),
.data_out(pc_out)
);

register dr(
.clk (clk),
.we (we[3]),
.data_in(ar_in[15:0]),
.data_out(dr_out)
);

register ir(
.clk (clk),
.we (we[4]),
.data_in(ar_in[15:0]),
.data_out(ir_out)
);

register r(
.clk (clk),
.we (we[5]),
.data_in(ar_in[15:0]),
.data_out(r_out)
);

register_inc #(.data_width(16)) tr
(
.clk (clk),
.we (we[6]),
.clr(clr[1]),
.inc(0),
.data_in(bus_out[15:0]),
.data_out(tr_out)
);

register_inc #(.data_width(16)) ac
(
.clk (clk),
.we (we[7]),
.clr(clr[2]),
.inc(inc[1]),
.data_in(alu_out[15:0]),
.data_out(ac_out)
);

alu alu1(
.in1(ac_out),
.in2(bus_out),
.alu_op(alu_mode),
.alu_out(alu_out),
.z(z)
);

bus bus(
.clk(clk),
.read_en(bus_ld),
.r(r_out),
.pc(pc_out),
.dr(dr_out),
.tr(tr_out),
.ac(ac_out),
.dm(dm_in),
.im(im_in),
.busout(bus_out)
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
.im_wr(im_wr)
);



always @ (posedge clk)
begin
to_mem <= bus_out;
end


endmodule
