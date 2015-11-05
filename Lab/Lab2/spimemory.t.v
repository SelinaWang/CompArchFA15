//------------------------------------------------------------------------
// SPI Memory test bench
//------------------------------------------------------------------------
`include "spimemory.v"
module testspimemory();

    reg           clk,        // FPGA clock
    reg           sclk_pin,   // SPI clock
    reg           cs_pin,     // SPI chip select
    wire          miso_pin,   // SPI master in slave out
    reg           mosi_pin,   // SPI master out slave in
    reg           fault_pin,  // For fault injection testing
    wire [3:0]    leds        // LEDs for debugging
    
    // Instantiate with parameter width = 8
    spimemory #(8) 	dut(.clk(clk), 
    		           .sclk_pin(sclk_pin),
    		           .cs_pin(cs_pin), 
    		           .miso_pin(miso_pin), 
    		           .mosi_pin(mosi_pin), 
    		           .fault_pin(fault_pin), 
    		           .leds(leds));
    
// Generate clock (50MHz)
    initial clk=1;
    always #10 clk=!clk;    // 50MHz Clock    

    initial begin
    
        parallelDataIn = 8'b10101010;
        parallelLoad = 1;
        #40 // full cycle to wait
        parallelLoad = 0;
        $display("%b %b | 1 10101010", serialDataOut, parallelDataOut);
    	if(serialDataOut != 1) begin
            $display("Test Case 1 Failed. Data load did not work");
        end
        serialDataIn = 1;
        peripheralClkEdge = 1;
        #20
        peripheralClkEdge = 0;
        #20
        $display("%b %b | 0 01010101", serialDataOut, parallelDataOut);
        if(serialDataOut != 0) begin
            $display("Test Case 2 Failed. Paralell load always active or shift didn't work.");
        end
        peripheralClkEdge = 1;
        #20
        peripheralClkEdge = 0;
        #20
        $display("%b %b | 1 10101011", serialDataOut, parallelDataOut);
        if(serialDataOut != 1 || parallelDataOut != 8'b10101011) begin
            $display("Test Case 3 Failed. Paralell load always active or shift didn't insert correctly, or parallel is bad.");
        end
        #40 //check for wait
        $display("%b %b | 1 10101011", serialDataOut, parallelDataOut);
        if(serialDataOut != 1 || parallelDataOut != 8'b10101011) begin
            $display("Test Case 4 Failed. Shift register not properly holding state.");
        end
        serialDataIn = 0;
        peripheralClkEdge = 1;
        #20
        peripheralClkEdge = 0;
        #20
        $display("%b %b | 0 01010110", serialDataOut, parallelDataOut);
        if(serialDataOut != 0 || parallelDataOut != 8'b01010110) begin
            $display("Test Case 5 Failed. Shift of a 0 in doesn't work.");
        end
        $display("Done");
        $stop;
    end

endmodule