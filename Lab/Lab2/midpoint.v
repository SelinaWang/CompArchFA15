`include "inputconditioner.v"
`include "shiftregister.v"


module midpointblock
#(parameter paralellinput = 8'hA5)
(
    input button0,
    input switch0,
    input switch1,
    input clk,
    output reg[7:0] parallelOut
);

    wire conditionedbutton0, risingbutton0, fallingbutton0;
    inputconditioner button0conditioner(clk, button0, conditionedbutton0, risingbutton0, fallingbutton0);

    wire conditionedswitch0, risingswitch0, fallingswitch0;
    inputconditioner switch0conditioner(clk, switch0, conditionedswitch0, risingswitch0, fallingswitch0);

    wire conditionedswitch1, risingswitch1, fallingswitch1;
    inputconditioner switch1conditioner(clk, switch1, conditionedswitch1, risingswitch1, fallingswitch1);

    wire serialOut;
    shiftregister #(8) shifty(clk, risingswitch1, fallingbutton0, paralellinput, conditionedswitch0, parallelOut, serialOut);

endmodule
