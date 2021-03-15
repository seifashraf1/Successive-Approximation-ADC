all:
	iverilog SAR_Controller.v SAR_Controller_tb.v -o SAR_Controller.vvp
	vvp SAR_Controller.vvp
	gtkwave SAR_Controller.vcd

