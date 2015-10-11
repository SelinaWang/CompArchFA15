//define gate delays
`define ADD  3'd0 #50
`define SUB  3'd1 #50
`define XOR  xor 3'd2 #50
`define SLT  3'd3 #50
`define AND  and 3'd4 #50
`define NAND nand 3'd5 #50
`define NOR  nor 3'd6 #50
`define OR  or 3'd7 #50


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
    // Your code here

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
  endgenerate
  structuralFullAdder adderlast (sum[31], carryout, a[31], bafter[31], co[30]); // Instantiate the last 1 bit full adders
  `XOR xorgate(overflow, co[30], carryout); // xor gate produces overflow from carryout2(carryin to the most significant bit and carryout
endmodule

module setlessthan
(
  input[31:0] a,     // First operand in 2's complement format
  input[31:0] b,      // Second operand in 2's complement format
  input s;
);
  wire sum[31:0];
  wire isLessThan[31:0];

  generate
  genvar index;
  for (index=0; index<32; index = index +1) begin
	`SLT sltgate(isLessThan[index], a[index], b[index])
  end
  endgenerate

  // subtractor outputs: sum carryout overflow, inputs: a, b, s
  //adderSubtrctor32bit subtractor (sum[31:0], carryout, overflow, a[31:0], b[31:0], 1); // Instantiate the subtrctor
  adderSubtrctor32bit subtractor0 (sum[0], carryout[0], overflow, a[31:0], b[31:0], 1); // Instantiate the subtrctor
  
  generate
  genvar index;
  for (index=1; index<31; index = index+1) begin
  	adderSubtrctor32bit subtractor (sum[index], carryout, overflow, a[index], b[index], 1); 
	
  isLessThan[0] = sum[31];

  end
  
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

module ALUcontrolLUT
(
output reg[2:0]     muxindex,
output reg  invertB,
output reg  othercontrolsignal,
...
input[2:0]  ALUcommand
)

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:  begin muxindex = 0; invertB=0; othercontrolsignal = ?; end    
      `SUB:  begin muxindex = 0; invertB=1; othercontrolsignal = ?; end
      `XOR:  begin muxindex = 1; invertB=0; othercontrolsignal = ?; end    
      `SLT:  begin muxindex = 2; invertB=?; othercontrolsignal = ?; end
      `AND:  begin muxindex = 3; invertB=?; othercontrolsignal = ?; end    
      `NAND: begin muxindex = 3; invertB=?; othercontrolsignal = ?; end
      `NOR:  begin muxindex = ?; invertB=?; othercontrolsignal = ?; end    
      `OR:   begin muxindex = ?; invertB=?; othercontrolsignal = ?; end
    endcase
  end
endmodule
endmodule
