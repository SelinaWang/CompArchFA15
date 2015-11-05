// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module dff
(
output reg	q,
input		d,
input		ce,
input		clk
);

    always @(posedge clk) begin
        if (ce) begin
            q = d;
        end
    end

endmodule
