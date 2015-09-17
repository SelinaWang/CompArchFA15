module hw1test;
reg A; // The input A
reg B; // The input B
wire nA;
wire nB;
wire AandB;
wire AorB;
wire nAandB;
wire nAornB;
wire nAorB;
wire nAandnB;
and andgate1(AandB, A, B); // and gate produces AandB from A and B
not AandBinv(nAandB, AandB); // inverter produces signal nAandB and takes
                             // signal AandB, and is named AandBinv
not Ainv(nA, A); // inverter produces signal nA and takes
                 // signal A, and is named Ainv
not Binv(nB, B); // inverter produces signal nB and takes
                 // signal B, and is named Binv
not AorBinv(nAorB, AorB); // inverter produces signal nAorB and takes
                          // signal AorB, and is named AorBinv
or orgate1(nAornB, nA, nB); // or gate produces nAornB from nA and nB
or orgate2(AorB, A, B); // or gate produces AorB from A and B
and andgate2(nAandnB, nA, nB); // and gate produces nAandnB from nA and nB
initial begin
$display("A B | ~A ~B | ~(AB)  ~A+~B  |  ~(A+B)  ~A~B  "); // Prints header for truth table
A=0;B=0; #1 // Set A and B, wait for update (#1)
$display("%b %b |  %b  %b |    %b      %b   |    %b       %b ", A,B, nA, nB, nAandB, nAornB, nAorB, nAandnB);
A=0;B=1; #1 // Set A and B, wait for new update
$display("%b %b |  %b  %b |    %b      %b   |    %b       %b ", A,B, nA, nB, nAandB, nAornB, nAorB, nAandnB);
A=1;B=0; #1
$display("%b %b |  %b  %b |    %b      %b   |    %b       %b ", A,B, nA, nB, nAandB, nAornB, nAorB, nAandnB);
A=1;B=1; #1
$display("%b %b |  %b  %b |    %b      %b   |    %b       %b ", A,B, nA, nB, nAandB, nAornB, nAorB, nAandnB);
end
endmodule
