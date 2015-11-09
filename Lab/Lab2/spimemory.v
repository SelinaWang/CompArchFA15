//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "inputconditioner.v"
`include "shiftregister.v"
`include "dff.v"
`include "addresslatch.v"
`include "datamemory.v"
`include "finitestatemachine.v"
module spimemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    input           fault_pin  // For fault injection testing
);
wire conditioned1;
wire conditioned2;
wire conditioned3;
wire positiveedge1;
wire posSCLK;
wire positveedge3;
wire negativeedge1;
wire negSCLK;
wire negativeedge3;
wire sr_we;
wire dm_we;
wire [7:0] dataOut;
wire addr_we;
wire miso_buff;
wire [7:0] parallelout;
wire serialout;
wire [7:0] datamem_address;
wire dff_q;
wire miso_bufe;


inputconditioner ic0(clk, mosi_pin, conditioned1, positiveedge1, negativeedge1);
inputconditioner ic1(clk, sclk_pin, conditioned2, posSCLK, negSCLK);
inputconditioner ic2(clk, cs_pin, conditioned3, positiveedge3, negativeedge3);
shiftregister sr0(clk, posSCLK, sr_we, dataOut, conditioned1, parallelout, serialout);
finitestatemachine fsm(posSCLK, conditioned3, parallelout[0], sr_we, dm_we, addr_we, miso_bufe);
addresslatch al(datamem_address, parallelout, addr_we, clk, fault_pin);
datamemory dm(clk, dataOut, datamem_address[1 +: 7], dm_we, parallelout);
dff df(dff_q, serialout, negSCLK, clk);

bufif1 misobuff (miso_pin, dff_q, miso_bufe);




endmodule
