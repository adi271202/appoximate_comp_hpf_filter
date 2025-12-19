`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mathuriya 
//////////////////////////////////////////////////////////////////////////////////

//------------------------approx fa---------------------
//   1. half exact half approx 
//   2. ful approx 
//      1. s = a^b,              co = a&b; 
//      2. s = (~a | b) & cin,   co = a&b; 
//      3. s = b    ,            co = a&b; 
//------------------------------------------------------

module filter #(
   DATA_WIDTH = 8  , 
   DEPTH      = 256   
   )(
   input  logic                  clk          , 
   input  logic                  rst          , 
   input  logic                  i_valid      , 
   input  logic [DATA_WIDTH-1:0] i_image_pixel,
   output logic                  o_ready      , 
   output logic                  o_valid      , 
   output logic [DATA_WIDTH-1:0] o_conv_pixel
    );
    
//---------------------------signals--------------------------------
   logic [3:0] wrEn,rdEn; 
   logic [3:0][7:0] dataOut; 
   logic [3:0] full_flag,empty_flag; 
   logic [1:0] current_write_line_buffer; 
   logic [1:0] current_read_line_buffer; 
   logic [$clog2(3*DEPTH)-1:0] total_pixel; 
   logic read_enable; 
   logic [3*DATA_WIDTH-1:0] sliding_window_in; 
   logic sliding_window_valid_out; 
   logic [9*DATA_WIDTH-1:0] sliding_window_data;
   logic state;
   localparam IDLE=0, RDSTATE=1;
//------------------------------------------------------------------

//----------------------line buffers--------------------------------
   
line_buffer # (                                                                                                                                                        
     .DATA_WIDTH (DATA_WIDTH),                                                                                                                            
     .DEPTH      (DEPTH     )                                                                                                                                                                                                                                                                                                                                         
)line_buff01(                                                                                                                                                                           
   .clk       (clk          ),
   .rst       (rst          ),                                                                                                                                                                
   .dataIn    (i_image_pixel),                                                                                                                                 
   .wrEn      (wrEn[0]      ),                                                                                                                                                    
   .dataOut   (dataOut[0]   ),                                                                                                                             
   .rdEn      (rdEn[0]      ),                                                                                                                                                    
   .empty_flag(empty_flag[0]),                                                                                                                                             
   .full_flag (full_flag[0] )                                                                                                                            
);   


line_buffer # (                                                                                                                                                        
     .DATA_WIDTH (DATA_WIDTH),                                                                                                                            
     .DEPTH      (DEPTH     )                                                                                                                                                                                                                                                                                                                                         
)line_buff02(                                                                                                                                                                            
   .clk       (clk          ),
   .rst       (rst          ),                                                                                                                                                                
   .dataIn    (i_image_pixel),                                                                                                                                 
   .wrEn      (wrEn[1]      ),                                                                                                                                                    
   .dataOut   (dataOut[1]   ),                                                                                                                             
   .rdEn      (rdEn[1]      ),                                                                                                                                                    
   .empty_flag(empty_flag[1]),                                                                                                                                             
   .full_flag (full_flag[1] )                                                                                                                            
);   


line_buffer # (                                                                                                                                                        
     .DATA_WIDTH (DATA_WIDTH),                                                                                                                            
     .DEPTH      (DEPTH     )                                                                                                                                                                                                                                                                                                                                         
)line_buff021(                                                                                                                                                                            
   .clk       (clk          ),
   .rst       (rst          ),                                                                                                                                                                
   .dataIn    (i_image_pixel),                                                                                                                                 
   .wrEn      (wrEn[2]      ),                                                                                                                                                    
   .dataOut   (dataOut[2]   ),                                                                                                                             
   .rdEn      (rdEn[2]      ),                                                                                                                                                    
   .empty_flag(empty_flag[2]),                                                                                                                                             
   .full_flag (full_flag[2] )                                                                                                                            
);   


line_buffer # (                                                                                                                                                        
     .DATA_WIDTH (DATA_WIDTH),                                                                                                                            
     .DEPTH      (DEPTH     )                                                                                                                                                                                                                                                                                                                                         
)line_buff03(                                                                                                                                                                            
   .clk       (clk          ),
   .rst       (rst          ),                                                                                                                                                                
   .dataIn    (i_image_pixel),                                                                                                                                 
   .wrEn      (wrEn[3]      ),                                                                                                                                                    
   .dataOut   (dataOut[3]   ),                                                                                                                             
   .rdEn      (rdEn[3]      ),                                                                                                                                                    
   .empty_flag(empty_flag[3]),                                                                                                                                             
   .full_flag (full_flag[3] )                                                                                                                            
);
//-------------------------------------------------------------------

//---------for updating the writing in the line buffers, once a buffer is full, pointer is incremented 
always @(posedge clk) begin 
   if(rst) begin 
      current_write_line_buffer <= 'd0; 
   end
   else if((full_flag[0] || full_flag[1] || full_flag[2] || full_flag[3])&&i_valid ) begin 
      current_write_line_buffer <= current_write_line_buffer + 'd1; 
   end
end

//-----------combinationally assigning the wr enable signal
always @ (*) begin 
   wrEn <= 'd0; 
   if(i_valid && o_ready) begin 
      wrEn[current_write_line_buffer] <= 1'b1; 
   end
   else begin 
      wrEn <= 'd0; 
   end
end 

//------------counting the total number of pixels, to start the read signals 
always @(posedge clk) begin 
   if(rst) begin 
      total_pixel <= 'd0; 
   end
   else begin 
      if((wrEn[0] || wrEn[1] || wrEn[2] || wrEn[3]) && !(rdEn[0] || rdEn[1] || rdEn[2] || rdEn[3])) begin 
         total_pixel <= total_pixel + 1'b1; 
      end
      else if(!(wrEn[0] || wrEn[1] || wrEn[2] || wrEn[3]) && (rdEn[0] || rdEn[1] || rdEn[2] || rdEn[3])) begin 
         total_pixel <= total_pixel - 1'b1; 
      end 
   end
end

//----------generating the read signal 
//---small fsm for getting that
 
always @(posedge clk) begin 
   if(rst) begin 
      state <= IDLE; 
      read_enable <= 'b0; 
      o_ready     <= 'b0; 
   end
   else begin 
      case(state)  
         IDLE : begin
            o_ready <= 1'b1; 
            if (total_pixel >= 3*DEPTH-1) begin 
              read_enable <= 1'b1;
              state       <= RDSTATE; 
              o_ready     <= 'b0; 
            end  
         end
         RDSTATE : begin 
            if((empty_flag[0] || empty_flag[1] || empty_flag[2] || empty_flag[3])) begin
               read_enable <= 'b0; 
               o_ready     <= 1'b1;
               state       <= IDLE;
            end
         end
      endcase
   end
end

//--------read counter to manage the reading from 3 line buffers 
always @(posedge clk) begin 
   if(rst) begin 
      current_read_line_buffer <= 'd0; 
   end
   else begin 
      if((empty_flag[0] || empty_flag[1] || empty_flag[2] || empty_flag[3]) & read_enable) begin 
         current_read_line_buffer <= current_read_line_buffer +1; 
      end
   end
end

//--------mulitplexers to read the the data from the line buffers 
//-------- read in the seq:-> 0 1 2 -> 1 2 3 -> 2 3 0 -> 3 0 1 -> 0 1 2......................
//always @(posedge clk) begin 
always @(*) begin 
//   if(rst) begin 
      rdEn <= 'd0; 
//   end
//   else begin 
      case(current_read_line_buffer) 
         0: begin 
            rdEn[0] <=  read_enable; 
            rdEn[1] <=  read_enable; 
            rdEn[2] <=  read_enable; 
            rdEn[3] <=  1'b0; 
            sliding_window_in <= {dataOut[2],dataOut[1],dataOut[0]}; 
         end
         1: begin 
            rdEn[0] <=  1'b0; 
            rdEn[1] <=  read_enable; 
            rdEn[2] <=  read_enable; 
            rdEn[3] <=  read_enable; 
            sliding_window_in <= {dataOut[3],dataOut[2],dataOut[1]}; 
         end
         2: begin 
            rdEn[0] <=  read_enable; 
            rdEn[1] <=  1'b0; 
            rdEn[2] <=  read_enable; 
            rdEn[3] <=  read_enable; 
            sliding_window_in <= {dataOut[0],dataOut[3],dataOut[2]}; 
         end
         3: begin 
            rdEn[0] <=  read_enable; 
            rdEn[1] <=  read_enable; 
            rdEn[2] <=  1'b0; 
            rdEn[3] <=  read_enable; 
            sliding_window_in <= {dataOut[1],dataOut[0],dataOut[3]}; 
         end
      endcase
//   end
end

//------------------------sliding window inst----------------------
sliding_window #(
   .DEPTH      (DEPTH     ), 
   .DATA_WIDTH (DATA_WIDTH)
 )sliding_window_inst(
   .clk     (clk                     ), 
   .rst     (rst                     ), 
   .i_data  (sliding_window_in       ), 
   .i_valid (read_enable             ), 
   .o_data  (sliding_window_data     ),
   .o_valid (sliding_window_valid_out)
    );
//------------------------------------------------------------------

//------------------------convolution-------------------------------
convolution#(
   .DATA_WIDTH(DATA_WIDTH)
)conv(
   .clk               (clk                     ), 
   .rst               (rst                     ), 
   .i_valid           (sliding_window_valid_out), 
   .i_data            (sliding_window_data     ), 
   .o_convolved_data  (o_conv_pixel            ), 
   .o_convolved_valid (o_valid                 )
    );
//------------------------------------------------------------------

endmodule
