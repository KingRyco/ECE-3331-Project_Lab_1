`timescale 1ns / 1ps

module sevenseg(
    input CLK100MHZ,                // Clock signal at 100 MHz for synchronization
    output reg [6:0] seg,           // 7-segment display segments
    output reg [3:0] an,            // Anode control for 4-digit multiplexing
    input [13:0] number,            // Input for numbers to display (unused in this implementation)
    input overcurrent,              // Flag to indicate overcurrent condition
    input IPS_L, IPS_M, IPS_R       // Infrared Proximity Sensor inputs for Left, Middle, and Right
);

    reg [18:0] counter = 0;         // Counter for multiplexing the display digits
    reg [3:0] digit = 0;            // Register to hold current digit or character to display
    wire [1:0] refresh;             // Two bits for selecting which digit to display

    // Initialization
    initial begin
        seg = 7'b1111111;           // Initially set segments to blank
        an = 4'b1111;               // All digits initially off
    end

    assign refresh = counter[18:17]; // Using the two most significant bits for refresh control

    always @(posedge CLK100MHZ) begin
        counter <= counter + 1;     // Increment counter for timing the display refresh

        // Multiplexing logic for all digits
        case(refresh)
            2'b00: begin // using only 2 bits in binary for each of the four cases for the digits. 
                an = 4'b0111;  // First digit (leftmost)
                digit = ~IPS_L ? 4'h1 : (overcurrent ? 4'h6 : 4'hF);  // 'L' if IPS_L, 'E' if overcurrent, otherwise blank
            end
            2'b01: begin
                an = 4'b1011;  // Second digit
                digit = ~IPS_M ? 4'h2 : (overcurrent ? 4'h6 : 4'hF);  // 'C' if IPS_M, '6' if overcurrent, otherwise blank
            end
            2'b10: begin
                an = 4'b1101;  // Third digit
                digit = ~IPS_R ? 4'h3 : (overcurrent ? 4'h6 : 4'hF);  // 'A' if IPS_R, '6' if overcurrent, otherwise blank
            end
            2'b11: begin
                an = 4'b1110;  // Fourth digit (rightmost)
                digit = overcurrent ? 4'h6 : 4'hF;  // '6' if overcurrent, otherwise blank
            end
        endcase
    end
    
    // 7-segment display decoder including letters, this allows our case to know what to send to the display
    // order of bits is GFEDCBA for the display segments 
    always @(*) begin
        case(digit)
            4'h6: seg = 7'b0000110;  // E
            4'h2: seg = 7'b1000110;  // C for Middle sensor
            4'h3: seg = 7'b0001000;  // A for Right sensor
            4'h1: seg = 7'b1000111;  // L for Left sensor
            4'hF: seg = 7'b1111111;  // Blank (all segments off)
            default: seg = 7'b1111111; // Default to blank if digit not recognized
        endcase
    end

endmodule
