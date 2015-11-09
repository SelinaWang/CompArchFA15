// 8-bit Address Latch with enable
//   Positive edge triggered
module addresslatch
(
output reg[7:0]		q,
input[7:0]		d,
input			ce,
input			clk
);
    initial begin
      q <= 0;
    end
    always @(posedge clk) begin
        if (ce) begin
            q <= d;
        end
    end

endmodule

// 8-bit Address Latch with enable and fault injection
//   Positive edge triggered
module addresslatch_breakable
(
output reg[7:0]		q,
input[7:0]		d,
input			ce,
input			clk,
input                   fault_pin
);
    initial begin
      q <= 0;
    end
    always @(posedge clk) begin
        if (ce) begin
            q <= d;
            if(fault_pin) begin
              q[7] <= 1;
            end
        end
    end

endmodule
