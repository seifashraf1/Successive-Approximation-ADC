`timescale 1ns/1ns

module SAR_Controller (
    input clk,
    input go,
    input cmp,
    output valid,
    output reg sample,
    output reg [7:0] result,
    output [7:0] value,
);

parameter sWait = 2'b00;
parameter sSample = 2'b01;
parameter sConv = 2'b10;
parameter sDone = 2'b11;


reg [1:0] state; 
reg [1:0] nextState;
reg [7:0] mask; 
reg [7:0] result; 


always @(posedge clk) begin
    if (!go) state <= sWait;
    else state <= nextState;

    if (go) begin
        if (state == sConv) begin
            if (cmp) result <= result | mask;
            mask <= mask >> 1;
        end else if (currentState != sDone) 
            mask <= 8'b1000_0000;
    end
    
end


always @(currentState or go or mask) begin
    if (!go) begin 
        state <= sWait;
        valid <= 0;
        sample <= 0;
    end

    case(state) 
        sWait: begin
            if (go) nextState <= sSample;
            sample <= 0;
        end 

        sSample: begin
            if (go) nextState <= sConv;
            else nextState <= sWait;
            result <= 0;
            sample <= 1;
        end

        sConv: begin 
            sample <= 0;
            if (mask[0]) nextState <= sDone;
        end

        sDone: begin
            sample <= 0;
            if (!go) nextState <= sWait;
            valid <= 1;
        end
    
    endcase

end



endmodule




