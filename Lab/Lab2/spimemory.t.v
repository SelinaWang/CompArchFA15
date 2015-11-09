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
    initial sclk_pin=0;
    reg[7:0] address;
    reg[7:0] value;
    reg[7:0] readValue;
    integer i;
    integer j;
    always #10 clk=!clk;    // 50MHz Clock
    always #80 sclk_pin=!sclk_pin;
    initial begin
      mosi_pin = 0;
      sclk_pin = 0;
      cs_pin = 1;
      fault_pin = 0; // !!!Change this to 1 if testing Fault Injection!!!
      #160;
      for (j = 0; j < 128; j = j + 1) begin
        address = j;
        value = j;
        #160;
        cs_pin = 0;
        for (i = 1; i <= 7; i = i + 1)
        begin
          mosi_pin = address[7-i];
          #160;
        end
        mosi_pin = 0;
        #160;
        for (i = 1; i <= 8; i = i + 1)
        begin
          mosi_pin = value[8-i];
          #160;
        end
        cs_pin = 1;
        #160;
      end

      for (j = 0; j < 128; j = j + 1) begin
        address = j;
        readValue = 8'b00000000;
        cs_pin = 0;
        for (i = 1; i <= 7; i = i + 1)
        begin
          mosi_pin = address[7-i];
          #160;
        end
        mosi_pin = 1;
        #880; //You must wait at least 5 cycles (2 sync cycles and 3 clean cycles for input reg) plus a half cycle to read on the low.
        for (i = 1; i <= 8; i = i + 1)
        begin
          readValue[8-i] = miso_pin;
          #160;
        end
        #80; // get yourself back on track
        if (readValue != j) begin
	  $display("fault at mem address %b expected that value got %b", j[7:0], readValue);
	end
        cs_pin = 1;
        #160;
      end
      
      address =   7'b1011010;
      value =     8'b11011011;
      readValue = 8'b00000000;
      #160;
      cs_pin = 0;
      for (i = 1; i <= 7; i = i + 1)
      begin
        mosi_pin = address[7-i];
        #160;
      end
      mosi_pin = 0;
      #160;
      for (i = 1; i <= 8; i = i + 1)
      begin
        mosi_pin = value[8-i];
        #160;
      end
      cs_pin = 1;
      #160;
      #160; // additional wait
      cs_pin = 0;
      for (i = 1; i <= 7; i = i + 1)
      begin
        mosi_pin = address[7-i];
        #160;
      end
      mosi_pin = 1;
      #880; //You must wait at least 5 cycles (2 sync cycles and 3 clean cycles for input reg) plus a half cycle to read on the low.
      for (i = 1; i <= 8; i = i + 1)
      begin
        readValue[8-i] = miso_pin;
        #160;
      end
      #80; // get yourself back on track
      $display("Test 1: %b | b11011011", readValue);
      cs_pin = 1;
      // test 2: add some more data and check persistance.
      address =   7'b0010110;
      value =     8'b01010101;
      readValue = 8'b00000000;
      #160;
      cs_pin = 0;
      for (i = 1; i <= 7; i = i + 1)
      begin
        mosi_pin = address[7-i];
        #160;
      end
      mosi_pin = 0;
      #160;
      for (i = 1; i <= 8; i = i + 1)
      begin
        mosi_pin = value[8-i];
        #160;
      end
      cs_pin = 1;
      #160;
      #160; // additional wait
      address =   7'b1011010;
      cs_pin = 0;
      for (i = 1; i <= 7; i = i + 1)
      begin
        mosi_pin = address[7-i];
        #160;
      end
      mosi_pin = 1;
      #880; //You must wait at least 5 cycles (2 sync cycles and 3 clean cycles for input reg) plus a half cycle to read on the low.
      for (i = 1; i <= 8; i = i + 1)
      begin
        readValue[8-i] = miso_pin;
        #160;
      end
      #80; // get yourself back on track
      $display("Test 2: %b | b11011011", readValue);
      cs_pin = 1;
      #160; // additional wait
      address =   7'b0010110;
      cs_pin = 0;
      for (i = 1; i <= 7; i = i + 1)
      begin
        mosi_pin = address[7-i];
        #160;
      end
      mosi_pin = 1;
      #880; //You must wait at least 5 cycles (2 sync cycles and 3 clean cycles for input reg) plus a half cycle to read on the low.
      for (i = 1; i <= 8; i = i + 1)
      begin
        readValue[8-i] = miso_pin;
        #160;
      end
      #80; // get yourself back on track
      $display("Test 3: %b | b01010101", readValue);
      // test 4 for fault injection case
      cs_pin = 1;
      #160; // additional wait
      address =   7'b1010110;
      cs_pin = 0;
      for (i = 1; i <= 7; i = i + 1)
      begin
        mosi_pin = address[7-i];
        #160;
      end
      mosi_pin = 1;
      #880; //You must wait at least 5 cycles (2 sync cycles and 3 clean cycles for input reg) plus a half cycle to read on the low.
      for (i = 1; i <= 8; i = i + 1)
      begin
        readValue[8-i] = miso_pin;
        #160;
      end
      #80; // get yourself back on track
      if(readValue == 8'b01010101) begin
	$display("fault! most signifigant address bit is stuck at 1");
      end
      $display("Test 4: %b != b01010101, if it does, fault.", readValue);
      $stop;
    end
endmodule
