`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mathuriya  
//////////////////////////////////////////////////////////////////////////////////


module sliding_window #(
   DEPTH      =256, 
   DATA_WIDTH = 8
 )(
   input  logic                   clk     , 
   input  logic                   rst     , 
   input  logic [3*DATA_WIDTH-1:0]i_data  , 
   input  logic                   i_valid , 
   output logic [9*DATA_WIDTH-1:0]o_data  ,
   output logic                   o_valid 
    );

//--------------------singals----------------
   logic [8:0][7:0]data_d; 
   logic [3:0] valid_d;
//-------------------------------------------


always @(posedge clk) begin 
   if(i_valid) begin 
      data_d[2:0] <= i_data;
      data_d[8:3] <= data_d[5:0]; 
   end
end

    
always @(posedge clk) begin 
   if(rst) begin 
      o_data <= 'd0; 
   end
   else begin 
      if(valid_d[3]) begin
         for(int i=1; i<10; i++) begin 
            o_data[DATA_WIDTH*i-1-:DATA_WIDTH] <= data_d[i-1]; 
         end
      end
   end
end

always @(posedge clk) begin 
   valid_d[0] <= i_valid; 
   valid_d[1] <= valid_d[0]; 
   valid_d[2] <= valid_d[1]; 
   valid_d[3] <= valid_d[2]; 
   o_valid    <= valid_d[3]; 
end
    
endmodule
