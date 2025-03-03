`timescale 1ns / 1ps

module Overcurrent_tb;

    // Testbench signals
    reg CLK100MHZ;          // 100 MHz clock
    reg OCA;                // Right motor overcurrent sense pin
    reg OCB;                // Left motor overcurrent sense pin
    wire ENA;               // Right motor enable
    wire ENB;               // Left motor enable
    wire overcurrent;       // Overcurrent flag
    wire [2:0] LED;         // 3-bit LED output

    // Instantiate the Overcurrent module
    Overcurrent uut (
        .CLK100MHZ(CLK100MHZ),
        .OCA(OCA),
        .OCB(OCB),
        .ENA(ENA),
        .ENB(ENB),
        .overcurrent(overcurrent),
        .LED(LED)
    );

    // Clock generation: 100 MHz (10 ns period)
    initial begin
        CLK100MHZ = 0;
        forever #5 CLK100MHZ = ~CLK100MHZ;  // Toggle every 5 ns
    end

    // Test stimulus: Toggle OCA and OCB every 200 ns
    initial begin
        // Initialize inputs
        OCA = 0;
        OCB = 0;
        // Run for a few cycles of toggling
        forever #200 begin
            OCA = ~OCA;  // Toggle OCA every 200 ns
            OCB = ~OCB;  // Toggle OCB every 200 ns
        end
    end

    // End simulation after some time
    initial begin
        #2000;  // Run for 2000 ns (10 toggle cycles)
        
    end

    // Monitor outputs for continuous observation
    initial begin
        
    end

endmodule
