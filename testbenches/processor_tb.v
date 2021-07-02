`timescale 1ns/1ps  // time-unit = 1 ns, precision = 1 ps

module processor_tb();
    reg clk = 1'b1;
    wire [7:0] ins;


    always
        begin
            #10 clk = 1'b0;
            #10 clk = 1'b1;
        end

    always @ (posedge clk)
	    if (ins == 8'd28)
		begin
		    $display("ENDOP Triggered");
            #100;
            $stop;
		end

    localparam period = 20; 

    processor dut(
        .clk(clk),
        .ins(ins)
    );

    // initial 
    //     begin
    //         #period;

    //         #2000000;
    //         $stop;
    //     end

endmodule


