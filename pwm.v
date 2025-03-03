/*
-------------------------------------------------------
Pulse Width Modulation Module
-------------------------------------------------------
Creates a pwm signal with a given period and duty cycle. Based on the 10 ns clk
of the Basys board, will generate a signal that counts by 10 ns.

*/
module pwm #(parameter SIZE = 12, PERIOD = 4095)
(input CLK100MHZ,     // Clock signal at 100 MHz, used to generate PWM frequency
 input [SIZE-1:0] width, // Input for duty cycle width, determines how long the pulse is 'high'
 output reg pulse);  // Output PWM signal

    reg [SIZE-1:0] counter; // Counter to keep track of the PWM cycle

    // Initialize counter and pulse to zero
    initial begin
        counter = 0;    // Start the counter at zero
        pulse = 0;      // Start with the pulse low
    end

    // PWM generation logic
    always @(posedge CLK100MHZ) begin
        // Increment counter, reset if it reaches the period
        if (counter < PERIOD - 1)  // Use PERIOD - 1 for inclusive counting up to PERIOD - 1
            counter <= counter + 1; // Increment counter
        else
            counter <= 0;           // Reset counter to start a new cycle
        
        // Set pulse high if counter is less than the width, low otherwise
        pulse <= (counter < width) ? 1'b1 : 1'b0; // If counter is less than width, pulse is high, else low
    end

endmodule