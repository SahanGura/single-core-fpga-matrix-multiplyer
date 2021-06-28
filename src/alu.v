module alu(input [15:0] in1,
           input [15:0] in2,
           input [2:0] alu_op,
           output reg [15:0] alu_out,
           output reg [1:0] z);
    
    always @(*)
    begin
        case(alu_op)
            3'd0: alu_out    <= in1 + in2;
            3'd1: alu_out    <= in1 - in2;
            3'd2: alu_out    <= in1 * in2;
            3'd3: alu_out    <= in1 / in2;
            3'd4: alu_out    <= in2;
            default: alu_out <= in1 + in2;
        endcase
        
        if (alu_out == 0)
            z <= 1;
        else
            z <= 0;
    end
endmodule


