//define gate delays
`define ADD  3'd0 #50
`define SUB  3'd1 #50
`define XOR  3'd2 #50
`define SLT  3'd3 #50
`define AND  3'd4 #50
`define NAND 3'd5 #50
`define NOR  3'd6 #50
`define OR   3'd7 #50


module ALU(ctl, a, b, result, zero);
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
output reg  s,
output reg  othercontrolsignal,
input[2:0]  ALUcommand
)

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:  begin muxindex = 0; s=0; othercontrolsignal = 0; end    
      `SUB:  begin muxindex = 0; s=1; othercontrolsignal = 1; end
      `XOR:  begin muxindex = 1; s=0; othercontrolsignal = 0; end    
      `SLT:  begin muxindex = 2; s=1; othercontrolsignal = 0; end
      `AND:  begin muxindex = 3; s=0; othercontrolsignal = 0; end    
      `NAND: begin muxindex = 3; s=0; othercontrolsignal = 1; end
      `NOR:  begin muxindex = 4; s=0; othercontrolsignal = 0; end    
      `OR:   begin muxindex = 4; s=0; othercontrolsignal = 1; end
    endcase
  end
endmodule

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
`OR orgate(carryout, axorbandcarryin, aandb); // or gate produces carryout from axorbandcarryin and aandb
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

module setlessthan
(
  input[31:0] a,     // First operand in 2's complement format
  input[31:0] b,      // Second operand in 2's complement format
  output[31:0] slt
);
  wire sum[31:0];
  adderSubtrctor32bit subtractor (sum[31:0], carryout, overflow, a[31:0], b[31:0], 1); // Instantiate the subtrctor
  slt[0] = sum[31]; // set the LSB to be the MSB of the output from the subtractor
  generate
  genvar index;
  for (index=1; index<31; index = index+1) begin
  slt[index] = 0; // set the rest of the 32 bit number to be 0
  endgenerate
endmodule


module xormodule
(
  input [31:0] a;
  input[31:0] b; 
  output [31:0] out;  
);
generate
genvar index; 
 for (index=0; index<32; index = index+1) begin
	`XOR xorgate(out[index], a[index], b[index]);
end
endgenerate
endmodule

module andmodule
(
  input [31:0] a;
  input[31:0] b;
  output [31:0] out;  
);
generate
genvar index; 
 for (index=0; index<32; index = index+1) begin
	`AND andgate(out[index], a[index], b[index]);
end
endgenerate
endmodule

module nandmodule
(
  input [31:0] a,
  input[31:0] b, 
  output [31:0] out  
);
generate
genvar index; 
 for (index=0; index<32; index = index+1) begin
	`NAND nandgate(out[index], a[index], b[index]);
end
endgenerate
endmodule

module normodule
(
  input [31:0] a,
  input[31:0] b, 
  output [31:0] out  
);
generate
genvar index; 
 for (index=0; index<32; index = index+1) begin
	`NOR norgate(out[index], a[index], b[index]);
end
endgenerate
endmodule

module ormodule
(
  input [31:0] a,
  input[31:0] b, 
  output [31:0] out  
);
generate
genvar index; 
 for (index=0; index<32; index = index+1) begin
	`OR orgate(out[index], a[index], b[index]);
end
endgenerate
endmodule

endmodule
