module control_unit
(input [7:0] ir,
 input clk,
 input z,

 output reg end_op, output reg [1:0] inc, output reg [3:0] alu_mode, output reg[3:0] bus_ld ,
 output reg [12:0] write_en, output reg [2:0] clr, output reg dm_wr , im_wr );

 parameter FETCH1 = 3'b000, FETCH2 = 3'b001, FETCH3 = 3'b010, EXEC1 = 3'b011, EXEC2 = 3'b100,
 EXEC3 = 3'b101, EXEC4 = 3'B110, IDLE = 3'b111;

 reg[2:0] stage, next_stage = FETCH1;
 
 //---------------------------------------------------------------------------
 
 //WRITE_EN 	0   0  0  0  0  0  0 0	0	0	0	0	0
 //	   		ARB AR PC DR IR R TR AC	R1	R2	Ri Rj	 Rk
 
  //BUS_LD 0     1     2  3  4  5    6    7  8	9	10	11	(Dec Val/3bit BINARY)0-->5 busread 
 //	     IMEMB DMEMB PC DR R  AC  TR		R1	R2	Ri	Rj	Rk
 
 
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
 stage = next_stage;
 
 case (stage)
 FETCH1 :
 begin
 write_en <= 13'b0100000000000 ; //ar
 inc <= 2'b00;
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= FETCH2 ;
 end_op <= 1'b0;
 end
 
 FETCH2:
 begin
 write_en <= 13'b0001000000000 ; //dr
 inc <= 2'b01; //pc
 bus_ld <= 4'd0;//i_mem
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= FETCH3 ;
 end_op <= 1'b0;
 end
 
 FETCH3:
 begin
 write_en <= 13'b0000100000000 ; //ir
 inc <= 2'b00;
 bus_ld <= 4'd3;//dr
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= EXEC1 ;
 end_op <= 1'b0;
 end
 
 EXEC1:
 begin
	case (ir[4:0])
	
	5'd0:
	begin //LDACI
	 write_en <= 13'b0001000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd0;//imem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;
	end
	
	5'd1:
	begin //LDAC
	 write_en <= 13'b0001000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd1;//dmem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;
	end
	
	5'd2: 
	begin //LDARR1
	 write_en <= 13'b1100000000000 ; //arb ar
	 inc <= 2'b00;
	 bus_ld <= 4'd7;//r1
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end
	
	5'd3: 
	begin //LDARR2
	 write_en <= 13'b1100000000000 ; //arb ar
	 inc <= 2'b00;
	 bus_ld <= 4'd8;//r1
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end	
	
	5'd4: 
	begin //MVACR
	 write_en <= 13'b0000010000000 ; //r
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end

	5'd5: 
	begin //MVACR1
	 write_en <= 13'b0000000010000 ; //r1
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end

	5'd6: 
	begin //MVACR2
	 write_en <= 13'b0000000001000 ; //r2
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end

	5'd7: 
	begin //MVACRi
	 write_en <= 13'b0000000000100 ; //ri
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end

	5'd8: 
	begin //MVACRj
	 write_en <= 13'b0000000000010 ; //rj
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end

	5'd9: 
	begin //MVACRk
	 write_en <= 13'b0000000000001 ; //rk
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC1 ;
	 end_op <= 1'b0;
	end	
	
	5'd10:
	begin //ADDTR   //have an issue here.....................................................
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd6;//tr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;		//add
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end
	
	5'd11:
	begin //ADDR1
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd7;//r1
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;		//add
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end	
	
	5'd12:
	begin //ADDR2
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd8;//r2
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;		//add
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end

	5'd13:	
	begin //STACI
	 write_en <= 13'b0001000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd0;//imem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end		
		
	5'd14:
	begin //STTR
	 write_en <= 13'b0001000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd0;//imem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;	
	end
	
	5'd15: //MULT
	begin 
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd4;//r
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b010; //mult
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end
	
	5'd16: //MULTRi
	begin 
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd9;//ri
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b010; //mult
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end	

	5'd17: //MULTRj
	begin 
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd10;//rj
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b010; //mult
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end

	5'd18: //MULTRk
	begin 
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd11;//rk
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b010; //mult
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end		
	
	5'd19: //SUB
	begin
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd4;//r
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b001; //sub
	 next_stage <= EXEC2;
	 end_op <= 1'b0;	
	end
	
	5'd20: //SUBRi
	begin
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd9;//ri
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b001; //sub
	 next_stage <= EXEC2;
	 end_op <= 1'b0;	
	end	
	
	5'd21: //SUBRj
	begin
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd10;//rj
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b001; //sub
	 next_stage <= EXEC2;
	 end_op <= 1'b0;	
	end

	5'd22: //SUBRk
	begin
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd11;//rk
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b001; //sub
	 next_stage <= EXEC2;
	 end_op <= 1'b0;	
	end		
	
	5'd23: //CLR
	begin
	 write_en <= 13'b0000000000000 ;
	 inc <= 2'b00;
	 clr <= 3'b110; //ac & tr
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;		
	end
	
	5'd24: //CLRAC
	begin
	 write_en <= 13'b0000000000000 ;
	 inc <= 2'b00;
	 clr <= 3'b100; //ac
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;		
	end	
	
	5'd25: //CLRTR
	begin
	 write_en <= 13'b0000000000000 ;
	 inc <= 2'b00;
	 clr <= 3'b010; //ac
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;		
	end	
	
	5'd26: //INCAC
	begin
	 write_en <= 13'b0000000000000 ;
	 inc <= 2'b10; //ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;	
	end
	
