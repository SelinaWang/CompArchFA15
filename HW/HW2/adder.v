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
