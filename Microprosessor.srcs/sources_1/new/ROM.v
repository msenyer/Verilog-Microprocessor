`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 15.03.2018 11:29:23
// Design Name: Read Only Memory
// Module Name: ROM
// Project Name: microprocessor
// Target Devices: Basys2
// Tool Versions: 2015.2 vivado
// Description: 
// 1.The RAM can read and write data to/from microprocessor
// 2.It containt the list of instruction set
// Revision: v.1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module ROM(

        //standard signals
        input CLK,
        
        //BUS signals
        output reg [7:0] DATA,
        input [7:0] ADDR
         );
         
         
        parameter RAMAddrWidth = 8;
        
        //Memory
        reg [7:0] ROM [2**RAMAddrWidth-1:0];
        
        // Load program
        initial $readmemh("Complete_Demo_ROM.dat", ROM);
        
        //single port ram
        always@(posedge CLK)
        DATA <= ROM[ADDR];
        
endmodule