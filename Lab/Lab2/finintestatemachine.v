//------------------------------------------------------------------------
// FSM for SPI Memory
//------------------------------------------------------------------------

module finitestatemachine
#(parameter width = 8)
(
input               sclk,                // SLA Clock
input               cs_pin,             // Chip Select pin
input               shiftregisterlsb,       // Least Signifigant Bit
output reg          sr_we,     // Shift register write enable
output reg          dm_we,       // Data Memory Write Enable
output reg          a_le,    // Address latch enable
output reg          miso_e       // MISO enable
);
    reg counter;
    reg state;
    always @(posedge sclk) begin
      if (cs_pin) begin
        counter <= 0;
        state <= 0;
        sr_we <= 0;
        dm_we <= 0;
        a_le <= 0;
        miso_e <= 0;
      end
      else begin
        case(state)
          0: begin
            counter <= counter + 1;
            if (counter == 8) begin
              state <= 1;
            end
          end
          1: begin
            a_le <= 1;
            counter <= 0;
            if(shiftregisterlsb) begin
              state <= 2;
            end
            else begin
              state <= 5;
            end
          end
          2: begin
            a_le <= 0;
            state <= 3;
          end
          3: begin
            sr_we <= 1;
            state <= 4;
          end
          4: begin
            sr_we <= 0;
            miso_e <= 1;
            counter <= counter + 1;
            if (counter == 8) begin
              state <= 7;
            end
          end
          5: begin
            a_le <= 0;
            counter <= counter + 1;
            if (counter == 8) begin
              state <= 6;
            end
          end
          6: begin
            counter <= 0;
            dm_we <= 1;
            state <= 7;
          end
          7: begin
            dm_we <= 0;
            miso_e <= 0;
            counter <= 0;
          end
        endcase
      end
    end
endmodule