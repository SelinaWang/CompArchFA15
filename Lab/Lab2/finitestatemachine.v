//------------------------------------------------------------------------
// FSM for SPI Memory
//------------------------------------------------------------------------

module finitestatemachine
(
input               sclk,                // SLA Clock
input               cs_pin,             // Chip Select pin
input               shiftregisterlsb,       // Least Signifigant Bit
output reg          sr_we,     // Shift register write enable
output reg          dm_we,       // Data Memory Write Enable
output reg          a_le,    // Address latch enable
output reg          miso_e       // MISO enable
);
    reg[3:0] counter;
    reg[3:0] state;
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
            sr_we <= 0;
            dm_we <= 0;
            a_le <= 1;
            miso_e <= 0;
            counter <= counter + 1;
            if (counter == 7) begin
              state <= 1;
            end
          end
          1: begin
            sr_we <= 0;
            dm_we <= 0;
            miso_e <= 0;
            counter <= 0;
            a_le <= 0;
            if(shiftregisterlsb) begin
              state <= 2;
            end
            else begin
              state <= 5;
            end
          end
          2: begin
            sr_we <= 0;
            dm_we <= 0;
            a_le <= 0;
            miso_e <= 0;
            state <= 3;
          end
          3: begin
            dm_we <= 0;
            a_le <= 0;
            miso_e <= 0;
            sr_we <= 1;
            state <= 4;
          end
          4: begin
            sr_we <= 0;
            dm_we <= 0;
            a_le <= 0;
            miso_e <= 1;
            counter <= counter + 1;
            if (counter == 7) begin
              state <= 7;
            end
          end
          5: begin
            sr_we <= 0;
            dm_we <= 1;
            a_le <= 0;
            miso_e <= 0;
            counter <= counter + 1;
            if (counter == 7) begin
              state <= 7;
            end
          end
          7: begin
            sr_we <= 0;
            dm_we <= 0;
            a_le <= 0;
            miso_e <= 0;
            counter <= 0;
          end
        endcase
      end
    end
endmodule
