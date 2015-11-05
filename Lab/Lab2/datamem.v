//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------


`include 
"register.v"


	wire[31:0] q[31:0];  
	
	wire[31:0] decoderOut;	

	//Decoder
	decoder1to32 decoder1(decoderOut, RegWrite, WriteRegister);
	//1st register outputs zero
	register32zero reg0(q[0], WriteData, decoderOut[0], Clk);
	//All other 31 registers
	genvar index;
  	generate
    		for (index = 1; index < 32; index = index + 1) begin: registerGen
			register32 register (q[index], WriteData, decoderOut[index], Clk);
  		end
  	endgenerate

	//Mux1
	mux32to1by32 mux1(ReadData1,Address, q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7], q[8], q[9], q[10], q[11], q[12], q[13], q[14], q[15], q[16], q[17], q[18], q[19], q[20], q[21], q[22], q[23], q[24], q[25], q[26], q[27], q[28], q[29], q[30], q[31]);
	


endmodule
