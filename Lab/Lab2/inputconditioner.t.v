//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
<<<<<<< HEAD
`include "inputconditioner.v"
=======

`include 
"inputconditioner.v"
>>>>>>> origin/master
module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    integer i;
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));

	
    // Generate clock (50MHz)
    initial clk=1;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)


        //Synchronize: 5 seconds delay
	pin = 1;
	for ( i = 0; i < 5; i = i + 1) begin
                #20 // must wait for at least 1 clock cycle
                $display("%b | 0", conditioned);
		if(conditioned == 1 || (rising || falling)) begin
			$display("Synchronize Failed: Conditioned output high before full delay is passed.");
		end
	end

        #10 // we are now 5.5 cycles though our clock, we should now be high.

        $display("%b | 1", conditioned);
        if(conditioned != 1 && (rising && !falling)) begin
	    $display("Synchronize Failed: No rising edge or failure to properly set conditioned output.");
	end

        $display("Synchronize tests complete");

        #30 // wait for stablization.

        //Clean: Bounce up to 5 clock cycles - remain the same
	pin = 1;
	for ( i = 0; i < 5; i = i + 1) begin 
                #20 // must wait for at least 1 clock cycle
		pin = i%2;
                $display("%b | 1", conditioned);
		if(rising || falling)begin
			$display("Clean Failed: Edge detection from bouncing");
		end
	end

        $display("Clean test complete");

        //Preprocess: when edge should change we detect both edges

	pin = 0;
        #120 // must wait for at least 5 clock cycles + 1 for the pulse

	if ((clk == 4) && (!rising && !falling)) begin
		$display("Preprocess Failed: No edge detection when expected");
	end

        $display("Preprocess test complete");

        #20 // just for us so we can see the pulse.

        if (rising || falling) begin
            $display("Test failure: Edge not cleared in time");
        end

    $stop;
    end

endmodule
