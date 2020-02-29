/**
* Module: Memory Data Register (MDR)
* haven't complete test bench yet
*
* Brief : The Memory data register (MDR) is an 8-bit buffer register , Its output sets up the RAM. 
* The Memory data register receives data from the bus before a write operation, and it sends data to the bus after a read operation. 
*
* Input :
* WBUS = Data from WBUS.
* data = data from Memory
* nLw  = Enable MDR to Load WBUS data 	(0 = enable)
* nLr  = Enable MDR to Load Memory data (0 = enable)
* Ew   = Enable MDR to write on WBUS
* Er   = Enable MDR to write on Memory
* CLK  = Clock
*
* Output :
* WBUS = data to WBUS
* data = data to Memory
*/
module mdr (
			inout [7:0] WBUS,
			inout [7:0] data,
			input       nLw ,
			input		nLr,
			input		Ew,
			input		Er,
			input       CLK );		
	
	reg [7:0] mdrreg ;
	
	parameter Zero_State     = 8'b0000_0000;
	parameter High_Impedance = 8'bzzzz_zzzz;
	
	assign WBUS = Ew? mdrreg : High_Impedance;
	assign data = Er? mdrreg : High_Impedance;
	
    initial begin	mdrreg <= Zero_State;	end
    
	always @(posedge CLK) begin
		if		(!nLw)	mdrreg <= WBUS;
		else if (!nLr)	mdrreg <= data;
		else			mdrreg <= mdrreg;
	end
	
endmodule
/*************************************** Test Bench ***************************************/
module t_mdr;

	wire [7:0] WBUS;
	wire [7:0] data;
	reg         CLK;
	reg         nLw;
	reg			nLr;
	reg			Ew;
	reg			Er;
	
	reg [7:0] temp_WBUS;
	reg [7:0] temp_data;
	parameter Zero_State     = 8'b0000_0000;
	parameter High_Impedance = 8'bzzzz_zzzz;
	
	assign WBUS = (Ew)? temp_WBUS : High_Impedance;
	assign data = (Er)? temp_data : High_Impedance;
	
	mdr MDR (WBUS,data,nLw,nLr,Ew,Er,CLK);	
	initial begin 
		CLK = 0 ;
		forever #50 CLK = ~CLK ;
	end

	initial begin 
			nLw = 1;	nLr = 1;	Ew = 0;	Er = 0;		temp_WBUS = 8'h15;	temp_data = 8'h17;	//do nothing	
	#100	nLw = 0;	nLr = 1;	Ew = 0;	Er = 0;		temp_WBUS = 8'h25;	temp_data = 8'h27;	//load from WBUS
	#100	nLw = 1;	nLr = 0;	Ew = 0;	Er = 1;		temp_WBUS = 8'h35;	temp_data = 8'h37;	//load form Memory
	#100	nLw = 1;	nLr = 1;	Ew = 1;	Er = 0;		temp_WBUS = 8'h45;	temp_data = 8'h47;	//write on WBUS

	
	end

endmodule
