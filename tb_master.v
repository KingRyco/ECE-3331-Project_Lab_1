`timescale 1ns / 1ps

module tb_master;

    // Testbench signals
    reg CLK100MHZ;                // 100 MHz clock
    reg [15:0] sw;                // 16-bit switches (unused but kept for compatibility)
    reg OCA, OCB;                 // Overcurrent sensor inputs (active-high)
    wire [15:0] LED;              // LED outputs
    wire IN1, IN2, IN3, IN4;      // Motor control 
    wire IPS_L, IPS_M, IPS_R;
    wire ENA, ENB;                // Motor enable signals
    wire [6:0] seg;               // 7-segment display segments
    wire [3:0] an;                // 7-segment display anodes

    // Instantiate the top module
    top uut (
        .CLK100MHZ(CLK100MHZ),
        .sw(sw),
        .LED(LED),
        .IPS_L(1'b1),               // Hardwired to inactive (1) since IPS is removed
        .IPS_M(1'b1),               // Hardwired to inactive (1)
        .IPS_R(1'b1),               // Hardwired to inactive (1)
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .IN4(IN4),
        .OCA(OCA),
        .OCB(OCB),
        .ENA(ENA),
        .ENB(ENB),
        .seg(seg),
        .an(an)
    );

   

    // Stimulus process
    initial begin
        // Initialize inputs
        sw = 16'b0;                 // Switches unused but initialized
        OCA = 0; OCB = 0;           // No overcurrent initially
        IPS_L = 1;

        // Open VCD file for waveform viewing
        $dumpfile("tb_master.vcd");
        $dumpvars(0, tb_master);

        // Test all combinations of OCA and OCB to observe ENA and ENB behavior
        // State 1: OCA = 0, OCB = 0 (No overcurrent, both motors enabled)
        OCA = 1; OCB = 0;
        #20;  // Wait to observe ENA and ENB should be 1

        $finish;
    end

endmodule