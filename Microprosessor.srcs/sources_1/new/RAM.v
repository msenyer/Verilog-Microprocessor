`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 15.03.2018 11:24:59
// Design Name: Random Access Memory (RAM)
// Module Name: RAM
// Project Name: microprocessor
// Target Devices: Basys2
// Tool Versions: 2015.2 vivado
// Description: 
// 1.The RAM can read and write data to/from the bus 
// 2.The bus data can be enabled using BUS_WE signals.
// 3.It contain the list of data/address
// Revision: v.1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module RAM(

        //clock and reset
        input CLK,
        
        //BUS signals
        inout [7:0] BUS_DATA,
        input [7:0] BUS_ADDR,
        input BUS_WE 
         );
       
        parameter RAMBaseAddr = 0;
        parameter RAMAddrWidth = 7; // 128 x 8-bits memory
        
        //Tristate
        wire [7:0] BufferedBusData;
        reg [7:0] Out;
        reg RAMBusWE;
        
        //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
        assign BufferedBusData = BUS_DATA;
        assign BUS_DATA = (RAMBusWE) ? Out : 8'hZZ;
        
       
        
        //Memory
        reg [7:0] Mem [2**RAMAddrWidth-1:0];
        
        // Initialise the memory for data preloading, initialising variables, and declaring constants
        initial $readmemh("Complete_Demo_RAM.dat", Mem);
        
        //single port ram
        always@(posedge CLK) begin
        
            // Brute-force RAM address decoding. Think of a simpler way...
            if((BUS_ADDR >= RAMBaseAddr) & (BUS_ADDR < RAMBaseAddr + 128)) begin
                if(BUS_WE) begin
                    Mem[BUS_ADDR[6:0]] <= BufferedBusData;
                    RAMBusWE <= 1'b0;
                 end else
                    RAMBusWE <= 1'b1;
                    
            end else
                RAMBusWE <= 1'b0;
                
            Out <= Mem[BUS_ADDR[6:0]];
            
        end


endmodule
