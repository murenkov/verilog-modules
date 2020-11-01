waveform:
	iverilog -o "$(MODULE).vvp" *.v "testbench/$(MODULE)_testbench.v";
	vvp "$(MODULE).vvp";
	gtkwave "$(MODULE).vcd";

clean:
	rm *.vvp *.vcd
