`timescale 1ns/1ns

module SAR_Controller_tb();
// registers to hold inputs to circuit under test, wires for outputs 
reg clk,go;
wire valid,sample,cmp;
wire [7:0] result; 
wire [7:0] value; 

// instance controller 
SAR_Controller c(clk,go,cmp,valid, sample,result,value); 

// generate a clock with period of 20 time units 
always begin 
	#10; clk=~clk; 
end 

initial clk=0; 

// simulate analogue circuit with a digital model 
reg [7:0] hold;

always @(posedge sample) begin
    hold = 8'b01000110; 
end

assign cmp = (hold >= value); 


// monitor some signals and provide input stimuli 
initial begin 
	$monitor($time, " go=%b valid=%b result=%b sample=%b value=%b cmp=%b state=%b mask=%b", go,valid,result,sample,value,cmp,c.currentState,c.mask);
	#100; go=0; 
	#100; go=1; 
	#5000; go=0; 
	#5000; go=1; 
	#40; go=0; 
	#5000; $finish; 
end
endmodule


