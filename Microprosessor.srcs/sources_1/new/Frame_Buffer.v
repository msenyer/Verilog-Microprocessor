`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 16.02.2018 10:55:58
// Design Name: Frame buffer
// Module Name: Frame_Buffer
// Project Name: VGA_interface
// Target Devices: Digilent BASYS3
// Tool Versions: vivado 2015.2
// Description: This module will store 256 x 128 x 1 bits image as temporary refister by using FIFO principle
// Revision: v.01
// Revision 0.01 - File Created
// Additional Comments:
// this module will receive the address as well as data from car controller and stored in 256 x 128 frame register
//////////////////////////////////////////////////////////////////////////////////


module Frame_Buffer(
    
        /// Port A - Read/Write
        input A_CLK,
        input [14:0] A_ADDR, // 8 + 7 bits = 15 bits hence [14:0]
        input A_DATA_IN, // Pixel Data In
        output reg A_DATA_OUT,
        input A_WE, // Write Enable
        
        
        //Port B - Read Only
        input B_CLK,
        input [14:0] B_ADDR, // Pixel Data Out
        output reg B_DATA

    );
    
    // A 256 x 128 1-bit memory to hold frame data
     //The LSBs of the address correspond to the X axis, and the MSBs to the Y axis
     reg [0:0] Mem [2**15-1:0];
    
    
     // Port A - Read/Write e.g. to be used by microprocessor
    always@(posedge A_CLK) begin
         if(A_WE)
            Mem[A_ADDR] <= A_DATA_IN;
        
           A_DATA_OUT <= Mem[A_ADDR];
    end
    
    
     // Port B - Read Only e.g. to be read from the VGA signal generator module for display
    always@(posedge B_CLK)
    
        B_DATA <= Mem[B_ADDR];


    

   
      //FRAME BUFFER ROM
     
     integer i;
     integer j;    
     integer x;
     integer y;
     //integer   even_enable;
     //integer   odd_enable;
     integer   sign;
     integer   sign2;
     
     parameter x1 = 83;
     parameter x2 = 86;
     parameter x3 = 145;
     parameter x4 = 148;
     parameter y1 = 46;
     parameter y2 = 49;
     parameter y3 = 91;
     parameter y4 = 94;
     
     
     
     // Load program
             initial $readmemh("chequared_frame.dat", Mem);
     
   
   /*
   
 initial begin
        
        x = 0;
        y = 0;
        
        for (i = 0; i < 32768; i = i + 1) begin
        
            if (i < ((y*256) + 256))
                #1  x = x + 1;
                
            else begin
                #1  x = 0;
                #1  y = y +1;
            end 
            
            if ( ((x > x1) && (x < x2 )) || ((x > x3) && (x < x4 )) || ((y > y1) && (y < y2 )) || ((y > y3) && (y < y4 ))    )  
                #1  Mem[i] <= 1'b0;
                
            else 
                #1 Mem[i] <= 1'b1;
        end
        
   
            #1  $finish;
    end
         
         
   */
 

 /*
 
 
initial begin
      
        
     Mem[0] = 1'b1;
     x = 0;
     y = 0;
      
      for (i = 0; i < 32767; i = i + 1) begin
        
           
           if (i < ((y*256) + 256)) begin
                            
                   #1  x = x + 1;
                  
          
           end
                            
           else begin
                  
                   #1  x = 0;
                   #1  y = y +1;
                   
                   
           end 
           
           
           if ( x == 0   )  
                          #1 Mem[i+1] <= #1 Mem[i];
                           
           else 
                          #1  Mem[i+1] <= #1 ~Mem[i];
     end
     
           
      
        
      
      
      
          #1  $finish;
          
  end
 
 
    */
         
 endmodule 