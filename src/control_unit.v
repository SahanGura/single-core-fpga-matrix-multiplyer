module control_unit
(input [7:0] ir,
 input clk,
 input z,

 output reg end_op, output reg [1:0] inc, output reg [3:0] alu_mode, output reg[3:0] bus_ld ,
 output reg [15:0] write_en, output reg [5:0] clr, output reg dm_wr , im_wr , dm_addr = 1'b0);

 parameter FETCH1 = 4'd0, FETCH2 = 4'd1, FETCHX = 4'd2, FETCH3 = 4'd3, EXEC1 = 4'd4, EXECX = 4'd5, EXEC2 = 4'd6,
 EXEC3 = 4'd7, EXECY = 4'd8, EXEC4 = 4'd9, IDLE = 4'd10, PASS = 4'd11;

 reg[3:0] stage, next_stage = FETCH1, prev_stage;
 
 //---------------------------------------------------------------------------
 
 //WRITE_EN 0   0   0   0  0  0  0  0  0 0	0	0	0	0	0   0
 //	   		Ra  Rb	ARB AR PC DR IR R TR AC	R1	R2	Ri Rj	Rk  R3
 
//BUS_LD 	0     1     2  3  4  5    6    7  8	9	10	11	 12	(Dec Val/3bit BINARY)0-->5 busread 
 //	     IMEMB DMEMB PC DR R  AC  TR	R1	R2	Ri	Rj	Rk   R3
 
 
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
 prev_stage <= next_stage;
 stage = next_stage;
 
 case (stage)
 PASS:
 begin
	next_stage <= prev_stage + 4'd1 ;
	end_op <= 1'b0;
 end

 FETCH1 :
 begin
 write_en <= 16'b0001000000000000 ; //ar
 inc <= 2'b00;
 dm_addr <=1'b0;
 clr <= 6'b000000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= FETCH2 ;
 end_op <= 1'b0;
 end
 
 FETCH2:
 begin
 write_en <= 16'b0000010000000000 ; //dr
 inc <= 2'b01; //pc
 dm_addr <=1'b0;
 bus_ld <= 4'd0;//i_mem
 clr <= 6'b000000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= FETCHX ;
 end_op <= 1'b0;
 end

 FETCHX:
 begin
 write_en <= 16'b0000010000000000 ; //dr
 inc <= 2'b00; //pc
 dm_addr <=1'b0;
 bus_ld <= 4'd0;//i_mem
 clr <= 6'b000000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= FETCH3 ;
 end_op <= 1'b0;
 end
 
 FETCH3:
 begin
 write_en <= 16'b0001001000000000 ; //ar ir
 inc <= 2'b00;
 dm_addr <=1'b0;
 bus_ld <= 4'd3;//dr
 clr <= 6'b000000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 next_stage <= PASS ;
 end_op <= 1'b0;
 end

//  FETCHY:
//  begin
//  write_en <= 16'b0000001000000000 ; //ir
//  inc <= 2'b00;
//  bus_ld <= 4'd3;//dr
//  clr <= 4'b0000;
//  dm_wr <=1'b0;
//  im_wr <=1'b0;
//  next_stage <= EXEC1 ;
//  end_op <= 1'b0;
//  end
 
 EXEC1:
 begin
	case (ir[5:0])
	
	6'd0:
	begin //LDACI
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd0;//imem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXECX ;
	 end_op <= 1'b0;
	end
	
	6'd1:
	begin //LDAC
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd1;//dmem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXECX ;
	 end_op <= 1'b0;
	end

	6'd29:
	begin //LDACRi
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd9;//ri
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd30:
	begin //LDACRj
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd10;//rj
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd31:
	begin //LDACRk
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd11;//rk
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd32:
	begin //LDACR3
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd12;//r3
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd34:
	begin //LDACRa
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd13;//ra
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= EXECX;
	 end_op <= 1'b0;
	end

	6'd35:
	begin //LDACRb
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd14;//ra
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= EXECX;
	 end_op <= 1'b0;
	end
	
	6'd2: 
	begin //LDARR1
	 write_en <= 16'b0011000000000000 ; //arb ar
	 dm_addr <=1'b1;
	 inc <= 2'b00;
	 bus_ld <= 4'd7;//r1
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end
	
	6'd3: 
	begin //LDARR2
	 write_en <= 16'b0011000000000000 ; //arb ar
	 dm_addr <=1'b1;
	 inc <= 2'b00;
	 bus_ld <= 4'd8;//r2
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end	
	
	6'd4: 
	begin //MVACR
	 write_en <= 16'b0000000100000000 ; //r
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 4'b0000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end

	6'd8: 
	begin //MVACR1
	 write_en <= 16'b0000000000100000 ; //r1
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end

	6'd9: 
	begin //MVACR2
	 write_en <= 16'b0000000000010000 ; //r2
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end

	6'd33: 
	begin //MVACR3
	 write_en <= 16'b0000000000000001 ; //r3
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end

	6'd5: 
	begin //MVACRi
	 write_en <= 16'b0000000000001000 ; //ri
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end

	6'd6: 
	begin //MVACRj
	 write_en <= 16'b0000000000000100 ; //rj
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 4'b0000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end

	6'd7: 
	begin //MVACRk
	 write_en <= 16'b0000000000000010 ; //rk
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end	

	6'd36: 
	begin //MVACRa
	 write_en <= 16'b1000000000000010 ; //ra
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end	
	
	6'd37: 
	begin //MVACRb
	 write_en <= 16'b0100000000000000 ; //rb
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end

	6'd10:
	begin //ADDTR   //have an issue here.....................................................
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd6;//tr
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd0;		//add
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end
	
	6'd11:
	begin //ADDR1
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd7;//r1
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd0;		//add
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end	
	
	6'd12:
	begin //ADDR2
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd8;//r2
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd0;		//add
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end

	6'd13:	
	begin //STACI
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd0;//imem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXECX;
	 end_op <= 1'b0;
	end		
		
	6'd14:
	begin //STTR
	 write_en <= 16'b0000000000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd6;//tr
	 clr <= 6'b000000;
	 dm_wr <=1'b1;
	 im_wr <=1'b0;
	 next_stage <= EXECX ;
	 end_op <= 1'b0;	
	end
	
	6'd15: //MULT
	begin 
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd4;//r
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd2; //mult
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end
	
	6'd16: //MULTRi
	begin 
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd9;//ri
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd2; //mult
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end	

	6'd17: //MULTRj
	begin 
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd10;//rj
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd2; //mult
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd18: //MULTRk
	begin 
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd11;//rk
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd2; //mult
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end		
	
	6'd19: //SUB
	begin
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd4;//r
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd1; //sub
	 next_stage <= FETCH1;
	 end_op <= 1'b0;	
	end
	
	6'd20: //SUBRi
	begin
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd9;//ri
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd1; //sub
	 next_stage <= FETCH1;
	 end_op <= 1'b0;	
	end	
	
	6'd21: //SUBRj
	begin
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd10;//rj
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd1; //sub
	 next_stage <= FETCH1;
	 end_op <= 1'b0;	
	end

	6'd22: //SUBRk
	begin
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd11;//rk
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd1; //sub
	 next_stage <= FETCH1;
	 end_op <= 1'b0;	
	end		
	
	6'd23: //CLRR
	begin
	 write_en <= 16'b0000000000000000 ;
	 inc <= 2'b00;
	 clr <= 6'b001000; //r
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1;
	 end_op <= 1'b0;		
	end
	
	6'd24: //CLRAC
	begin
	 write_en <= 16'b0000000000000000 ;
	 inc <= 2'b00;
	 clr <= 6'b000100; //ac
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1;
	 end_op <= 1'b0;		
	end	
	
	6'd25: //CLRTR
	begin
	 write_en <= 16'b0000000000000000 ;
	 inc <= 2'b00;
	 clr <= 6'b000010; //tr
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1;
	 end_op <= 1'b0;		
	end	

	6'd38: //CLRR1
	begin
	 write_en <= 16'b0000000000000000 ;
	 inc <= 2'b00;
	 clr <= 6'b100000; //r1
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1;
	 end_op <= 1'b0;		
	end	

	6'd39: //CLRR2
	begin
	 write_en <= 16'b0000000000000000 ;
	 inc <= 2'b00;
	 clr <= 6'b010000; //r2
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1;
	 end_op <= 1'b0;		
	end			
	
	6'd26: //INCAC
	begin
	 write_en <= 16'b0000000000000000 ;
	 inc <= 2'b10; //ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1;
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
	
	6'd27:	//JPNZ
	begin
	 if (z==0)
		begin
		 write_en <= 16'b0000010000000000 ; //dr
		 inc <= 2'b00;
		 bus_ld <= 4'd0;//imem
		 clr <= 6'b000000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= EXECX ;
		 end_op <= 1'b0;
		end
	 else
		begin
		 write_en <= 16'b0000000000000000 ;
		 inc <= 2'b01; //pc
		 bus_ld <= 4'd0;//imem
		 clr <= 6'b000000;
		 dm_wr <=1'b0;
		 im_wr <=1'b0;
		 next_stage <= FETCH1 ;
		 end_op <= 1'b0;
		end
	end
	
	6'd28: //ENDOP
	begin
	 write_en <= 16'b0000000000000000 ;
	 inc <= 2'b00;
	 bus_ld <= 3'd0;//imem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= IDLE ;
	 end_op <= 1'b1;		
	end
	
	default : //NOOP
	begin
		write_en <= 16'b0000000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 6'b000000;
		dm_wr <=1'b0;
		im_wr <=1'b0;
		end_op <= 1'b0;
		next_stage <= EXEC2 ;
	end
	
	endcase
	
 end
	
//-----------------------------------------
EXECX:
begin
	case(ir[5:0])

	6'd0:
	begin //LDACI
	 write_en <= 16'b0011000000000000 ; //arb ar
	 dm_addr <=1'b1;
	 inc <= 2'b00; //pc
	 bus_ld <= 4'd3;//dr
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;
	end

	6'd1:
	begin //LDAC
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd1;//dmem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;
	end

	6'd13:	
	begin //STACI
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd0;//imem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2;
	 end_op <= 1'b0;
	end	

	6'd14:
	begin //STTR
	 write_en <= 16'b0000000000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd6;//imem
	 clr <= 6'b000000;
	 dm_wr <=1'b1;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;	
	end
	
	6'd27:
	begin
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd0;//imem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC2 ;
	 end_op <= 1'b0;
	end

	6'd29:
	begin //LDACRi
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd9;//ri
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd30:
	begin //LDACRj
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd10;//rj
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd31:
	begin //LDACRk
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd11;//rk
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd32:
	begin //LDACR3
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd12;//r3
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd34:
	begin //LDACRa
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd13;//ra
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	6'd35:
	begin //LDACRb
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd14;//rB
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end

	default : //NOOP
	begin
		write_en <= 16'b0000000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 6'b000000;
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
	case (ir[5:0])
	
	6'd0:
	begin //LDACI
	 write_en <= 16'b0011000000000000 ; //arb ar
	 dm_addr <=1'b1;
	 inc <= 2'b01; //pc
	 bus_ld <= 4'd3;//dr
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC3 ;
	 end_op <= 1'b0;
	end

	6'd1:
	begin //LDAC1
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd3;//dr
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; //pass
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end	
	
	6'd10:
	begin //ADDTR   //have an issue here.....................................................
	 write_en <= 16'b0000000010000000 ; //tr
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd0; //sum
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end
	
	6'd11:
	begin //ADDR1  
	 write_en <= 16'b0000000000100000 ; //r1
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd0; //sum
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end	
	
	6'd12:
	begin //ADDR2  
	 write_en <= 16'b0000000000010000 ; //r2
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd0; //sum
	 next_stage <= FETCH1;
	 end_op <= 1'b0;
	end	
	
	6'd13:
	begin //STACI
	 write_en <= 16'b0011000000000000 ; //arb ar
	 inc <= 2'b01; //pc
	 dm_addr <=1'b1;
	 bus_ld <= 4'd3;//dr
	 clr <= 6'b000000;
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
	
	6'd27:	//JPNZ
	begin
	 write_en <= 16'b0000100000000000 ; //pc
	 inc <= 2'b00;
	 bus_ld <= 4'd3;//dr
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;
	end
	
	default : //NOOP
	begin
		write_en <= 16'b0000000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 6'b000000;
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
	case (ir[5:0])
	
	6'd0:
	begin //LDACI
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd1;//dmem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXECY ;
	 end_op <= 1'b0;		
	end
	 	
	6'd13:
	begin //STACI --------------------- AC --> MEM
	 write_en <= 16'b0000000000000000 ; //nothing
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXECY ;
	 end_op <= 1'b0;		
	end
	
	
	default : //NOOP
	begin
		write_en <= 16'b0000000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 6'b000000;
		dm_wr <=1'b0;
		im_wr <=1'b0;
		end_op <= 1'b0;
		next_stage <= EXEC4 ;
	end
	endcase

 end

 //-----------------------------------------
	
 EXECY:
 begin
	case (ir[5:0])
	
	6'd0:
	begin //LDACI
	 write_en <= 16'b0000010000000000 ; //dr
	 inc <= 2'b00;
	 bus_ld <= 4'd1;//dmem
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 next_stage <= EXEC4 ;
	 end_op <= 1'b0;		
	end

	6'd13:
	begin //STACI --------------------- AC --> MEM
	 write_en <= 16'b0000000000000000 ; //nothing
	 inc <= 2'b00;
	 bus_ld <= 4'd5;//ac
	 clr <= 6'b000000;
	 dm_wr <=1'b1;
	 im_wr <=1'b0;
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;		
	end

	default : //NOOP
	begin
		write_en <= 16'b0000000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 6'b000000;
		dm_wr <=1'b0;
		im_wr <=1'b0;
		end_op <= 1'b0;
		next_stage <= EXEC3 ;
	end
	endcase
 end


 //----------------------------------------

 EXEC4:
 begin
	case (ir[4:0])
	6'd0:
	begin //LDACI
	 write_en <= 16'b0000000001000000 ; //ac
	 inc <= 2'b00;
	 bus_ld <= 4'd3;//dr
	 clr <= 6'b000000;
	 dm_wr <=1'b0;
	 im_wr <=1'b0;
	 alu_mode <= 3'd4; // pass
	 next_stage <= FETCH1 ;
	 end_op <= 1'b0;		
	end
	
	default : //NOOP
	begin
		write_en <= 16'b0000000000000000 ; //nothing
		inc <= 2'b00;
		clr <= 6'b000000;
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
 write_en <= 16'b0000000000000000 ; //nothing
 inc <= 2'b00;
 clr <= 6'b000000;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 end_op <= 1'b0; 
 end
 
default:
 begin
 next_stage <= FETCH1;
 write_en <= 16'b0000000000000000 ; //nothing
 inc <= 2'b00;
 clr <= 6'b001111;
 dm_wr <=1'b0;
 im_wr <=1'b0;
 end_op <= 1'b0;
 end
endcase
end
endmodule

	
	
	
 