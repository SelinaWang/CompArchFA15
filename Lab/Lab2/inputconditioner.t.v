//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------

`include 
"inputconditioner.v"
module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    reg dutpassed = 0;
    integer i = 0;
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));

	
    // Generate clock (50MHz)
    initial clk=0;
    initial dutpassed = 0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronize, Clean, Preprocess (edge finding)


 //Synchronize: 5 seconds delay
	pin = 1;
	for(clk=0; clk<4; clk=clk+1) begin
		if(rising || falling)begin
			dutpassed = 0;
			$display("Synchronize Failed: Edge detection before expected delay");
		end
	end
	

//Clean: Bounce up to 5 clock cycles - remain the same
	pin = 1;
	
	for(i=0; i<5; i = i +1)begin 
		clk = i;
		pin = i%2;
		if(rising || falling)begin
			dutpassed = 0;
			$display("Clean Failed: Edge detection from bouncing");
		end
	end
	
		
		
		

//Preprocess: when edge should change we detect both edges
	pin = 1;

	for(clk=0; clk<5; clk=clk+1) begin
		if((clk==4)&&(!rising&&!falling))begin
			dutpassed = 0;
			$display("Preprocess Failed: No edge detection when expected");
		end

	end
	end

endmodule
