//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn //falling button
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel  
input               serialDataIn,       // Load shift reg serially  
output reg[width-1:0] parallelDataOut,    // Shift reg data contents
output reg          serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;
    initial begin
	serialDataOut <= 0;
    end
    always @(posedge clk) begin
      if (parallelLoad) begin
        shiftregistermem <= parallelDataIn;
      end
      else if (peripheralClkEdge && (parallelLoad == 0)) begin
        shiftregistermem <= shiftregistermem << 1;
        shiftregistermem[0] <= serialDataIn;
      end

      parallelDataOut <= shiftregistermem;
      serialDataOut <= shiftregistermem[width-1];
    end
endmodule
