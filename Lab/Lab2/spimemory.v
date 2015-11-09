//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    input           fault_pin,  // For fault injection testing
)
wire conditioned1;
wire conditioned2;
wire conditioned3;
wire positiveedge1;
wire positiveedge2;
wire positveedge3;
wire negativeedge1;
wire negativeedge2;
wire negativeedge3;
wire sr_we;
wire dm_we;
wire [7:0] dout;
wire addr_we;
wire miso_buff;
wire [7:0] parallelout;
wire serialout;
wire [6:0] datamem_address;
wire dff_q;
wire miso_bufe


inputconditioner(clk, mosi_pin, conditioned1, positiveedge1, negativeedge1);
inputconditioner(clk, sclk_pin, conditioned2, positiveedge2, negativeedge2);
inputconditioner(clk, cs_pin, conditioned3, positiveedge3, negativeedge3);
shiftregister(clk, positiveedge2, sr_we, dout, conditioned1, parallelout, serialout);
finitestatemachine(positiveedge2, conditioned3, parallelout[0], sr_we, dm_we, addr_we, miso_bufe);
datamemory(clk, dout, datamem_address, dm_we, parallelout);
addresslatch(datamem_address, parallelout, addr_we, clk);
dff(dff_q, serialout, negativeedge2, clk);

bufif1 misobuff (miso_pin, dff_q, miso_bufe);




endmodule
