`timescale 1ns / 1ps

module Overcurrent (
    input CLK100MHZ,        // 100 MHz clock
    input OCA,              // Right motor overcurrent sense pin, active-high
    input OCB,              // Left motor overcurrent sense pin, active-high
    output reg ENA = 1,
    output reg ENB = 1,
    output reg overcurrent = 0
    
);

  

    // Internal registers
    reg oc_test;
    reg [24:0] oc_delay;

    // Synchronous logic
    initial begin
        oc_delay = 0;
        oc_test = 0;
    end
    
    always @(posedge CLK100MHZ) begin
        if(~OCA || ~OCB) begin
            oc_test = 1;
        end
        
        if(oc_test)begin
            oc_delay = oc_delay + 1;
            if(oc_delay == 0) begin
                if(~OCA || ~OCB) begin
                    ENA = 0; ENB = 0; overcurrent = 1;
                end else begin
                    oc_test = 0;
                end
            end
        end
    end

endmodule