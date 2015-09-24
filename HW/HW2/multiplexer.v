// define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50

module behavioralMultiplexer(out, address0,address1, in0,in1,in2,in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
wire[3:0] inputs = {in3, in2, in1, in0};
wire[1:0] address = {address1, address0};
assign out = inputs[address];
endmodule

module structuralMultiplexer(out, address0,address1, in0,in1,in2,in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
wire naddress0, naddress1, naddress0andnaddress1andin0, address0andnaddress1andin1, naddress0andaddress1andin2, address0andaddress1andin3;
`NOT address0inv(naddress0, address0); // inverter produces signal naddress0 and takes signal address0, and is named address0inv
`NOT address1inv(naddress1, address1); // inverter produces signal naddress1 and takes signal address1, and is named address1inv
`AND andgate1(naddress0andnaddress1andin0, naddress0, naddress1, in0); // and gate produces out0 from naddress0, naddress1, and in0
`AND andgate2(address0andnaddress1andin1, address0, naddress1, in1); // and gate produces out1 from address0, naddress1, and in1
`AND andgate3(naddress0andaddress1andin2, naddress0, address1, in2); // and gate produces out2 from naddress0, address1, and in2
`AND andgate4(address0andaddress1andin3, address0, address1, in3); // and gate produces out3 from address0, address1, and in3
`OR orgate(out, naddress0andnaddress1andin0, address0andnaddress1andin1, naddress0andaddress1andin2, address0andaddress1andin3);
endmodule

module testMultiplexer;
reg addr0, addr1;
reg in0, in1, in2, in3;
wire out;
//behavioralMultiplexer multiplexer (out, addr0,addr1, in0,in1,in2,in3);
structuralMultiplexer multiplexer (out, addr0,addr1, in0,in1,in2,in3);

initial begin
$display("I0 I1 I2 I3 A0 A1 | Out | Expected Output");
in0=0;in1=0;in2=0;in3=0;addr0=0;addr1=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      0", in0, in1, in2, in3, addr0, addr1, out);
in0=1;in1=0;in2=0;in3=0;addr0=0;addr1=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      1", in0, in1, in2, in3, addr0, addr1, out);
in0=0;in1=0;in2=0;in3=0;addr0=1;addr1=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      0", in0, in1, in2, in3, addr0, addr1, out);
in0=0;in1=1;in2=0;in3=0;addr0=1;addr1=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      1", in0, in1, in2, in3, addr0, addr1, out);
in0=0;in1=0;in2=0;in3=0;addr0=0;addr1=1; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      0", in0, in1, in2, in3, addr0, addr1, out);
in0=0;in1=0;in2=1;in3=0;addr0=0;addr1=1; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      1", in0, in1, in2, in3, addr0, addr1, out);
in0=0;in1=0;in2=0;in3=0;addr0=1;addr1=1; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      0", in0, in1, in2, in3, addr0, addr1, out);
in0=0;in1=0;in2=0;in3=1;addr0=1;addr1=1; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |      1", in0, in1, in2, in3, addr0, addr1, out);
end
endmodule
