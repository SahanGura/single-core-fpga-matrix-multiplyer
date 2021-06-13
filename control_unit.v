module control_unit
(input [7:0] ir,
 input clk,
 input z,

 output reg end_op, output reg [1:0] inc, output reg [3:0] alu_mode, output reg[2:0] bus_ld ,
 output reg [7:0] write_en, output reg [2:0] clr, output reg dm_wr , im_wr );

 parameter FETCH1 = 3'b000, FETCH2 = 3'b001, FETCH3 = 3'b010, EXEC1 = 3'b011, EXEC2 = 3'b100,
 EXEC3 = 3'b101, EXEC4 = 3'B110, IDLE = 3'b111;

 reg stage = 3'b000;
 reg next_stage = 3'b000;
 
 //---------------------------------------------------------------------------
 
 //WRITE_EN 	0   0  0  0  0  0  0 
 //	   		ARB AR PC DR IR R TR 
 
  //BUS_LD 0     1     2  3  4  5    6   7   (Dec Val/3bit BINARY)0-->5 busread 
 //	     IMEMB DMEMB PC DR R  AC  TR
 
 
 //MEM_FUNC  0        1         2          (DEC VALS) 
 //          IMEMREAD DMEMREAD DMEMWRITE               WHEN DMEMREAD -> TOMEM = 0
																	//WHEN DMEMWRITE -> TOMEM = 1
	 
// write_en
//inc
//alu_mode
//bus_ld
//clr
//dm_wr
//im_wr 
 //---------------------------------------------------------------------------

 
 always @(posedge clk)
 begin
// next_stage <= FETCH1
 stage <= next_stage ;
 
 case (stage)
 FETCH1 :
 begin
 write_en <= 8'b01000000 ; //ar
 inc <= 2'b00;
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= FETCH2 ;
 end_op <= 1'b0;
 end
 
 FETCH2:
 begin
 write_en <= 8'b00010000 ; //dr
 inc <= 2'b01; //pc
 bus_ld <= 3'd0;//i_mem
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= FETCH3 ;
 end_op <= 1'b0;
 end
 
 FETCH3:
 begin
 write_en <= 8'b00001000 ; //ir
 inc <= 2'b00;
 bus_ld <= 3'd3;//dr
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= EXEC1 ;
 end_op <= 1'b0;
 end
 
 EXEC1:
 begin
	case (ir[3:0])
	
	4'b0000:
	begin //LDAC
	 write_en <= 8'b00010000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 3'd0;//imem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;
	end
	
	4'b0001: 
	begin //MVACR
	 write_en <= 8'b00000100 ; //r
	 inc <= 2'b00;
	 bus_ld <= 3'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end
	 
	4'b0010:
	begin //ADDTR   //have an issue here.....................................................
	 write_en <= 8'b00000001 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 3'd6;//tr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end
	 
	4'b0011: 
	begin //MVACTR
	 write_en <= 8'b00000010 ; //tr
	 inc <= 2'b00;
	 bus_ld <= 3'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;	
	end
		
	4'b0100:
	begin //STTR
	 write_en <= 8'b00010000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 3'd0;//imem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;	
	end
	
	4'b0101: //MULT
	begin 
	 write_en <= 8'b00000001 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 3'd4;//r
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b010; //mult
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end
	
	4'b0110: //SUB
	begin
	 write_en <= 8'b00000001 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 3'd4;//r
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b001; //sub
	 next_stage <= EXEC2;
	 end_op <= 1'b0;	
	end
	
	4'b0111: //CLR
	begin
	 write_en <= 8'b00000000 ;
	 inc <= 2'b00;
	 clr <= 3'b110;; //ac & tr
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;		
	end
	
	4'b1000: //INCAC
	begin
	 write_en <= 8'b00000000 ;
	 inc <= 2'b10; //ac
	 clr <= 3'b000;;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;	
	end
	
	4'b1001:	//JUMP
	begin
	 write_en <= 8'b00010000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 3'd0;//imem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;	
	end
	
	4'b1010:	//JUMPZ
	begin
	 if (z==1)
		begin
		 write_en <= 8'b00010000 ; //dr
		 inc <= 2'b00;
		 bus_ld <= 3'd0;//imem
		 clr <= 3'b000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= EXEC2 ;
		 end_op <= 1'b0;
		end
	 else
		begin
		 write_en <= 8'b00000000 ;
		 inc <= 2'b01; //pc
		 bus_ld <= 3'd0;//imem
		 clr <= 3'b000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= EXEC2 ;
		 end_op <= 1'b0;
		end 
	end
	
	4'b1011:	//JPNZ
	begin
	 if (z==0)
		begin
		 write_en <= 8'b00010000 ; //dr
		 inc <= 2'b00;
		 bus_ld <= 3'd0;//imem
		 clr <= 3'b000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= EXEC2 ;
		 end_op <= 1'b0;
		end
	 else
		begin
		 write_en <= 8'b00000000 ;
		 inc <= 2'b01; //pc
		 bus_ld <= 3'd0;//imem
		 clr <= 3'b000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= EXEC2 ;
		 end_op <= 1'b0;
		end
	end
	
	4'b1100: //ENDOP
	begin
	 write_en <= 8'b00000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 3'd0;//imem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= IDLE ;
	 end_op <= 1'b1;		
	end
	
	default : //NOOP
	begin
		next_stage <= EXEC2 ;
	end
	
	endcase
	
 end
	
