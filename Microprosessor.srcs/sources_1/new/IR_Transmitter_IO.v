`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 19.03.2018 15:49:45
// Design Name: IR Transmitter Input/output
// Module Name: IR_Transmitter_IO
// Project Name: microprocessor
// Target Devices: Basys2
// Tool Versions: 2015.2 vivado
// Description: 
// 1. the interface module from BUS data and BUS address towards IR transmitter module. 
// 2. Once the IRT Addres is selected, write to command and car select resigter.
// 3. Interface it with previous IR transmiiter module.
// Revision: v.1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module IR_Transmitter_IO(

            //clock and resset
            input               CLK,
            input               RESET,
            
            //bus signal
            inout  [7:0]        BUS_DATA,
            input  [7:0]        BUS_ADDR,
            input                BUS_WE,
            
            //output signals
            output [3:0]        CAR_LED,
            output              OUT_LED
            

    );
    
    
        //base address
        parameter BaseAddr     = 8'h90;
        
        
        //Tristate
        wire     [7:0]         BufferedBusData;
        
        //Input register
        reg      [3:0]         COMMAND; 
        reg      [3:0]         CAR_SW;
   
        
        //Only place data on the bus if the processor is NOT writing, and it is addressing this register
        assign BufferedBusData     = BUS_DATA;
        
        //enable signal
        wire ADDR_enable;
        
        //Enabled IRT when the bus address is equal to IRT's based address
        assign ADDR_enable = (BUS_ADDR == BaseAddr) ? 1'b1 : 1'b0;
        
        
        
        
        //write to input register
        always@(posedge CLK)
            begin
                
                //Only write when the bus address is matched
                if (ADDR_enable)
                    begin
                        if (BUS_WE) begin
                                
                                //Assigning IRT input with bus data
                                COMMAND  = BufferedBusData[3:0];
                                CAR_SW  = BufferedBusData[7:4];          
                        end
                        
                        else begin
                                
                                //give zero condition
                                COMMAND  = 4'h0;
                                CAR_SW  = 4'h0; 
                        end               
                    end        
                            
                
                
    
            end






            //Interface it with IR Transmitter module 

           IR_Transmitter IR_Transmitter_module (
            
                .CAR_SW(CAR_SW),
                .RESET(RESET),
                .CLK(CLK),
                .COMMAND(COMMAND),
                .CAR_LED(CAR_LED),
                .OUT_LED(OUT_LED)
                
                );
    
    


    
    
    
endmodule    