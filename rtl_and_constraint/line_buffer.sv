`timescale 1ns / 1ps                                                                                                                                                          
//////////////////////////////////////////////////////////////////////////////////                                                                                            
// Company: SVNIT                                                                                                                                                             
// Engineer: Aditya Mathuriya                                                                                                                                                                                                                                                                                                   
//////////////////////////////////////////////////////////////////////////////////                                                                                            
                                                                                                                                                                              
                                                                                                                                                                              
//parameter out_data_width = 18;                                                                                                                                              
module line_buffer # (                                                                                                                                                        
   parameter DATA_WIDTH            = 8             ,                                                                                                                            
   parameter DEPTH                 = 16            ,                                                                                                   
   parameter ADDRESS_WRITE_WIDTH   = $clog2(DEPTH) ,                                                                                      
   parameter ADDRESS_READ_WIDTH    = $clog2(DEPTH) , 
   parameter MEMORY_SIZE           = DATA_WIDTH * DEPTH                                                                                                                                                                                                                                                                                                                                                                       
)(                                                                                                                                                                            
   input                     clk,rst   ,                                                                                                                                                                
   input  [DATA_WIDTH-1:0]   dataIn    ,                                                                                                                                                
   input                     wrEn      , // write enable                                                                                                                                                   
   output [DATA_WIDTH-1:0]   dataOut   ,                                                                                                                                            
   input                     rdEn      , // read enable                                                                                                                                                    
   output                    empty_flag, // empty flag                                                                                                                                              
   output                    full_flag   // full flag                                                                                                                                           
);                                                                                                                                                                        
                                                                                                                                                                              
                                                                                                                                                                              
                                                                                                                                                                              
 //--------------------signals------------------                                                                                                                              
logic [ADDRESS_WRITE_WIDTH-1:0]wr_ptr              ;                                                                                                                                          
logic [ADDRESS_WRITE_WIDTH-1:0]wr_ptr_temp         ;                                                                                                                                          
logic [ADDRESS_WRITE_WIDTH-1:0]rd_ptr              ;                                                                                                                                             
logic [ADDRESS_WRITE_WIDTH-1:0]rd_ptr_d            ;                                                                                                                                             
logic [ADDRESS_WRITE_WIDTH-1:0]data_counter_write  ; // used for empty and full flag                                                                                                
logic [ADDRESS_WRITE_WIDTH-1:0]data_counter_write_d; // used for empty and full flag                                                                                                
logic [ADDRESS_READ_WIDTH:0]data_counter_read      ;// added during debugging of full flag                                                                                            
logic [ADDRESS_READ_WIDTH:0]data_counter_read_d    ;// added during debugging of full flag                                                                                            
logic [ADDRESS_READ_WIDTH-1:0]rd_ptr_temp          ;                                                                                                                                                                    
logic rsta_busy_0,rstb_busy_0                      ;                                                                                   
logic [DATA_WIDTH-1:0]dataOut_temp                 ;

//-------------------------xpm ram-------------------------------------
RAM #(
      .DATA_WIDTH         (DATA_WIDTH         ), 
      .DEPTH              (DEPTH              ),
      .ADDRESS_WRITE_WIDTH(ADDRESS_WRITE_WIDTH),                                                                                      
      .ADDRESS_READ_WIDTH (ADDRESS_READ_WIDTH ), 
      .MEMORY_SIZE        (MEMORY_SIZE        )
   )image (
      .clk    (clk        ),
      .rst    (rst        ), 
      .wr_addr(wr_ptr     ),                          
      .rd_addr(rd_ptr_temp), 
      .dataIn (dataIn     ),  
      .wrEn   (wrEn       ),                       
      .rdEn   (rdEn       ),                       
//      .dataOut(dataOut_temp)
      .dataOut(dataOut)
); 
//-----------------------------------------------------------------------
//assign dataOut = rdEn ? dataOut_temp : 'd0;                                                                                                                             
assign rd_ptr_temp = rst ? 'd0 : rd_ptr ;                                                                                                                             
//-----------------------------------------------                                                                                                                             
                                                                                                                                                                                                                                                                                                                                                    
//--------------------------------writing part------------------------------                                                                                                  
                                                                                                                                                                              
always @(posedge clk) begin                                                                                                                                                   
    if(rst || full_flag) begin                                                                                                                                                             
        wr_ptr     <=0;                                                                                                                                                                                                                                                                                                          
        wr_ptr_temp<=0;                                                                                                                                                                                                                                                                                                          
    end                                                                                                                                                                       
    else if(wrEn) begin                                                                                                                                                       
         wr_ptr      <= wr_ptr + 1;                                                                                                                                                
         wr_ptr_temp <= wr_ptr    ;                                                                                                                                                
    end                                                                                                                                                                       
end                                                                                                                                                                           
//--------------------------reading part-------------------------------                                                                                                       
always @ (posedge clk) begin                                                                                                                                                  
    if(rst || empty_flag) begin                                                                                                                                                             
        rd_ptr<=0;                                                                                                                                                            
    end                                                                                                                                                                       
    else if(rdEn) begin                                                                                                                                                       
        rd_ptr<=rd_ptr +1;                                                                                                                                                                                                                                                                                                   
    end                                                                                                                                                                       
end   

always @ (posedge clk) begin                                                                                                                                                  
    if(rst || empty_flag) begin                                                                                                                                                             
        rd_ptr_d<=0;                                                                                                                                                            
    end                                                                                                                                                                       
    else if(rdEn) begin                                                                                                                                                       
        rd_ptr_d<=rd_ptr ;                                                                                                                                                                                                                                                                                                   
    end                                                                                                                                                                       
end                                                                                                                                                                           
//---------------------------------------------------------------------                                                                                                       
//-------------------------data counter---------------------------------                                                                                                      
always @ (posedge clk) begin                                                                                                                                                  
    if (rst || empty_flag) begin                                                                                                                                                            
        data_counter_write<='d0; 
        data_counter_read<=DEPTH-1;                                                                                                                                               
    end                                                                                                                                                                       
    else begin 
       if (wrEn) begin                                                                                                                                             
           data_counter_write<=data_counter_write +1; 
       end                                                                                                                                                                       
       else if (rdEn) begin                                                                                                                                             
             data_counter_read <= data_counter_read -1;                                                                                                                          
       end 
    end                                                                                                                                                                       
end                                                                                                                                                                           

always @(posedge clk) begin  
      data_counter_write_d <= data_counter_write;
      data_counter_read_d  <= data_counter_read ;
end                                                                                                                                                                         
//--------------------------------flags-------------------------------------                                                                                                  
assign full_flag = (data_counter_write==DEPTH-1) ? 1:0; // full flag                                                                                        
assign empty_flag = (data_counter_read==0) ? 1:0;       // empty flag                                                                                                
//--------------------------------------------------------------------------                                                                                                  
                                                                    
                                                                                                                                                                              
endmodule                                                                                                                                                                     