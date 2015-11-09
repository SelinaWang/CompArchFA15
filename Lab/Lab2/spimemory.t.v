//------------------------------------------------------------------------
// SPI Memory test bench
//------------------------------------------------------------------------
`include "spimemory.v"
module testspimemory();

    reg           clk;       // FPGA clock
    reg           sclk_pin;   // SPI clock
    reg           cs_pin;     // SPI chip select
    wire           miso_pin;  // SPI master in slave out
    reg           mosi_pin;   // SPI master out slave in
    reg           fault_pin;  // For fault injection testing

    // Instantiate with parameter width = 8
    spimemory 	dut(.clk(clk),
    		           .sclk_pin(sclk_pin),
    		           .cs_pin(cs_pin),
    		           .miso_pin(miso_pin),
    		           .mosi_pin(mosi_pin),
    		           .fault_pin(fault_pin));

// Generate clock (50MHz)
    initial clk=1;
    reg[7:0] address;
    reg[7:0] value;
    reg[7:0] readValue;
    integer i;
    always #10 clk=!clk;    // 50MHz Clock
    initial begin
      mosi_pin = 0;
      sclk_pin = 0;
      address =   7'b1011010;
      value =     8'b11011011;
      readValue = 8'b00000000;
      i = 0;
      cs_pin = 0;
      for (i = 0; i < 7; i = i + 1)
      begin
        mosi_pin = address[6-i];
        #200 // wait
        sclk_pin = 1;
        #200 // wait
        sclk_pin = 0;
      end
      mosi_pin = 0;
      #200 // wait
      sclk_pin = 1;
      #200 // wait
      sclk_pin = 0;
      for (i = 0; i < 8; i = i + 1)
      begin
        mosi_pin = value[i];
        #200 // wait
        sclk_pin = 1;
        #200 // wait
        sclk_pin = 0;
      end
      cs_pin = 1;
      #200 // wait
      sclk_pin = 1;
      #200 // wait
      sclk_pin = 0;
      #200 // additional wait
      for (i = 0; i < 7; i = i + 1)
      begin
        mosi_pin = address[i];
        #200 // wait
        sclk_pin = 1;
        #200 // wait
        sclk_pin = 0;
      end
      mosi_pin = 1;
      #200 // wait
      sclk_pin = 1;
      #200 // wait
      sclk_pin = 0;
      for (i = 0; i < 8; i = i + 1)
      begin
        readValue[i] = miso_pin;
        #200 // wait
        sclk_pin = 1;
        #200 // wait
        sclk_pin = 0;
      end
      $display("%b | %b", readValue, value);
      $stop;
    end
endmodule
