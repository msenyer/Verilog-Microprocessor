`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2018 09:26:15
// Design Name: 
// Module Name: microprocessor_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module microprocessor_tb(    
 );

    
    //inputs
    reg CLK;
    reg RESET;       
    
    wire [7:0] LEDS;
    wire [3:0] CAR_LED;
    wire    OUT_LED;
    
    
    
    
    microprocessor_system uut (
         .CLK(CLK),
         .RESET(RESET),
         .LEDS(LEDS), 
         .CAR_LED(CAR_LED),                    
         .OUT_LED(OUT_LED)
    );
    
    
    
    
    initial begin
    
        CLK = 0;
        
        forever CLK = #5 ~CLK;  // 100 MHz
        
    
    end
    
    
    initial begin
        RESET = 0;      #20
        RESET =  1 ;    #20
        RESET = 0 ;
        
    end
  
    
    
    
    


endmodule
