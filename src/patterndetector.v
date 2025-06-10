//-----------------------------------------------------------------------------
// Module: pattern_detector
// Description: A 4-bit programmable pattern detector using an FSM.
//              Detects a serial input stream matching a loaded pattern,
//              supporting overlapping matches and synchronous operation.
//-----------------------------------------------------------------------------

module pattern_detector (
    input  wire       clk,          
    input  wire       rst,          
    input  wire       data_in,      // Serial input data
    input  wire       input_valid,  // Validates input data
    input  wire [3:0] pattern,      // 4-bit pattern to detect
    input  wire       load_pattern, // Control signal to load new pattern
    output wire       match         // Asserts for one cycle on pattern match
);

//-----------------------------------------------------------------------------
// Parameters for FSM states
//-----------------------------------------------------------------------------

parameter [1:0] IDLE  = 2'b00; // Idle state, waiting for pattern load
parameter [1:0] SHIFT = 2'b01; // Shift state, collecting input bits
parameter [1:0] MATCH = 2'b10; // Match state, pattern detected

//-----------------------------------------------------------------------------
// Internal Registers
//----------------------------------------------------------------------------- 

reg [1:0] current_state;   // Current FSM state
reg [1:0] next_state;      // Next FSM state
reg [3:0] target_pattern;  // Stored pattern for comparison
reg [3:0] shifter;         // Shift register for input data
reg [2:0] bit_count;       // Tracks number of valid input bits
reg       match_reg;       // Registered match output for glitch-free operation

//-----------------------------------------------------------------------------
// Output Assignment
//-----------------------------------------------------------------------------

assign match = match_reg;  // Connect registered output to module port
assign match_reg = (current_state == MATCH); // Assert match in MATCH state

//-----------------------------------------------------------------------------
// Current State Logic
//-----------------------------------------------------------------------------

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        current_state   <= IDLE;
        shifter         <= 4'b0;
        target_pattern  <= 4'b0;
        bit_count       <= 3'd0;
    end else begin
        current_state <= next_state;

        // Load new pattern when requested
        if (load_pattern)
            target_pattern <= pattern;

        // Update shifter only when input_valid is high
        if (input_valid && (current_state == SHIFT || current_state == MATCH)) begin
            shifter <= {data_in, shifter[3:1]};
            if (bit_count < 4)
                bit_count <= bit_count + 1;
        end else begin
            bit_count <= 3'd0; // Reset bit counter when no valid input
        end
    end
end

//-----------------------------------------------------------------------------
// Next State Logic 
//-----------------------------------------------------------------------------

always @(*) begin
    next_state = current_state; // Default: stay in current state

    case (current_state)
        IDLE: begin
            next_state = load_pattern ? SHIFT : IDLE; // Start shifting on pattern load
        end

        SHIFT: begin
            if (input_valid) begin
                // Check for pattern match after 4 valid bits
                if ((bit_count >= 4) &&
                    (shifter[3:1] == target_pattern[2:0]) &&
                    (data_in == target_pattern[3]))
                    next_state = MATCH;
                else
                    next_state = SHIFT;
            end
        end

        MATCH: begin
            next_state = SHIFT; // Return to SHIFT for overlapping matches
        end

        default: next_state = IDLE; // Safe default state
    endcase
end

endmodule
