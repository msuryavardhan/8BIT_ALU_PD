create_clock -name clk -period 10 [get_ports clk]

set_input_delay 1 -clock clk [get_ports {rs1 rs2 alu_op rst}]
set_output_delay 1 -clock clk [get_ports {result zero carry overflow negative}]
