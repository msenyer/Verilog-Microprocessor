`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 16.02.2018 11:02:41
// Design Name: VGA signal generator
// Module Name: VGA_Sig_Gen
// Project Name: VGA interface
// Target Devices: Digilent BASYS3
// Tool Versions: vivado 2015.2
// Description: The system will generates horizontal and vertical syncronization signal and the VGA data.
// The VGA data will be produecd using a frame buffer that stored temp0rary image. 
// Revision: v.01
// Revision 0.01 - File Created
// Additional Comments: 
// The module is integrated with car control module and frame buffer module
//////////////////////////////////////////////////////////////////////////////////


module VGA_Sig_Gen(
    
    input CLK,                                               //Master clock
    input RESET,                                             //Reset button
    
    input DATA_IN,                                   //input data to frame buffer (RAM) - port A
    input [14:0] Frame_ADDR,                            //assign address to that associate input data
    
    //Colour Configuration Interface
    input [11:0] CONFIG_COLOURS,                             //colour setting

    
    //VGA Port Interface
    output reg VGA_HS,                                       //Horizontal Syncorinzation signal
    output reg VGA_VS,                                       //Vertical syncronization sginal
    output reg [11:0] VGA_COLOUR                             //12 bits VGA output data 

    );
    
    
    
     /* Frame Buffer (Dual Port memory) Interface */
     
     wire DPR_CLK;                                            //The frame buffer clock (25 Mhz)
     wire [14:0] VGA_ADDR;                                    //Request address to the frame buffer
     wire VGA_DATA;                                           //1 bit VGA data from the frame buffer
    
    
    
    /* Converting 100Mhz frequency to 25 MHz frecuency */
    
    reg VGA_CLK = 0;                                          // VGA module clock (25 Mhz)
    reg counter = 0;                                          // counter to convert 100 Mhz into 25 Mhz clock frequency
    
    always@(posedge CLK) begin
    
        if(RESET) begin                                       // Reset conditon (reset counter and clock)
        
            counter <= 0;
            VGA_CLK <= 0;
        
        end
     
        else if(counter == 1) begin                           //Inverting the clock logic
        
            counter <= 0;
            VGA_CLK <= ~VGA_CLK;
            
        end
     
        else
     
            counter <= counter + 1'b1;                       //Continue counting
        
    end
     
     
     
     
     
    /*
    Define VGA signal parameters e.g. Horizontal and Vertical display time, pulse widths, front and back
    porch widths etc.
    */
    
    
    // Signal parameters
    parameter HTs = 794;                                    // Total Horizontal Sync Pulse Time
    parameter HTpw = 96;                                    // Horizontal Pulse Width Time
    parameter HTDisp = 640;                                 // Horizontal Display Time
    parameter Hbp = 48;                                     // Horizontal Back Porch Time
    parameter Hfp = 16;                                     // Horizontal Front Porch Time
    parameter VTs = 525;                                    // Total Vertical Sync Pulse Time
    parameter VTpw = 2;                                     // Vertical Pulse Width Time
    parameter VTDisp = 480;                                 // Vertical Display Time
    parameter Vbp = 29;                                     // Vertical Back Porch Time
    parameter Vfp = 10;                                     // Vertical Front Porch Time
    
    
    parameter H_start   = HTpw + Hbp;                       //Starting horizontal video on
    parameter H_end     = HTpw + Hbp + HTDisp;              //Ending horizontal video on
    parameter V_start   = VTpw + Vbp;                       //Starting vertical video on 
    parameter V_end     = VTpw + Vbp + VTDisp;              //Ending vertical video on
   
   
   
     // Define Horizontal and Vertical Counters to generate the VGA signals
     
    reg [9:0] HCounter = 0;                                 //Horizontal counter
    reg [9:0] VCounter = 0;                                 //Vertical counter
    
    
    reg video_on;                                           //video on
    
    /*
    Create a process that assigns the proper horizontal and vertical counter values for raster scan of the
    display.
    */
    
    /*Counter */
    always@(posedge VGA_CLK) begin
  
         if(HCounter == HTs) begin                          // Reset the counter every Total Horizontal Sync Pulse Time
            
            HCounter <= 0;                                
            VCounter <= VCounter + 1'b1;                    // Counting procedure
         
         end
         
         else if (VCounter == VTs)                         //Reset the counter every Total Vertical Sync Pulse Time
           
            VCounter <= 0;                               
            
         else
    
            HCounter <= HCounter + 1'b1;                  // Horizontal counting procedure
         
         
         
         video_on = (HCounter >= H_start) && (HCounter < H_end) && (VCounter >= V_start) && (VCounter < V_end);        //display condition
         
         
         
    end
    
    
    
    
    /*
    Need to create the address of the next pixel. Concatenate and tie the look ahead address to the frame
    buffer address.
    */
    
    
    assign DPR_CLK = VGA_CLK;                             //porting VGA clock to frame buffer clock
    assign VGA_ADDR = {VCounter[8:2], HCounter[9:2]};     //Reducing 4x4 pixels by reducing number of bits at Vcounter and Hcounter
    
    
     
    
    
    
    /*
    Create a process that generates the horizontal and vertical synchronisation signals, as well as the pixel
    colour information, using HCounter and VCounter. Do not forget to use CONFIG_COLOURS input to
    display the right foreground and background colours.
    */

    always@(*) begin
     
            /* Horizontal */
            if(HCounter < HTpw)                         // Set the signal to low logic
               
               VGA_HS <= 1'b0;
       
            else                                       // Set the signal to high logic
       
               VGA_HS <= 1'b1;
               
               
            /* Vertical */   
            if(VCounter < VTpw)                       // Set the signal to low logic
                  
               VGA_VS <= 1'b0;
          
            else                                      // Set the signal to high logic
          
               VGA_VS <= 1'b1;
               
              

    end
    
     
       
    
       wire DATA_B;                                   //output data from frame buffer (ROM) - port B
       wire write_ena;
       
       
       //assign write_ena = VGA_en && video_on;

        
        
       /* Frame buffer module (only use RAM access - port A) */
       Frame_Buffer Frame_Buffer (
  
                         
                         .A_CLK(DPR_CLK),
                         .A_ADDR(Frame_ADDR), 
                         .A_DATA_IN(DATA_IN),
                         .A_WE(video_on),          //enable when video on signal is acticated 
                         .B_ADDR(VGA_ADDR),
                         .B_CLK(DPR_CLK),
                         .B_DATA(VGA_DATA)
                         
                         );


                   
       /*
             Finally, tie the output of the frame buffer to the colour output VGA_COLOUR.
                         
       */         
    
       always@(*) begin
         
       if(video_on && VGA_DATA)                         //pass 1 bit data when video on signal and 1 bit data (from frame buffer) is activated 
                                                      
                  VGA_COLOUR <= CONFIG_COLOURS;         //pass the configuration colour to 12-bit VGA output
                                              
       else                      
                                              
                  VGA_COLOUR <= 0;                      //pass the configuration colour to 12-bit VGA output
         
         
         end

    
endmodule
