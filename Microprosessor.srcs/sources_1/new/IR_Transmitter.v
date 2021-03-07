`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Radhian Ferel Armansyah
// 
// Create Date: 25.01.2018 11:00:31
// Design Name: IR Transmitter - TOP MODULE
// Module Name: IRTransmitterSM
// Project Name: IR Transmitter
// Target Devices: Digilent BASYS3
// Tool Versions: vivado 2015.2
// Description:  This design will generate modulated pulse to drive IR transmitter.
// The IR Transmitter has a purpose to drive a remote control car
// Revision: V.01
// Revision 0.01 - File Created
// Additional Comments:
// Here, the system will control red and blue signed remote control car. use 36 khz based 
// frequency.
//////////////////////////////////////////////////////////////////////////////////


module IR_Transmitter(
    input [3:0] CAR_SW,
    input RESET,
    input CLK,
    input [3:0] COMMAND,
    output[3:0] CAR_LED,
    output OUT_LED
    );
    

    //temporary parameters
    reg [7:0] startburstsize;       //payload for start burst
    reg [7:0] car_select;           //payload for car select
    reg [7:0] gap;                  //payload for gap
    reg [7:0] Assert;               //payload for assert
    reg [7:0] DeAssert;             //payload for de-assert
    reg [11:0] delay_clock;          //delay to generate square wave of the second clock (equals to half period of second clock)
    
    
    //Decleration
    reg [3:0] Curr_State = 0;       // The current state of finite state machine
    reg [3:0] Next_State = 0;       // The next state after the buffer counter of finite state machine
    reg [3:0] Previous_State = 0;   // The pervious state before the buffer counter of finite state machine
    reg [7:0] max_count;            // counter maximum boundary + 2 (2 clock cycle (CS) delays due to 1 CS the overflow of else in buffer counter and 1 CS to do case)
    reg [7:0] Pcounter = 0;         // Pulse Counter in buffer counter
    reg [11:0] Counter = 0;         // Counter to generate second clock (e.g. 36 khz, 40 khz)
    reg CLK_2 = 0;                  // Second clock, generate certain IR frequency (e.g. 36 khz, 40 khz)
    reg IR_LED = 0;                 // IR LED register
    reg flag = 1;                   // the indicator to activate IR_LED (1 means black out, 0 means bursting/ON) 
    reg [3:0] CAR_INDICATOR;        // Indicator which car that user select
    wire send_ena;                  // the enable signal to trigger for sending the packet every 10ms (100hz)
    
    assign CAR_LED = CAR_INDICATOR;     /* Assign the car indicator to CAR LED (output) */
    
    
    
    
 /*
    The sequential circuit below do 2 task :
    1. Choose the parameters of state machine and second clock for certain car based on car switch
            - SW0 --> blue car
            - SW1 --> red car 
    2. Generate the pulse signal here from the main clock running at 100MHz to generate the right frequency for
       the car in question (e.g. 40KHz for BLUE coded cars)
*/   


always@(posedge CLK) begin

/*Choose the parameters of state machine and second clock for certain car based on car switch (e.g yellow, red, blue car) */

        case(CAR_SW) 
                           
                           4'b0001: begin //BLUE CAR SELECTION
                           
                                  startburstsize = 191;
                                  car_select = 47;
                                  gap = 25;
                                  Assert = 47;
                                  DeAssert = 22;
                                  delay_clock = 1388;   
                                  CAR_INDICATOR =  4'b0001; 
                    
                           end
                           
                           4'b0010: begin //RED CAR SELECTION
                           
                                  startburstsize = 192 ;
                                  car_select = 24 ;
                                  gap = 24;
                                  Assert = 48;
                                  DeAssert = 24;
                                  delay_clock = 1388;  
                                  CAR_INDICATOR =  4'b0010; 
                                                                                                 
                           end
                           
                           
                           default : begin //Default condition
                           
                               startburstsize = 88;
                               car_select = 40 ;
                               gap = 22;
                               Assert = 44;
                               DeAssert = 22;
                               delay_clock = 1245;
                               CAR_INDICATOR =  4'b0000;
                           
                           end
                                    
                              
        endcase


/*

Generate the pulse signal here from the main clock running at 100MHz to generate the right frequency for
the car in question (e.g. 40KHz for BLUE coded cars)

*/

        if(RESET) begin // RESET Condition
        
               Counter <= 0;
                CLK_2 <= 0; 
                
        end
        
        else if(Counter == delay_clock) begin // Every half period of the second clock frequency, the clock polarity is inversing and reset the counter 
        
              Counter <= 0;
              CLK_2 <= ~CLK_2;
                
        end
        
        else begin
        
             Counter <= Counter + 1'b1;       // Counting procedure until half period of second clock 
             
        end
        
end

/*

Use the generic counter to trigger the send enable (send_packet). Hence, the sequence of data will release every 100ms (10 Hz) 

*/

Generic_counter # (.COUNTER_WIDTH(24), 
                   .COUNTER_MAX(10000000) 
                   )
                   
                   CLOCK_10HZ (
                   .CLK(CLK),
                   .RESET(RESET),
                   .ENABLE_IN(1'b1),
                   .TRIG_OUT(send_ena)
                   );
                   
                   
                   
                 
 /*
 
 Simple state machine to generate the states of the packet i.e. Start, Gaps, Right Assert or De-Assert, Left
 Assert or De-Assert, Backward Assert or De-Assert, and Forward Assert or De-Assert

 */
                  
                   
                   
                   
       
 always@(posedge CLK_2) begin
 
    if (RESET) begin
        
        /* Default state machine */
         Curr_State = 0;
         Next_State = 0;
         Previous_State = 0;
         Pcounter = 0;
         
    end
    
    else begin
         
             case(Curr_State) 
                 4'd0: begin //START STATE
                 
                     Next_State <= 1'd1;                //Move the Next state to the gap state (1)
                     Previous_State <= 1'd1;            //Force the previous state to the gap state (1) to exceute " Next_State <= Previous_State +1 " procedure
                     max_count <= startburstsize;       //Assign the start burst id as maximum boundary of counter buffer
                     flag <= 0;                         // Activate the IR LED
          
                     Curr_State <= 4'd8;                // change the current state to counter buffer
                     
                     end
                 
                 4'd1: begin ///GAP STATE
                 
                    /* Detecting whether is already the last sequence of burst FSM (in this case is forward state), then go to wait state */
                    
                     if(Previous_State == 4'd6)
                         Next_State <= 4'd7;
                     else 
                     Next_State <= Previous_State +1;
      
      
                     max_count <= gap;                   //Assign the gap id as maximum boundary of counter buffer
                     flag <= 1;                          // Activate the IR LED
                     Curr_State <= 4'd8;                 // change the current state to counter buffer
                   
                     end
                 
                 4'd2: begin //SELECT CAR STATE
                 
                     Next_State <= 4'd1;                //Move the Next state to the gap state (1)
                     Previous_State <= Curr_State;      //Assign the previous state to current state
                     max_count <= car_select;           //Assign the car select id as maximum boundary of counter buffer
                     flag <= 0;                         //Activate the IR LED
                     Curr_State <= 4'd8;                //Change the current state to counter buffer
                       
                     end
                 
                 4'd3: begin //RIGHT STATE
                    
                     /* Detecting moving command */
                     if(COMMAND[0] == 1)
                         max_count <= Assert;
                     else
                         max_count <= DeAssert;
                         
                     Next_State <= 4'd1;                //Move the Next state to the gap state (1)
                     Previous_State <= Curr_State;      //Assign the previous state to current state
                     flag <= 0;                         //Activate the IR LED
                     Curr_State <= 4'd8;                //Change the current state to counter buffer
                
                     end
                 
                 4'd4: begin //LEFT STATE
                    
                     /* Detecting moving command */
                     if(COMMAND[1] == 1)
                         max_count <= Assert;
                     else
                         max_count <= DeAssert;
                         
                     Next_State <= 4'd1;                //Move the Next state to the gap state (1)
                     Previous_State <= Curr_State;      //Assign the previous state to current state
                     flag <= 0;                         //Activate the IR LED        
                     Curr_State <= 4'd8;               //Change the current state to counter buffer
                          
                     end
                 
                 
                 4'd5: begin //BACKWARD STATE
                     
                     /* Detecting moving command */
                     if(COMMAND[2] == 1)
                         max_count <= Assert;
                     else
                         max_count <= DeAssert;
                         
                     Next_State <= 4'd1;                //Move the Next state to the gap state (1)
                     Previous_State <= Curr_State;      //Assign the previous state to current state
                     flag <= 0;                         //Activate the IR LED 
                     Curr_State <= 4'd8;                //Change the current state to counter buffer
                   
                     end
                     
                 4'd6: begin //FORWARD STATE
                     
                     /* Detecting moving command */
                     if(COMMAND[3] == 1)
                         max_count <= Assert;
                     else 
                         max_count <= DeAssert;
                         
                     Next_State <= 4'd1;                //Move the Next state to the gap state (1)
                     Previous_State <= Curr_State;      //Assign the previous state to current state
                     flag <= 0;                         //Activate the IR LED 
                     Curr_State <= 4'd8;                //Change the current state to counter buffer
                     
                     end
                     
                   4'd7: begin //WAIT STATE
                        
                        flag <= 1;                      //De-activate the IR LED 
                            
                            //send the packet
                            if(send_ena) begin
                                
                                /* Set to Defaut condition */
                                Curr_State = 0;
                                Next_State = 0;
                                Previous_State = 0;
                                Pcounter = 0;
                            
                            end
                                      
                        end   
                 
                 
                    4'd8: begin //COUNTER BUFFER
                             
                             
                             /*
                             After the pulse counter reach the boundary condition, 
                             the counter is reseted and change the current state (+ 2 CS from this else (1 CS) and case (1 CS))
                             */
                             
                             if(Pcounter == max_count - 2) begin    
                                     Pcounter <= 0; 
                                     Curr_State <= Next_State;
                             end
                                     
                             else begin
                                     Pcounter <= Pcounter+1;      //Counting until the boundari condition
                             end
                                                   
                          end  
                     
            endcase
      
      
       end
      
  end    
     
     
     
     
/* SIGNAL AND TRANSMITTER INTERFACE  */


always@(*) begin
    
     if(flag)
         IR_LED = 0;                // when flag = 1, make the IR LED black out
      else 
         IR_LED = CLK_2;            // else, make the IR LED register as second clock
   
                
 end
    
    assign OUT_LED = IR_LED;        //assign the resister to output
    
endmodule