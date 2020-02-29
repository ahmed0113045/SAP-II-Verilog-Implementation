/**
* Instruction Registor (IR)
*
* Input :
* CLK    = Clock
* nLi    = Load Load from WBUS (8-bit). 0 = load
* nEi    = Output Address. 0 = Output to lower part of WBUS (4-bit)
* nCLR   = Clear
* WBUS   = Data from WBUS
*
* Output :
* Bits [3 : 0] => address
* addr   = Address to WBUS
* Bits [7 : 4] => opcode
* opcode = Op Code to Determine the Operation
*/
module instruction_register (
							output [3:0] addr,
							output [3:0] opcode,
							input        CLK,
							input        nLi,
							input        nEi,
							input        nCLR,
							input  [7:0] WBUS );

	parameter High_Impedance = 4'bzzzz;
	parameter Zero_State     = 4'b0000;

    reg [3:0] op_reg ;
    reg [3:0] add_reg ;

    initial begin
		op_reg    <= Zero_State;
		add_reg   <= High_Impedance;
    end
    
	assign addr   = (!nEi) ? add_reg : High_Impedance;
    assign opcode = op_reg ;
    
    always @(posedge CLK) begin

        if(!nCLR) begin
            op_reg    <= Zero_State;
            add_reg   <= High_Impedance;
        end

        else begin

			if(!nLi) begin
				// Load the data
                op_reg   <= WBUS[7:4];
	            add_reg  <= WBUS[3:0];
            end

            else begin
                // DO Nothing
                op_reg   <= op_reg;
                add_reg  <= add_reg;
            end
        end
    end
endmodule
/***************************************************************************/
module t_instruction_register ;

wire [3:0] addr;
wire [3:0] opcode;
reg  [7:0] WBUS;
reg        CLK;
reg        nLi,nEi,nCLR ;

instruction_register IS (addr,opcode,CLK,nLi,nEi,nCLR,WBUS );

initial begin 
CLK = 0 ;
forever #50 CLK = ~CLK ;
end

initial begin 

     nCLR = 0 ; nLi = 1 ; nEi = 1 ; WBUS = 8'hca;
#100 nCLR = 0 ; nLi = 1 ; nEi = 1 ; WBUS = 8'hca;
#100 nCLR = 1 ; nLi = 0 ; nEi = 1 ; WBUS = 8'hca;
#100 nCLR = 1 ; nLi = 0 ; nEi = 0 ; WBUS = 8'hca;
#100 nCLR = 1 ; nLi = 1 ; nEi = 1 ; WBUS = 8'hfe;
#100 nCLR = 1 ; nLi = 1 ; nEi = 0 ; WBUS = 8'hfe;
#100 nCLR = 1 ; nLi = 0 ; nEi = 1 ; WBUS = 8'hfe;
#100 nCLR = 1 ; nLi = 0 ; nEi = 0 ; WBUS = 8'h99;
#100 nCLR = 1 ; nLi = 0 ; nEi = 0 ; WBUS = 8'h8e;
#100 nCLR = 1 ; nLi = 1 ; nEi = 0 ; WBUS = 8'h57;
#100 nCLR = 1 ; nLi = 0 ; nEi = 0 ; WBUS = 8'h67;

end

endmodule
