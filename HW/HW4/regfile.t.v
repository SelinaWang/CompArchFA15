//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData), 
    .ReadRegister1(ReadRegister1), 
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite), 
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  integer index;	// Used to clean up the register after each test
  integer counter = 0;	// Used to test if the decoder behaves properly
  integer check1P1, check2P1, check1P2, check2P2;	// Used to check if the Read Ports behave properly

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1: 
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if(ReadData1 != 42) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed");
  end

  // Test Case 2: 
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 != 15) begin
    dutpassed = 0;
    $display("Test Case 2 Failed");
  end

  // Test Case 3: Broken Write Enable - Register is not written to
  WriteRegister = 5'd2;
  WriteData = 32'd25;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 != 25) begin
    dutpassed = 0;
    $display("Broken Write Enable - Register is not written to");
  end

  // Test Case 4: Broken Write Enable - Register is always written to
  //   Not Write '27' to register 2, verify with Read Ports 1 and 2
  WriteRegister = 5'd2;
  WriteData = 32'd27;
  RegWrite = 0;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  // Register 2 should maintain the value 25 and not change to 27
  if(ReadData1 != 25) begin
    dutpassed = 0;
    $display("Broken Write Enable - Register is always written to");
  end

  // clear all the registers
  for (index = 1; index < 32; index = index + 1) begin
    WriteRegister = index;
    WriteData = 32'd0;
    RegWrite = 1;
    ReadRegister1 = index;
    ReadRegister2 = index;
    #5 Clk=1; #5 Clk=0;
  end

  // Test Case 5: Broken Decoder - Does not know to choose the right register to write to
  //   Write '24' only to register 1, verify with Read Ports 1 and 2
  WriteRegister = 5'd1;
  WriteData = 32'd24;
  RegWrite = 1;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 != 24) begin
    dutpassed = 0;
    $display("Broken Decoder - Does not know to choose the right register to write to");
  end

  // Test Case 6: Broken Decoder - Chooses more than just the right register to write to (All registers are written to)
  for (index = 2; index < 32; index = index + 1) begin
    ReadRegister1 = index;
    ReadRegister2 = index;
    #5 Clk=1; #5 Clk=0;

    if(ReadData1 != 0)
      begin
        dutpassed = 0;
        counter = counter + 1;
      end
  end

  if (counter == 30) begin
    $display("Broken Decoder - All registers are written to");
  end

  if (counter > 0 && counter !=30) begin
    $display("Broken Decoder - Chooses more than just the right register to write to");
  end

  // clear all the registers
  for (index = 1; index < 32; index = index + 1) begin
    WriteRegister = index;
    WriteData = 32'd0;
    RegWrite = 1;
    ReadRegister1 = index;
    ReadRegister2 = index;
    #5 Clk=1; #5 Clk=0;
  end

  // Test Case 7: Broken Register Zero - Initially not zero
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 != 0) begin
    dutpassed = 0;
    $display("Broken Register Zero - Initially Not Zero");
  end

  // Test Case 8: Broken Register Zero - A register instead of the constant value zero.
  //   Write '19' to register 0, verify with Read Ports 1 and 2
  WriteRegister = 5'd0;
  WriteData = 32'd19;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;

  if(ReadData1 != 0) begin
    dutpassed = 0;
    $display("Broken Register Zero - A register instead of the constant value zero");
  end

  // clear all the registers
  for (index = 1; index < 32; index = index + 1) begin
    WriteRegister = index;
    WriteData = 32'd0;
    RegWrite = 1;
    ReadRegister1 = index;
    ReadRegister2 = index;
    #5 Clk=1; #5 Clk=0;
  end

  // Testing Read Ports

  //   Write '38' to register 17
  WriteRegister = 5'd17;
  WriteData = 32'd38;
  RegWrite = 1;
  ReadRegister1 = 5'd17;
  ReadRegister2 = 5'd17;
  #5 Clk=1; #5 Clk=0;

  //   Write '33' to register 1
  WriteRegister = 5'd1;
  WriteData = 32'd33;
  RegWrite = 1;
  ReadRegister1 = 5'd1;
  ReadRegister2 = 5'd1;
  #5 Clk=1; #5 Clk=0;

  check1P1 = ReadData1;
  check1P2 = ReadData2;

  //   Write '11' to register 17
  WriteRegister = 5'd17;
  WriteData = 32'd11;
  RegWrite = 1;
  ReadRegister1 = 5'd17;
  ReadRegister2 = 5'd17;
  #5 Clk=1; #5 Clk=0;

  //   Write '23' to register 3
  WriteRegister = 5'd3;
  WriteData = 32'd23;
  RegWrite = 1;
  ReadRegister1 = 5'd3;
  ReadRegister2 = 5'd3;
  #5 Clk=1; #5 Clk=0;

  check2P1 = ReadData1;
  check2P2 = ReadData2;

  // Test Case 9: Broken Port 1 - Always reads register 17
  if(check1P1 == 38 && check2P1 == 11) begin
    dutpassed = 0;
    $display("Broken Port 1 - Always reads register 17");
  end

  // Test Case 10: Broken Port 2 - Always reads register 17
  if(check1P2 == 38 && check2P2 == 11) begin
    dutpassed = 0;
    $display("Broken Port 2 - Always reads register 17");
  end

  // Test Case 11: Is it a perfect register file?
  for (index = 0; index < 32; index = index + 1) begin
    WriteRegister = index;
    WriteData = index;
    RegWrite = 1;
    #5 Clk=1; #5 Clk=0;
  end

  for (index = 0; index < 32; index = index + 1) begin
    RegWrite = 1;
    ReadRegister1 = index;
    ReadRegister2 = index;
    #5 Clk=1; #5 Clk=0;

    if (ReadData1 != index || ReadData2 != index) begin
      dutpassed = 0;
    end
  end


    if (!dutpassed) begin
      $display("This is not a perfect register file :(");
    end

    if (dutpassed) begin
      $display("This is a perfect register file :)");
    end


  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
