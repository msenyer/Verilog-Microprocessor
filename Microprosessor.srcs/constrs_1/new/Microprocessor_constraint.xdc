## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK] 
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 

##Buttons
set_property PACKAGE_PIN U18 [get_ports RESET] 
set_property IOSTANDARD LVCMOS33 [get_ports RESET]



##LEDS
set_property PACKAGE_PIN U16 [get_ports {LEDS[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[0]}]
set_property PACKAGE_PIN E19 [get_ports {LEDS[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[1]}]
set_property PACKAGE_PIN U19 [get_ports {LEDS[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[2]}]
set_property PACKAGE_PIN V19 [get_ports {LEDS[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[3]}]
set_property PACKAGE_PIN W18 [get_ports {LEDS[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[4]}]
set_property PACKAGE_PIN U15 [get_ports {LEDS[5]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[5]}]
set_property PACKAGE_PIN U14 [get_ports {LEDS[6]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[6]}]
set_property PACKAGE_PIN V14 [get_ports {LEDS[7]}]    
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[7]}]
    
 set_property PACKAGE_PIN P3 [get_ports {CAR_LED[0]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {CAR_LED[0]}]
 set_property PACKAGE_PIN N3 [get_ports {CAR_LED[1]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {CAR_LED[1]}]
 set_property PACKAGE_PIN P1 [get_ports {CAR_LED[2]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {CAR_LED[2]}]
 set_property PACKAGE_PIN L1 [get_ports {CAR_LED[3]}] 
    set_property IOSTANDARD LVCMOS33 [get_ports {CAR_LED[3]}]
       





##Pmod Header JC
##Sch name = JC1
#set_property PACKAGE_PIN K17 [get_ports {JC[0]}] 
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[0]}]
##Sch name = JC2
#set_property PACKAGE_PIN M18 [get_ports {JC[1]}] 
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[1]}]
##Sch name = JC3
#set_property PACKAGE_PIN N17 [get_ports {JC[2]}] 
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[2]}]
##Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports OUT_LED] 
set_property IOSTANDARD LVCMOS33 [get_ports OUT_LED]
##Sch name = JC7s
#set_property PACKAGE_PIN L17 [get_ports {JC[4]}] 
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[4]}]
##Sch name = JC8
#set_property PACKAGE_PIN M19 [get_ports {JC[5]}] 
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[5]}]
##Sch name = JC9
#set_property PACKAGE_PIN P17 [get_ports {JC[6]}] 
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[6]}]
##Sch name = JC10
#set_property PACKAGE_PIN R18 [get_ports {JC[7]}] 
#set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]



##VGA Connector
set_property PACKAGE_PIN G19 [get_ports {VGA_COLOUR[0]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[0]}]
set_property PACKAGE_PIN H19 [get_ports {VGA_COLOUR[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[1]}]
set_property PACKAGE_PIN J19 [get_ports {VGA_COLOUR[2]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[2]}]
set_property PACKAGE_PIN N19 [get_ports {VGA_COLOUR[3]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[3]}]
set_property PACKAGE_PIN N18 [get_ports {VGA_COLOUR[4]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[4]}]
set_property PACKAGE_PIN L18 [get_ports {VGA_COLOUR[5]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[5]}]
set_property PACKAGE_PIN K18 [get_ports {VGA_COLOUR[6]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[6]}]
set_property PACKAGE_PIN J18 [get_ports {VGA_COLOUR[7]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[7]}]
set_property PACKAGE_PIN J17 [get_ports {VGA_COLOUR[8]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[8]}]
set_property PACKAGE_PIN H17 [get_ports {VGA_COLOUR[9]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[9]}]
set_property PACKAGE_PIN G17 [get_ports {VGA_COLOUR[10]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[10]}]
set_property PACKAGE_PIN D17 [get_ports {VGA_COLOUR[11]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[11]}]
set_property PACKAGE_PIN P19 [get_ports VGA_HS] 
set_property IOSTANDARD LVCMOS33 [get_ports VGA_HS]
set_property PACKAGE_PIN R19 [get_ports VGA_VS] 
set_property IOSTANDARD LVCMOS33 [get_ports VGA_VS]