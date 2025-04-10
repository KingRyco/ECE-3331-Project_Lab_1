`timescale 1ns / 1ps
module top(
    input CLK100MHZ,
    input [15:0] sw,
    output wire [15:0] LED,
    input IPS_L, IPS_M, IPS_R,
    output wire IN1, IN2, IN3, IN4,
    input OCA, OCB,        // Active-high in comment, but we'll use active-low
    output ENA, ENB,
    output [6:0] seg,
    output [3:0] an
);

    reg [7:0] pwm_counter = 0;  // Unused
    reg [13:0] display = 14'd0180;
    wire [11:0] motor_duty_A_ips, motor_duty_B_ips;
    wire [11:0] motor_duty_A_oc, motor_duty_B_oc;
    wire [11:0] motor_duty_A, motor_duty_B;
    wire speed_A, speed_B;
    wire overcurrent_signal;
    reg reset = 0;

    IPS ips_module (
        .CLK100MHZ(CLK100MHZ),
        .IPS_L(IPS_L),
        .IPS_M(IPS_M),
        .IPS_R(IPS_R),
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .IN4(IN4),
        .motor_duty_A(motor_duty_A_ips),
        .motor_duty_B(motor_duty_B_ips),
        .LED(LED[2:0])
    );

    Overcurrent oc_module (
        .CLK100MHZ(CLK100MHZ),
        .OCA(OCA),
        .OCB(OCB),
        .ENA(ENA),              // Added
        .ENB(ENB),              // Added
        .overcurrent(overcurrent_signal)
    );

    assign motor_duty_A = overcurrent_signal ? motor_duty_A_oc : motor_duty_A_ips;
    assign motor_duty_B = overcurrent_signal ? motor_duty_B_oc : motor_duty_B_ips;

    pwm #(12,4095) motor_A_pwm(
        .CLK100MHZ(CLK100MHZ),
        .width(motor_duty_A),
        .pulse(speed_A)
    );

    pwm #(12,4095) motor_B_pwm(
        .CLK100MHZ(CLK100MHZ),
        .width(motor_duty_B),
        .pulse(speed_B)
    );

    sevenseg s1 (
        .CLK100MHZ(CLK100MHZ),
        .seg(seg),
        .an(an),
        .number(display),
        .overcurrent(overcurrent_signal),
        .IPS_L(IPS_L),
        .IPS_M(IPS_M),
        .IPS_R(IPS_R)
    );

    assign LED[15:6] = 10'b0;
    assign LED[3] = 1'b0;
endmodule
