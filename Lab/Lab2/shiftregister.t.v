//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`include "shiftregister.v"
module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    
    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut));
    
// Generate clock (50MHz)
    initial clk=1;
    always #10 clk=!clk;    // 50MHz Clock    

    initial begin
    
        parallelDataIn = 8'b10101010;
        parallelLoad = 1;
        #40 // full cycle to wait
        parallelLoad = 0;
        $display("%b | %b", serialDataOut, parallelDataOut);
    	if(serialDataOut != 1) begin
            $display("Test Case 1 Failed. Data load did not work");
        end
        serialDataIn = 1;
        peripheralClkEdge = 1;
        #20
        peripheralClkEdge = 0;
        #20
        $display("%b | %b", serialDataOut, parallelDataOut);
        if(serialDataOut != 0) begin
            $display("Test Case 2 Failed. Paralell load always active or shift didn't work.");
        end
        peripheralClkEdge = 1;
        #20
        peripheralClkEdge = 0;
        #20
        $display("%b | %b", serialDataOut, parallelDataOut);
        if(serialDataOut != 1 || parallelDataOut != 8'b10101011) begin
            $display("Test Case 3 Failed. Paralell load always active or shift didn't insert correctly, or parallel is bad.");
        end
        #40 //check for wait
        $display("%b | %b", serialDataOut, parallelDataOut);
        if(serialDataOut != 1 || parallelDataOut != 8'b10101011) begin
            $display("Test Case 4 Failed. Shift register not properly holding state.");
        end
        $display("Done");
        $stop;
    end

endmodule
