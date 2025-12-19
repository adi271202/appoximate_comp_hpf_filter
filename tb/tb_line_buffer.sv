`timescale 1ns / 1ps

module tb_line_buffer();

//----------------------signals---------------------
parameter DATA_WIDTH = 8; 
parameter DEPTH      = 16; 
//--------------------------------------------------
logic clk,rst             ; 
logic [7:0]dataIn,dataIn_d,dataIn_2d         ;  
logic wrEn_d,rdEn_d,wrEn_2d,rdEn_2d ; 
logic wrEn,rdEn ; 
logic [7:0]dataOut        ; 
logic empty_flag,full_flag; 
//----------------------inst------------------------
line_buffer # (                                                                                                                                                        
                       .DATA_WIDTH(DATA_WIDTH),                                                                                                                            
                       .DEPTH     (DEPTH     )                                                                                                                                                                                                                           
)dut(                                                                                                                                                                            
      .clk        (clk       ),
      .rst        (rst       ),                                                                                                                                                               
      .dataIn     (dataIn_2d ),                                                                                                                                                
      .wrEn       (wrEn      ), // write enable                                                                                                                                                   
      .dataOut    (dataOut   ),                                                                                                                                            
      .rdEn       (rdEn      ), // read enable                                                                                                                                                    
      .empty_flag (empty_flag), // empty flag                                                                                                                                              
      .full_flag  (full_flag )  // full flag   
                                                                                                                                          
);       
//--------------------------------------------------

always #5 clk=~clk; 

//--------------------------------------------------
initial begin 
   clk=1; rst=1; dataIn_d=0; rdEn_d=0; wrEn_d=0; 
   #100;
   rst=0; 
   #10; 
   wrEn_d=1;
   for (int i=0; i<16;i++) begin  
      dataIn_d <= i + 16; 
      #10; 
   end
   wrEn_d=0; 
   #30; 
   rdEn_d=1; 
   #160; 
   rdEn_d=0; 
   #50 $finish(); 
end

always_ff @(posedge clk) begin 
   wrEn_2d <= wrEn_d;
   wrEn  <= wrEn_2d;
   rdEn_2d <= rdEn_d;
   rdEn  <= rdEn_2d;
   dataIn_2d <= dataIn_d;
   dataIn <= dataIn_2d;
end
//--------------------------------------------------

endmodule
