`timescale 1ns / 1ps

module IPS(
    input CLK100MHZ,                 // Clock signal at 100 MHz for synchronization
    input wire IPS_L, IPS_M, IPS_R,  // Infrared Proximity Sensor inputs for Left, Middle, and Right
    output reg IN1 = 1'b0,           // Initialize to 0
    output reg IN2 = 1'b0,           // Initialize to 0
    output reg IN3 = 1'b0,           // Initialize to 0
    output reg IN4 = 1'b0,           // Initialize to 0
    output reg [11:0] motor_duty_A = 12'b0,  // 12-bit duty cycle for motor A for speed control
    output reg [11:0] motor_duty_B = 12'b0,  // 12-bit duty cycle for motor B for speed control
    output reg [2:0] LED             // LED outputs to indicate sensor status, now defined as a 3-bit bus
);

    always @(posedge CLK100MHZ) begin
        // Normal operation directly from sensor input
        case({~IPS_L, ~IPS_M, ~IPS_R}) // Inverted inputs for IPS sensors due to how they are wired 
            3'b000: //example case of using then in a case the first digit is left, middle is second, and third is right
            begin
                IN1 = 0; IN3 = 0; // Stop
                IN2 = 0; IN4 = 0;
                motor_duty_A <= 12'd0;  
                motor_duty_B <= 12'd0;  
            end
            3'b111: 
            begin
                IN1 = 0; IN3 = 1; //IN3 and IN2 are the forward commands for each motors so they are set to 1
                IN2 = 1; IN4 = 0;
                motor_duty_A <= 12'd2048;  //speed at which each motor should run so this is speed for A side
                motor_duty_B <= 12'd2048;  //same thing but B side
            end
            3'b010: 
            begin
                IN1 = 0; IN3 = 1; // Forward
                IN2 = 1; IN4 = 0;
                motor_duty_A <= 12'd2048;  
                motor_duty_B <= 12'd2048;  
            end
            3'b100: 
            begin
                IN1 = 0; IN3 = 0; // left
                IN2 = 1; IN4 = 1; //Setting IN1 or IN4 to 1 gives you a reverse on their respective treads
                motor_duty_A <= 12'd2048;  
                motor_duty_B <= 12'd2048;  
            end
            3'b001: 
            begin
                IN1 = 1; IN3 = 1; // Right
                IN2 = 0; IN4 = 0;
                motor_duty_A <= 12'd2048;  
                motor_duty_B <= 12'd2048;  
            end
            
        endcase
        
        
        // Debug IPS sensors using the on board LEDs to make sure that they are detecting or are plugged in properly
        LED[3] <= ~IPS_L;  // Left sensor reading controls LED[0]
        LED[4] <= ~IPS_M;  // Middle sensor reading controls LED[1]
        LED[5] <= ~IPS_R;  // Right sensor reading controls LED[2]
    end

endmodule
