`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 18.03.2018 07:25:21
// Design Name: Microprocessor system
// Module Name: Microprocessor system
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: Vivado 2015.2
// Description: 
// 1. This is the wrapper module of microprocessor system and its periperal (Havard Architecture)
// 2. The microprocessor system consist of microprocessor, RAM, ROM, and periperal 
//    (IR_transmitter, LEDs, 7seg, VGA interface, Timer, and mouse (is still not added) 
// 3. The bus interface consist of 8bit data bus and 8 bit address bus
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module microprocessor_system(

        //clock and reset
        input  					CLK,            //master clock
        input  					RESET,          //master reset
        
        //LED Interface
        output [7:0]            LEDS,           //LED interface
        
        //CAR LED
        output [3:0]            CAR_LED,       //Select car indicator
        output                  OUT_LED,
        
        //VGA interface
        output                  VGA_HS,        //VGA horizontal syncronization signal                            
        output                  VGA_VS,        //VGA vertical syncronization signal                          
        output  [11:0]          VGA_COLOUR     //VGA colour output                       
       
);


        // IO bus initialisations
        wire   [7:0]	       BUS_DATA;       //DATA BUS
        wire   [7:0]	       BUS_ADDR;       //DATA ADDRESS
        wire		           BUS_WE;         //BUS data enable
    
        
        // Instruction bus initialisations
        wire	[7:0]	ROM_ADDRESS;          //ROM ADDRESS
        wire	[7:0]	ROM_DATA;             //ROM DATA
    
    
        // Interrupt line initialisations
        wire  [1:0] BUS_INTERRUPTS_RAISE;    //Interupt raise indicator
        wire  [1:0] BUS_INTERRUPTS_ACK;      //Interupt acknowledgement
        
        
        reg MOUSE_INTERRUPTS_RAISE = 0;     //mouse interupt raise indicator register
        reg MOUSE_INTERRUPTS_ACK;           //mouse interupt raise indicator register
        
        
        assign BUS_INTERRUPTS_RAISE[0] 
                = MOUSE_INTERRUPTS_RAISE;   //assign the mouse interupt
                
                
        assign BUS_INTERRUPTS_ACK[0] 
                =  MOUSE_INTERRUPTS_ACK;   //assign the mouse acknowledgement
    
    
        //Micoprocessor module
        Processor microprocessor(
        
            //Clock and reset
            .CLK(CLK),
            .RESET(RESET),
            
            //BUS Signals
            .BUS_DATA(BUS_DATA),
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE),
            
            // ROM signals
            .ROM_ADDRESS(ROM_ADDRESS),
            .ROM_DATA(ROM_DATA),
            
            // interupt signals
            .BUS_INTERRUPTS_RAISE(BUS_INTERRUPTS_RAISE),
            .BUS_INTERRUPTS_ACK (BUS_INTERRUPTS_ACK)
        );

	       
	    
        // RAM module
        // its only gets enabled when 0 <= ADDR < 128
        RAM RAM(
            //clock
            .CLK(CLK),
            
            //BUS signals
            .BUS_DATA(BUS_DATA),
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE)
        );
        
        
        
        // ROM module
        // the address and data bus are different with the main one
        ROM ROM( 
            //clock
            .CLK(CLK),
            
            //BUS signals
            .DATA(ROM_DATA),
            .ADDR(ROM_ADDRESS)
        );
        
        
        
        // Timer IO Bus module
        Timer Timer(
            //clock and reset
            .CLK(CLK),
            .RESET(RESET),
            
            //BUS signals
            .BUS_DATA(BUS_DATA),  
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE),
            
            //interupt signals
            .BUS_INTERRUPT_RAISE(BUS_INTERRUPTS_RAISE[1]),
            .BUS_INTERRUPT_ACK(BUS_INTERRUPTS_ACK[1])
        );
    
    

        
        // LED output interface module
        LEDs_IO Bus_LEDs_IO (
            //clock
            .CLK(CLK),
            
            //bus signals
            .BUS_DATA(BUS_DATA),
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE),	
            
            //LEDs output
            .LEDs(LEDS)
        );
        
        
        
        // IR transmitter interface module
        IR_Transmitter_IO Bus_IR_Transmitter_IO (
        
            //Clock and Reset
            .CLK(CLK),
            .RESET(RESET),
            
            //Bus signals
            .BUS_DATA(BUS_DATA),
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE),
            
            //output IR transmitter
            .CAR_LED(CAR_LED),
            .OUT_LED(OUT_LED)
            
        
            );
          
           
           // VGA interface module
          VGA_interface_IO Bus_VGA_interface_IO(
            //clock and reset             
            .CLK(CLK),
            .RESET(RESET),
            
            //Bus signals
            .BUS_DATA(BUS_DATA),
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE),
            
            //VGA output signals
            .VGA_HS(VGA_HS),                                   
            .VGA_VS(VGA_VS),                                     
            .VGA_COLOUR(VGA_COLOUR)                             
                            
                    ); 
          
	
	 
endmodule