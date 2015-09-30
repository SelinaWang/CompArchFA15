// define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50

module behavioralFullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
assign {carryout, sum}=a+b+carryin;
endmodule

module structuralFullAdder(out, carryout, a, b, carryin);
output out, carryout;
input a, b, carryin;
wire axorb, axorbandcarryin, aandb;
`XOR xorgate1(axorb, a, b); // xor gate produces axorb from a and b
`XOR xorgate2(out, axorb, carryin); // xor gate produces out(sum) from axorb and carryin
`AND andgate1(axorbandcarryin, axorb, carryin); // and gate produces axorbandcarryinn from axorb and carryin
`AND andgate2(aandb, a, b);
`OR orgate(carryout, axorbandcarryin, aandb);
endmodule

module FullAdder4bit
(
  output[3:0] sum,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  output overflow,  // True if the calculation resulted in an overflow
  input[3:0] a,     // First operand in 2's complement format
  input[3:0] b      // Second operand in 2's complement format
);
  wire carryin = 0; // 0 is Carry in to the least significant bit
  wire carryout0, carryout1, carryout2;
  structuralFullAdder adder0 (sum[0], carryout0, a[0], b[0], carryin);
  structuralFullAdder adder1 (sum[1], carryout1, a[1], b[1], carryout0);
  structuralFullAdder adder2 (sum[2], carryout2, a[2], b[2], carryout1);
  structuralFullAdder adder3 (sum[3], carryout, a[3], b[3], carryout2);
  `XOR xorgate(overflow, carryout2, carryout);
endmodule

module test4bitFullAdder;
reg[3:0] a, b;
wire [3:0] sum;
wire carryout, overflow;
FullAdder4bit adder4bit(sum, carryout, overflow, a, b);
initial begin
$display("a     b    | sum    carryout   overflow| Expected Output");
a=4'b0001;b=4'b0111; #1000
$display("%b  %b | %b   %b          %b       | 1000    0     1", a, b, sum, carryout,overflow);
end
endmodule

module testFullAdder;
reg a, b, carryin;
wire sum, carryout;
//behavioralFullAdder adder (sum, carryout, a, b, carryin);
structuralFullAdder adder (sum, carryout, a, b, carryin);

initial begin
$display("a b carryin | sum carryout | Expected Output");
a=0;b=0;carryin=0; #1000
$display("%b %b    %b    |  %b     %b     | 0  0", a, b, carryin, sum, carryout);
a=0;b=0;carryin=1; #1000
$display("%b %b    %b    |  %b     %b     | 1  0", a, b, carryin, sum, carryout);
a=0;b=1;carryin=0; #1000
$display("%b %b    %b    |  %b     %b     | 1  0", a, b, carryin, sum, carryout);
a=0;b=1;carryin=1; #1000
$display("%b %b    %b    |  %b     %b     | 0  1", a, b, carryin, sum, carryout);
a=1;b=0;carryin=0; #1000
$display("%b %b    %b    |  %b     %b     | 1  0", a, b, carryin, sum, carryout);
a=1;b=0;carryin=1; #1000
$display("%b %b    %b    |  %b     %b     | 0  1", a, b, carryin, sum, carryout);
a=1;b=1;carryin=0; #1000
$display("%b %b    %b    |  %b     %b     | 0  1", a, b, carryin, sum, carryout);
a=1;b=1;carryin=1; #1000
$display("%b %b    %b    |  %b     %b     | 1  1", a, b, carryin, sum, carryout);
end
endmodule
