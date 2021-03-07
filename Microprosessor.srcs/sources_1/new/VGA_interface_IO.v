`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 20.03.2018 19:18:55
// Design Name: VGA_interface Input/output
// Module Name: VGA_interface_IO
// Project Name: microprocessor
// Target Devices: Basys2
// Tool Versions: 2015.2 vivado
// Description: 
// 1. the interface module from BUS data and BUS address towards VGA interface module. 
// 2. Once the VGA Addres is selected, write the bus data into the input resister.
// 3. Interface it with previous VGA interface module. 
// Revision: v.1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module VGA_interface_IO(

            //clock and reset
            input               CLK,
            input               RESET,
            
            //Bus signals
            inout  [7:0]        BUS_DATA,
            input  [7:0]        BUS_ADDR,
            input               BUS_WE,
            
            //VGA Port Interface
            output              VGA_HS,                             //Horizontal Syncorinzation signal
            output              VGA_VS,                             //Vertical syncronization sginal
            output  [11:0]      VGA_COLOUR                          //12 bits VGA output data 
            

    );
    
        //////////////////////////////////////////////////////////////////
        // Address description
        //BaseAddr + 0 -> config colour
        //BaseAddr + 1 -> 8 bit frame address MSB
        //BaseAddr + 2 -> 7 bits frame address MSB and + 1 bit frame input pixel data 
        
        parameter Colour_Addr           = 8'hB0;                   //Colour Config
        parameter MSB_Addr              = 8'hB1;                   //Frame address MSB 
        parameter LSB_DATA_Addr         = 8'hB2;                   //Frame address LSB and pixel data 
        
        
        //Tristate
        wire     [7:0]         BufferedBusData;
      
        
        //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
        assign BufferedBusData     = BUS_DATA;
        
        
        
        //enable signlas 
        wire [7:0]             Colour_Addr_enable;
        wire [7:0]             MSB_Addr_enable;    
        wire [7:0]             LSB_DATA_Addr_enable;
        
        
        //register to get the data from bus data
        reg  [7:0]             Frame_ADDR_MSB;                  //8 bit Address MSB
        reg  [6:0]             Frame_ADDR_LSB;                  //7 bit Address LSB
        reg  [14:0]            Frame_ADDR;                      //Frame Address
        reg  [11:0]            CONFIG_COLOURS;                  //Config colour
        reg                    DATA_IN;                         //input pixel data
        
        
        //Enabled VGA when the bus address is equal to VGA's based address
        assign Colour_Addr_enable =(BUS_ADDR == Colour_Addr) ? 1'b1 : 1'b0;
        assign MSB_Addr_enable = (BUS_ADDR == MSB_Addr) ? 1'b1 : 1'b0;    
        assign LSB_DATA_Addr_enable = (BUS_ADDR == LSB_DATA_Addr) ? 1'b1 : 1'b0;    
               
        
        //write to input register
        always@(posedge CLK)
            begin
                
              
    
                //Only write when the bus address is matched
                if (Colour_Addr_enable)
                    begin
                        if (BUS_WE) begin
                                
                                //interpolation from 8 bit to 11 bit colour
                                CONFIG_COLOURS  = {BufferedBusData[7:5],1'd0,BufferedBusData[4:3],2'd0,BufferedBusData[2:0],1'd0};          
                        end
                        
                        else begin
                        
                                 //give zero condition
                                CONFIG_COLOURS  = 12'h0; 
                        end               
                    end        
                    
                    
                    
                
                //Only write when the bus address is matched
                if (MSB_Addr_enable)
                    begin
                        if (BUS_WE) begin
                                
                                //Assigning 8 bit frame address MSB
                                Frame_ADDR_MSB  = BufferedBusData[7:0];       
                        end
                        
                        else begin
                                
                                //give zero condition
                                Frame_ADDR_MSB  = 8'h0; 
                        end               
                    end    
                    
                    
                    
                    
                //Only write when the bus address is matched
                if (LSB_DATA_Addr_enable)
                     begin
                        if (BUS_WE) begin
                                 
                                 //Assigning 7 bit frame address LSB + 1 bit frame data
                                 Frame_ADDR_LSB = BufferedBusData[7:1]; 
                                 DATA_IN = BufferedBusData[0];         
                        end
                                            
                        else begin
                                 
                                 //give zero condition         
                                 Frame_ADDR_LSB = 7'h0;
                                 DATA_IN = 1'b0;  
                        end               
                     end               
                              
                    
                //Assigning 8 bit Address MSB + 7 bit address LSB to 15 bit frame address
                Frame_ADDR = {Frame_ADDR_MSB[7:0], Frame_ADDR_MSB [6:0]};             
                
                
    
            end



    
             //Interface it with previous VGA interface module
             
            VGA_Sig_Gen VGA_Sig_Gen(
    
                .CLK(CLK),                                             
                .RESET(RESET),                                     
                .DATA_IN(DATA_IN),                                
                .Frame_ADDR(Frame_ADDR),                      
                .CONFIG_COLOURS(CONFIG_COLOURS),                           
                .VGA_HS(VGA_HS),                                     
                .VGA_VS(VGA_VS),                                       
                .VGA_COLOUR(VGA_COLOUR)                             

             );
    
    
    



endmodule