//-----------------------------------------
	
 EXEC2:
 begin
	case (ir[3:0])
	
	4'b0000:
	begin //LDAC
	 write_en <= 8'b01000000 ; //ar
	 inc <= 2'b01; //pc
	 bus_ld <= 3'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;	;		
	end

	4'b0010:
	begin //ADDTR   //have an issue here.....................................................
	 write_en <= 8'b00000010 ; //tr
	 inc <= 2'b00;
	 bus_ld <= 3'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end
	
	4'b0100:
	begin //STTR
	 write_en <= 8'b01000000 ; //ar
	 inc <= 2'b01; //pc
	 bus_ld <= 3'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;		
	end
	
	4'b1001:	//JUMP
	begin
	 write_en <= 8'b10000000 ; //arb
	 inc <= 2'b00;
	 bus_ld <= 3'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;			
	end
	
	4'b1010:	//JUMPZ
	begin
	 write_en <= 8'b10000000 ; //arb
	 inc <= 2'b00;
	 bus_ld <= 3'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;
	end
	
	4'b1011:	//JPNZ
	begin
	 write_en <= 8'b10000000 ; //arb
	 inc <= 2'b00;
	 bus_ld <= 3'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;
	end
	
	default : //NOOP
	begin
		next_stage <= EXEC3;
	end
	endcase
	
 end
	
//-----------------------------------------
	
 EXEC3:
 begin
	case (ir[3:0])
	
	4'b0000:
	begin //LDAC
	 write_en <= 8'b00010000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 3'd1;//dmem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC4 ;
	 end_op <= 1'b0;		
	end
	 	
	4'b0100:
	begin //STTR --------------------- TR --> MEM
	 write_en <= 8'b00000000 ; //nothing
	 inc <= 2'b00;
	 bus_ld <= 3'd6;//tr
	 clr <= 3'b000;
	 dm_wr <=1'b1;
	 im_wr <=1'b0;
	 next_stage <= EXEC4 ;
	 end_op <= 1'b0;		
	end
	
	
	default : //NOOP
	begin
		next_stage <= EXEC4 ;
	end
	endcase

 end
 
 EXEC4:
 begin
	case (ir[3:0])
	4'b0000:
	begin //LDAC
	 write_en <= 8'b00000001 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 3'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b101; // pass
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;		
	end
	
	default : //NOOP
	begin
	end
	endcase

 end
 
 IDLE:
 begin
 next_stage <= IDLE ;
 write_en <= 8'b00000000 ; //nothing
 inc <= 2'b00;
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 end_op <= 1'b0; 
 end
 
default:
 begin
 next_stage <= FETCH1;
 write_en <= 8'b00000000 ; //nothing
 inc <= 2'b00;
 clr <= 3'b111;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 end_op <= 1'b0;
 end
endcase
end
endmodule

	
	
	
 