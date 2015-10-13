//define gate delays
`define AND and #20
`define OR or #20
`define NOT not #10
`define NOR nor #10
`define NAND nand #10
`define XOR xor #30

//define operations
`define ADD_OP  3'd0 
`define SUB_OP  3'd1 
`define XOR_OP  3'd2 
`define SLT_OP  3'd3 
`define AND_OP  3'd4 
`define NAND_OP 3'd5 
`define NOR_OP  3'd6 
`define OR_OP   3'd7 


module ALU(addr, a, b, result, carryout, overflow, zero);
(
output[31:0]    result, 
output          carryout,
output          zero,
output          overflow,
input[31:0]     operandA,//a,b
input[31:0]     operandB,//a,b
input[2:0]      command
);

module ALUcontrolLUT
(
output reg[2:0] muxindex,
output reg  inv_a,
output reg  inv_b,
input[2:0]  ALUcommand
)

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD_OP:  begin muxindex = 0; inv_b=0; inv_a = 0; end    
      `SUB_OP:  begin muxindex = 0; inv_b=1; inv_a = 0; end
      `XOR_OP:  begin muxindex = 1; inv_b=0; inv_a = 0; end    
      `SLT_OP:  begin muxindex = 2; inv_b=1; inv_a = 0; end
      `AND_OP:  begin muxindex = 3; inv_b=0; inv_a = 0; end
      `NOR_OP:  begin muxindex = 3; inv_b=1; inv_a = 1; end    
      `NAND_OP: begin muxindex = 4; inv_b=1; inv_a = 1; end    
      `OR_OP:   begin muxindex = 4; inv_b=0; inv_a = 0; end
    endcase
  end
endmodule

//Different Structural Mux with Generate?

module 
(
input[2:0] muxindex
input inv_a,
input inv_b,
input[31:0] addsub_in,
input[31:0] xor_in, 
input[31:0] andnor_in, 
input[31:0] ornand_in,
input slt_in, 
output[31:0] Output,
);



module structuralmux(out, command, andnor_in, ornand_in, xor_in, addsub_in, slt_in) 
//INPUTS: "(gate)_in" = output of operations, "command" = address -> which op to perform
//OUTPUT: "out" = result of selected op
output[31:0] out;
input[2:0] command; //3bit command address
input[31:0] andnor_in; //result of and/nor operation
input[31:0] ornand_in; //result of or/nand operation
input[31:0] xor_in; //result of xor operation
input[31:0] addsub_in; //result of add/sub operation
input slt_in; //result of set less than operation

wire[2:0] inv)command; //3 bits: are the inputs inversed? EX to make AND gate a NOR gate, etc.
wire[31:0] andnor_enable;
wire[31:0] ornand_enable;
wire[31:0] xor_enable;
wire[31:0] addsub_enable;
wire slt_enable;
//only one of the gate enables should be true - determined by command input

//determine what is enabled  /
`NOT not0(inv_command[0], command[0]);
`NOT not1(inv_command[1], command[1]);
`NOT not2(inv_command[2], command[2]);
`AND andgate_slt(slt_enable, slt_in, inv_command[2], command[1], inv_command[0]);

generate
genvar index;
for (index = 0; index<32; index = index + 1)
	begin: muxgen
		`AND andgate_andnor(andnor_enable[index], andnor_in[index], inv_command[2], command[1], command[0[); 
		`AND andgate_ornand(ornand_enable[index], ornand_in[index], command[2] inv_command[1], inv_command[0]);
		`AND andgate_xor(xor_enable[index], xor_in[index], inv_command[2], inv_command[[1], command[0]);
		`AND andgate_addsub(addsub_enable[index], addsub_in[index], inv_command[2[, inv_command[1], inv_command[0]); 
		`OR  orgate3(out[index], andnor_enable[index], ornand_enable[index], xor_enable[index], addsub_enable[index], slt_enable);
	end
endgenerate
end module

///////////////////////////


module structuralMultiplexer(out, address0,address1, address2,in0,in1,in2,in3,in4,in5,in6,in7);
output out;
input address0, address1, address2;
input in0, in1, in2, in3, in4, in5, in6, in7;
wire naddress0, naddress1, naddress2, naddress0andnaddress1andin0, address0andnaddress1andin1, naddress0andaddress1andin2, address0andaddress1andin3;
`NOT address0inv(naddress0, address0); // inverters produce signals naddress[i] and take signals address[i], and are named address[i]inv
`NOT address1inv(naddress1, address1); 
`NOT address1inv(naddress2, address2); 
`AND andgate1(nadd0andnadd1andnadd2andin0, naddress0, naddress1, naddress2, in0); // and gates produce out[i] from (n)address0, (n)address1, (n)address2, and in[i]
`AND andgate2(nadd0andnadd1andadd2andin1, naddress0, naddress1, address2, in1);
`AND andgate3(nadd0andadd1andnadd2andin2, naddress0, address1, naddress2, in2);
`AND andgate4(nadd0andadd1andadd2andin3, naddress0, address1, address2, in3);
`AND andgate5(add0andnadd1andnadd2andin4, address0, naddress1, naddress2, in4);
`AND andgate6(add0andnadd1andadd2andin5, address0, naddress1, address2, in5);
`AND andgate7(add0andadd1andnadd2andin6, address0, address1, naddress2, in6);
`AND andgate8(add0andadd1andadd2andin7, address0, address1, address2, in7);
`OR orgate(out, nadd0andnadd1andnadd2andin0, nadd0andnadd1andadd2andin1, nadd0andadd1andnadd2andin2, nadd0andadd1andadd2andin3, add0andnadd1andnadd2andin4, add0andnadd1andadd2andin5, add0andadd1andnadd2andin6, add0andadd1andadd2andin7);
endmodule

module structuralFullAdder(out, carryout, a, b, carryin);
output out, carryout;
input a, b, carryin;
wire axorb, axorbandcarryin, aandb;
`XOR xorgate1(axorb, a, b); // xor gate produces axorb from a and b
`XOR xorgate2(out, axorb, carryin); // 
`AND andgate1(axorbandcarryin, axorb, carryin); // and gate produces axorbandcarryinn from axorb and carryin
`AND andgate2(aandb, a, b);
`OR orgate1 carryout, axorbandcarryin, aandb); // or gate produces carryout from axorbandcarryin and aandb
endmodule

module adderSubtractor32bit
(
  output[31:0] sum,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  output overflow,  // True if the calculation resulted in an overflow
  input[31:0] a,     // First operand in 2's complement format
  input[31:0] b,      // Second operand in 2's complement format
  input s 	   //subtractor enable
);
  wire carryin = 0; // 0 is Carry in to the least significant bit
  wire co[31:0]; // Wiring the 32 1 bit adders together by assigning the previous carryout as the next carryin
  wire bafter[31:0];

  generate
  genvar index;
  for (index=0; index<32; index = index+1) begin
	`XOR xorgate1(bafter[index], s, b[index]);
  end
  endgenerate

  structuralFullAdder adder0 (sum[0], co[0], a[0], bafter[0], carryin); // Instantiate the first 1 bit full adders
  generate
  genvar index;
  for (index=1; index<31; index = index+1) begin
  structuralFullAdder adder (sum[index], co[index], a[index], bafter[index], co[index-1]); // Instantiate the middle 30 1 bit full adders
  end
  endgenerate
  structuralFullAdder adderlast (sum[31], carryout, a[31], bafter[31], co[30]); // Instantiate the last 1 bit full adders
  `XOR xorgate(overflow, co[30], carryout); // xor gate produces overflow from carryout2(carryin to the most significant bit and carryout
endmodule

//module setlessthan
//(
//  input[31:0] a,     // First operand in 2's complement format
//  input[31:0] b,      // Second operand in 2's complement format
//  output[31:0] slt
//);
//  wire sum[31:0];
//  adderSubtrctor32bit subtractor (sum[31:0], carryout, overflow, a[31:0], b[31:0], 1); // Instantiate the subtrctor
//  slt[0] = sum[31]; // set the LSB to be the MSB of the output from the subtractor
//  generate
//  genvar index;
//  for (index=1; index<31; index = index+1) begin
//  slt[index] = 0; // set the rest of the 32 bit number to be 0
//  endgenerate
//endmodule

//////
module setlessthanmodule(sum, overflow, sltout);
//Outputs a single bit (1 if input a is less than input b)
input[31:0] sum;
input overflow;
output sltout;
//XOR Overflow and SumMSB output from 32bitAdder/Subtractor
//If a < b: If no overflow, msb of sum = 1 If overflow, msb of sum will = 0
`XOR xorgate_slt(sltout, sum[31], overflow);
//Note: No generate needed for SLT because only 1 bit matters in each! (Output also 1 bit true/fasle)
endmodule


module xormodule(a, b, out);
  input wire [31:0] a,
  input wire[31:0] b, 
  output [31:0] out  
   
generate //generate 32 XOR gates to xor all 32 bits of a and b
genvar index; 
 for (index=0; index<32; index = index+1) 
	begin: xorgen
		`XOR xorgate1(out[index], a[index], b[index]);
	end
endgenerate
endmodule

module andmodule(a, b, out); //out=1 if a=1 and b=1, else out = 0
output[31:0] out;
input[31:0] a;
input[31:0] b;

//becomes NOR gate if the inputs a and b are both inverted (?)

generate //generate 32 AND gate to compare all 32 bits of a and b 
genvar index;
for (index = 0; index<32; index = index + 1)
	begin: andgen
		`AND andgate(out[index], a[index], b[index]); 
	end
endgenerate
endmodule

module ormodule(a, b, out);
output[31:0] out;
input[31:0] a;
input [31:0] b;

//becomes NAND gate if a and b are both inverted (?)

generate //generate 32 OR gates to or all32 bits of a and b
genvar index;
for (index = 0; index<32; index = index + 1)
	begin: orgen
		`OR orgate2(out[index], a[index], b[index]);
	end
endgenerate
endmodule

//module nandmodule
//(
//  input [31:0] a,
//  input[31:0] b, 
//  output [31:0] out  
//);
//generate
//genvar index; 
// for (index=0; index<32; index = index+1) begin
//	`NAND nandgate(out[index], a[index], b[index]);
//end
//endgenerate
//endmodule

//module normodule
//(
//  input [31:0] a,
//  input[31:0] b, 
//  output [31:0] out  
//);
//generate
//genvar index; 
// for (index=0; index<32; index = index+1) begin
//	`NOR norgate(out[index], a[index], b[index]);
//end
//endgenerate
//endmodule

