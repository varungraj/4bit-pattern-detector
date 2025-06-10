//------------------------------------------------------------------------------
// Testbench: pattern_detector_tb
// Purpose:   To verify functionality of the pattern_detector module
// Type:      Linear
//------------------------------------------------------------------------------

module pattern_detector_tb;

    reg         clk;
    reg         rst;
    reg         data_in;
    reg         input_valid;
    reg [3:0]   pattern;
    reg         load_pattern;
    wire        match;

    // DUT Instance
    pattern_detector uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .input_valid(input_valid),
        .pattern(pattern),
        .load_pattern(load_pattern),
        .match(match)
    );

    // Initialization
    initial begin
        clk = 0;
        rst = 0;
        input_valid = 0;
        load_pattern = 0;
    end

    // Clock Generation
    initial begin
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        
        #10 rst = 1'b1;  // Release reset

        //--------------------------------------------------
        // Load pattern = 4'b1010
        //--------------------------------------------------
        #10 load_pattern = 1'b1;
            pattern = 4'b1010;
        #10 load_pattern = 1'b0;

        //--------------------------------------------------
        // Send input stream: 1 0 1 0 1 0 
        // To ensure it compares after valid first 4-bits
        //--------------------------------------------------
            input_valid = 1'b1;

            data_in = 1; 
        #10 data_in = 0; 
        #10 data_in = 1; 
        #10 data_in = 0;
        #10 data_in = 1; 
        #10 data_in = 0; 

        #10 input_valid = 1'b0;

        //--------------------------------------------------
        // Change pattern to 4'b1000
        //--------------------------------------------------
        #20 load_pattern = 1'b1;
            pattern = 4'b1000;
        #10 load_pattern = 1'b0;

        //--------------------------------------------------
        // Send input stream: 1 0 0 0 1 0 0 0 0 1 1
        // overlapping condition
        //--------------------------------------------------
            input_valid = 1'b1;

            data_in = 1; 
        #10 data_in = 0; 
        #10 data_in = 0; 
        #10 data_in = 0; 
        #10 data_in = 1;  

        #10 data_in = 0; 
        #10 data_in = 0; 
        #10 data_in = 0; 
        #10 data_in = 0; 
        #10 data_in = 1;
        #10 data_in = 1;  

        #10 input_valid = 1'b0;

        //--------------------------------------------------
        // Change pattern to 4'b1110
        //--------------------------------------------------
        #20 load_pattern = 1'b1;
            pattern = 4'b1110;
        #10 load_pattern = 1'b0;

        //--------------------------------------------------
        // Send input stream: 1
        // Should NOT match since only one bit received
        //--------------------------------------------------
            input_valid = 1'b1;

            data_in = 1;  

        #10 input_valid = 1'b0;

        //--------------------------------------------------
        // Pattern Load Mid-Stream 
        // Should detect any match further with the stream
        //--------------------------------------------------
        #20 input_valid = 1'b1;

        #10 data_in = 1; 
        #10 data_in = 0; 

        #10 load_pattern = 1'b1; 
            pattern = 4'b1100; 
        #10 load_pattern = 1'b0;

            data_in = 1; 
        #10 data_in = 1;  // New pattern = 1100

        #10 input_valid = 1'b0;

        #10 rst = 1'b0;   //Apply reset
    end

    initial begin
       $shm_open("wave.shm");
       $shm_probe("ACTMF");
       #500; 
       $finish;
    end

endmodule
