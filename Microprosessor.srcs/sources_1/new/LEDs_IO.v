`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 17.03.2018 11:35:06
// Design Name: LEDs Input/output
// Module Name: LEDs_IO
// Project Name: microprocessor
// Target Devices: Basys2
// Tool Versions: 2015.2 vivado
// Description: 
// 1. The LEDS can show the 8 bit configuration based on the data from bus data
// Revision: v.1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////



module LEDs_IO(
        //clock
		input 			CLK,
		
		//BUS signals
		inout  [7:0]   BUS_DATA,
		input  [7:0] 	BUS_ADDR,
		input  			BUS_WE,	
		
		//output LEDS	
		output reg [7:0]	LEDs
	);

    //LEDS's based address
	parameter BaseAddr 	= 8'hC0;
	
	//Tristate
	wire 	[7:0] 		BufferedBusData;
	
	
	//Only place data on the bus if the processor is NOT writing, and it is addressing this memory
	assign BufferedBusData 	= BUS_DATA;
	
	//ENABLE signal 
    wire ADDR_enable;
   
    //Enabled LEDs when the bus address is qual to LEDS's based address
    assign ADDR_enable = (BUS_ADDR == BaseAddr) ? 1'b1 : 1'b0;
    
	
	//write to LEDs register
	always@(posedge CLK)
		begin
			
            //Only write when the bus address is matched
			if (ADDR_enable)
				begin
				
					if (BUS_WE)
					        
					        //Assigning LEDs register with bus data
							LEDs  = BufferedBusData;		
					
					else
						    //give zero condition
							LEDs = 1'b0;
											
				end		


		end
		
		
endmodule