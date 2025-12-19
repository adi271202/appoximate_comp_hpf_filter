`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mahturiya 
//////////////////////////////////////////////////////////////////////////////////


module convolution#(
   DATA_WIDTH =8
)(
   input  logic                   clk               , 
   input  logic                   rst               , 
   input  logic                   i_valid           , 
   input  logic [9*DATA_WIDTH-1:0]i_data            , 
   output logic [DATA_WIDTH-1:0]  o_convolved_data  , 
   output logic                   o_convolved_valid
    );
    
//----------------------signals-------------------
(* dont_touch = "yes" *)
logic signed [8:0][2*DATA_WIDTH-1:0] mult_out; 
logic signed [4:0][16:0]adder_stage1; 
logic signed [2:0][16:0]adder_stage2;
logic signed [1:0][16:0]adder_stage3;
logic signed      [16:0]adder_stage4;
logic             [5:0]valid_d;           
//------------------------------------------------
           
//---------filter coeffs
//   logic signed [DATA_WIDTH-1:0] coeffs[3][3] = '{'{0,-1,0 } ,
//                                                '  {-1,4,-1} ,
//                                                '  {0,-1,0}} ;    
//logic signed [8:0][7:0] coeffs = { -8'sd1, -8'sd1, -8'sd1, -8'sd1, 8'sd8, -8'sd1, -8'sd1,-8'sd1, -8'sd1}; // edge detection 
logic signed [8:0][8:0] coeffs = { 9'sd0, -9'sd1, 9'sd0, -9'sd1, 9'sd5, -9'sd1, 9'sd0,-9'sd1, 9'sd0}; // high pass filter 



//------------------mult inst---------------------
   genvar i; 
   generate 
      for(i=1; i<10; i++) begin 
//         mult_8bits mult_gen(
//         .i_a    (i_data[8*i-1-:8]), 
//         .i_b    (coeffs[9-i]), 
//         .o_mult (mult_out[i-1])
//    );
//-- accurate mults custom 
         booth_dadda_9bits mult_gen(
         .x    ({1'b0,i_data[8*i-1-:8]}), 
         .y    (coeffs[9-i])   , 
         .mult (mult_out[i-1])
    );          

      end
   endgenerate 
//------------------------------------------------

//----------------valid delay---------------------
always @(posedge clk) begin 
   if(rst) begin 
      valid_d <= 'd0; 
   end
   else  begin 
      valid_d[0]   <= i_valid;
      valid_d[4:1] <= valid_d[3:0]; 
   end
end
//------------------------------------------------

//------------------adder tree--------------------
//---------delaying the last one value till end to complete the adder tree
//------------stage1-------------
always @(posedge clk) begin 
   if(i_valid) begin 
      adder_stage1[0] <= mult_out[0] + mult_out[1]; 
      adder_stage1[1] <= mult_out[2] + mult_out[3]; 
      adder_stage1[2] <= mult_out[4] + mult_out[5]; 
      adder_stage1[3] <= mult_out[6] + mult_out[7]; 
      adder_stage1[4] <= mult_out[8]; 
   end
end
//----------stage2-----------------
always @(posedge clk) begin 
   if(valid_d[0]) begin 
      adder_stage2[0] <= adder_stage1[0] + adder_stage1[1]; 
      adder_stage2[1] <= adder_stage1[2] + adder_stage1[3]; 
      adder_stage2[2] <= adder_stage1[4]; 
   end
end
//----------stage3-----------------
always @(posedge clk) begin 
   if(valid_d[1]) begin 
      adder_stage3[0] <= adder_stage2[0] + adder_stage2[1]; 
      adder_stage3[1] <= adder_stage2[2]; 
   end
end
//----------stage4-----------------
always @(posedge clk) begin 
   if(valid_d[2]) begin 
      adder_stage4  <= adder_stage3[0] + adder_stage3[1]; 
   end
end
//--------------------------------------------------

assign o_convolved_valid = valid_d[3]; 

always @(*) begin 
   if(adder_stage4> 255) begin  
      o_convolved_data = 'd255 ;
   end
   else if(adder_stage4<0) begin 
      o_convolved_data = 'd0; 
   end
   else begin 
      o_convolved_data  = (adder_stage4[7:0]); 
   end
end
    
//    assign o_convolved_data = adder_stage4 >> 4;
//    assign o_convolved_data = adder_stage4/9;
//    assign o_convolved_data = adder_stage4;
    
endmodule
