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
  wire carryout0, carryout1, carryout2; // Wiring the four 1 bit adders together by assigning the previous carryout as the next carryin
  wire bafter[31:0],
 `XOR xorgate1(bafter[31:0], s, b[31:0]) 
  structuralFullAdder adder0 (sum[0], carryout0, a[0], bafter[0], carryin); // Instantiate four of the 1 bit full adders
  structuralFullAdder adder1 (sum[1], carryout1, a[1], bafter[1], carryout0);
  structuralFullAdder adder2 (sum[2], carryout2, a[2], bafter[2], carryout1);
  structuralFullAdder adder3 (sum[3], carryout, a[3], bafter[3], carryout2);
  `XOR xorgate(overflow, carryout2, carryout); // xor gate produces overflow from carryout2(carryin to the most significant bit and carryout
endmodule






module structuralALU(ctl, a, b, result, zero);
output result, zero;
input ctl, a, b;
wire 
endmodule


module ALU32bit

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
