`timescale 1ns/1ns

module SAR_Controller (
    input clk,
    input go,
    input cmp,
    output reg valid,
    output reg sample,
    output reg [7:0] result,
    output [7:0] value
);

parameter sWait = 2'b00;
parameter sSample = 2'b01;
parameter sConv = 2'b10;
parameter sDone = 2'b11;


reg [1:0] currentState; 
reg [7:0] mask; 

always @(posedge clk) begin
    if (!go) begin 
        currentState <= sWait;
        valid = 0;
        sample = 0;
    end
    
    case(currentState) 
        sWait: begin
            if (go) currentState <= sSample;
            else if (!go) currentState <= sWait;
            sample <= 0;
        end 

        sSample: begin
            if (go) begin 
                currentState <= sConv;
                mask <= 8'b10000000;
                result <= 0;
                sample <= 1;
            end
            
            if (!go) currentState <= sWait;
        end

        sConv: begin 
            sample <= 0;
            if (mask[0]) currentState <= sDone;
            if (!go) currentState <= sWait;
            if (cmp) result <= result | mask;
            mask <= mask >> 1;
        end

        sDone: begin
            sample <= 0;
            valid <= 1;
            if (!go) currentState <= sWait;
            
        end
    
    endcase

end

    assign value = result | mask;

endmodule