//	4'b1010:	//JUMPZ
//	begin
//	 if (z==1)
//		begin
//		 write_en <= 8'b00010000 ; //dr
//		 inc <= 2'b00;
//		 bus_ld <= 3'd0;//imem
//		 clr <= 3'b000;
//		 dm_wr <=1'b0;
//		 im_wr <=1'b0;
//		 next_stage <= EXEC2 ;
//		 end_op <= 1'b0;
//		end
//	 else
//		begin
//		 write_en <= 8'b00000000 ;
//		 inc <= 2'b01; //pc
//		 bus_ld <= 3'd0;//imem
//		 clr <= 3'b000;
//		 dm_wr <=1'b0;
//		 im_wr <=1'b0;
//		 next_stage <= EXEC2 ;
//		 end_op <= 1'b0;
//		end 
//	end
	
	5'd27:	//JPNZ
	begin
	 if (z==0)
		begin
		 write_en <= 13'b0001000000000 ; //dr
		 inc <= 2'b00;
		 bus_ld <= 4'd0;//imem
		 clr <= 3'b000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= EXEC2 ;
		 end_op <= 1'b0;
		end
	 else
		begin
		 write_en <= 13'b0000000000000 ;
		 inc <= 2'b01; //pc
		 bus_ld <= 4'd0;//imem
		 clr <= 3'b000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= EXEC2 ;
		 end_op <= 1'b0;
		end
	end
	
	5'd28: //ENDOP
	begin
	 write_en <= 13'b0000000000000 ;
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
		write_en <= 13'b0000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 3'b000;
		dm_wr <=1'b0;
		im_wr <=1'b0;
		end_op <= 1'b0;
		next_stage <= EXEC2 ;
	end
	
	endcase
	
 end
	
//-----------------------------------------
	
 EXEC2:
 begin
	case (ir[4:0])
	
	5'd0:
	begin //LDACI
	 write_en <= 13'b110000000000 ; //arb ar
	 inc <= 2'b01; //pc
	 bus_ld <= 4'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;
	end

	5'd1:
	begin //LDAC1
	 write_en <= 13'b000000010000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;
	end	
	
	5'd10:
	begin //ADDTR   //have an issue here.....................................................
	 write_en <= 13'b0000001000000 ; //tr
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end
	
	5'd11:
	begin //ADDR1  
	 write_en <= 13'b0000000010000 ; //r1
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end	
	
	5'd12:
	begin //ADDR2  
	 write_en <= 13'b0000000001000 ; //r2
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b000;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end	
	
	5'd13:
	begin //STACI
	 write_en <= 13'b1100000000000 ; //arb ar
	 inc <= 2'b01; //pc
	 bus_ld <= 4'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;		
	end
	
//	4'b1010:	//JUMPZ
//	begin
//	 write_en <= 8'b10000000 ; //arb
//	 inc <= 2'b00;
//	 bus_ld <= 3'd3;//dr
//	 clr <= 3'b000;
//	 dm_wr <=1'b0;
//	 im_wr <=1'b0;
//	 next_stage <= EXEC3 ;
//	 end_op <= 1'b0;
//	end
	
	5'd27:	//JPNZ
	begin
	 write_en <= 13'b0010000000000 ; //pc
	 inc <= 2'b00;
	 bus_ld <= 4'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;
	end
	
	default : //NOOP
	begin
		write_en <= 13'b0000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 3'b000;
		dm_wr <=1'b0;
		im_wr <=1'b0;
		end_op <= 1'b0;
		next_stage <= EXEC3 ;
	end
	endcase
	
 end
	
//-----------------------------------------
	
 EXEC3:
 begin
	case (ir[4:0])
	
	5'd0:
	begin //LDACI
	 write_en <= 13'b0001000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd1;//dmem
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC4 ;
	 end_op <= 1'b0;		
	end
	 	
	5'd13:
	begin //STACI --------------------- AC --> MEM
	 write_en <= 13'b0000000000000 ; //nothing
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 3'b000;
	 dm_wr <=1'b1;
	 im_wr <=1'b0;
	 next_stage <= EXEC4 ;
	 end_op <= 1'b0;		
	end
	
	
	default : //NOOP
	begin
		write_en <= 13'b0000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 3'b000;
		dm_wr <=1'b0;
		im_wr <=1'b0;
		end_op <= 1'b0;
		next_stage <= EXEC4 ;
	end
	endcase

 end
 
 EXEC4:
 begin
	case (ir[4:0])
	5'd0:
	begin //LDACI
	 write_en <= 13'b0000000100000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd3;//dr
	 clr <= 3'b000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'b101; // pass
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;		
	end
	
	default : //NOOP
	begin
		write_en <= 13'b0000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 3'b000;
		dm_wr <=1'b0;
		im_wr <=1'b0;
		end_op <= 1'b0;
		next_stage <= FETCH1 ;
	end
	endcase

 end
 
 IDLE:
 begin
 next_stage <= IDLE ;
 write_en <= 13'b0000000000000 ; //nothing
 inc <= 2'b00;
 clr <= 3'b000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 end_op <= 1'b0; 
 end
 
default:
 begin
 next_stage <= FETCH1;
 write_en <= 13'b0000000000000 ; //nothing
 inc <= 2'b00;
 clr <= 3'b111;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 end_op <= 1'b0;
 end
endcase
end
endmodule

	
	
	
 