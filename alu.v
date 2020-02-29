/*
* Module: 8-bit ALU & 2-bit Flags
*
* Brief : ALUs have 4 or more control bits that determine the arithmetic or logic operation performed on words A and B. 
* The ALU used in SAP-2 includes arithmetic and logic operations. 
* a flag is a flip-flop that keeps track of a changing condition during a computer run. 
* The SAP-2 computer has two flags. The sign flag is set when the accumulator contents become negative during the execution 
*
* Input :
* accumulator  = data From Accumulator
* tmp          = data From Register TMP.
* Sel          = Operation Selector 
* Eu           = Enable output to WBUS
*
* Output :
* result = Data to WBUS.
* flags  = zero & sign Flags

sel [3] -> 1 if the operation dosnt effect on flags
*/
module alu (
			output  [7:0]  wbus,
			output [1:0]  flags,
			input  [7:0]  accumulator,
			input  [7:0]  tmp,
			input  [3:0]  Sel,
			input         Eu );

	parameter High_Impedance = 8'bzzzz_zzzz;
	parameter Zero_State     = 8'b0000_0000;
			
   reg [7:0] alu_res ;                         // register for the result 

   initial begin
		alu_res <= Zero_State;
   end
   
   	// Write your Code here :
	
	assign flags[0] = Sel[3]? flags[0] : ((alu_res == 0)? 1 : 0 );//  zero flag 
	assign flags[1] = Sel[3]? flags[1] : ((alu_res[7]== 1)? 1 : 0) ;  // sign flag 
	
	assign wbus = Eu? alu_res: High_Impedance ;     // DATA TO W BUS IF ENABLE 

	
	always @(*)
	case(Sel)
	4'b0000 : alu_res  <= accumulator + tmp ;    // add x  , x is b , c 
	4'b0001 : alu_res  <= accumulator - tmp ;    // sub x 
	4'b0010 : alu_res  <= accumulator & tmp ;       // and x , ani
	4'b0011 : alu_res  <= accumulator | tmp ;        // or x ,  ori 
	4'b0100 : alu_res  <=  tmp - 1 ;                 // dcr x , 
	4'b0101 : alu_res  <=  tmp + 1 ;                 // inc x , 
	4'b0110 : alu_res  <= accumulator ^ tmp ;        // xor x ,  xori 
	4'b1110 : alu_res  <=  {accumulator[6:0],accumulator[7]} ;                 // ral 
	4'b1111 : alu_res  <=  {accumulator[0],accumulator[7:1]};                 // rar
	
	
	
	endcase
	
	
	
	
	
	
   
endmodule
/*************************************** Test Bench ***************************************/
module t_alu ;

	wire [7:0]  wbus;
	wire [1:0]  flags;
	reg  [7:0]  tmp;
	reg  [7:0]  accumulator;
	reg  [3:0]  Sel;
	reg         Eu;

	alu ALU (wbus,flags,accumulator,tmp,Sel,Eu);

	initial begin 
		
		// Write your Test Cases here :
		Eu = 0 ; Sel = 4'b0000 ; accumulator = 5 ; tmp = 5 ;
		#100  Eu = 1 ; Sel = 4'b0000 ; accumulator = 5 ; tmp = 5 ;     // result = 5 + 5 = 10
		#100  Eu = 0 ; Sel = 4'b0001 ; accumulator = 7 ; tmp = 5 ;      // result = high due to  eu = 0
		#100  Eu = 1 ; Sel = 4'b0001 ; accumulator = 10 ; tmp = 5 ;      // result = 10 -5  = 5
		#100  Eu = 1 ; Sel = 4'b0001 ; accumulator = 2 ; tmp = 5 ;      // result = 2 -5  = -3       sign flag = 1 
		#100  Eu = 1 ; Sel = 4'b0010 ; accumulator = 2 ; tmp = 5 ;        // result = 2 & 5 = 0      zero flag = 1 
		#100  Eu = 1 ; Sel = 4'b0011 ; accumulator = 2 ; tmp = 5 ;        //  2 | 5 = 7
		#100  Eu = 1 ; Sel = 4'b1111 ; accumulator = 10 ; tmp = 5 ;        // rar 00001010 -> 00000101
		
		#100  Eu = 1 ; Sel = 4'b0100 ; accumulator = 2 ; tmp = 5 ;        //  result = tmp - 1 
		#100  Eu = 1 ; Sel = 4'b0110  ; accumulator = 15 ; tmp = 5 ;        //  15 ^ 5 = 7
		
		
	end

endmodule
