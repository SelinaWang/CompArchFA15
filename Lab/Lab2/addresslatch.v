// 8-bit Address Latch with enable
//   Positive edge triggered
module addresslatch
(
output reg[7:0]		q,
input[7:0]		d,
input			ce,
input			clk
);

    always @(posedge clk) begin
        if (ce) begin
            q = d;
        end
    end

endmodule
