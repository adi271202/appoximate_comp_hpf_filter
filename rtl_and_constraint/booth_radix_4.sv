`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mathuriya 
//////////////////////////////////////////////////////////////////////////////////

module booth_radix4(
    input  logic [8:0]  x    ,
    input  logic [2:0]  y_q  ,
    output logic [10:0] A_out
    );

//----------------signals-----------------    

    logic  signed [10:0]A;
    logic         [9:0] A_sum  ;
    logic         [10:0]A_2sum ;
    logic         [9:0] A_sub  ;
    logic         [10:0]A_2sub ;


  assign A_sum   =  {x[8],x[8],x} ;
  assign A_2sum  =  {x[8],x,1'b0} ;
  assign A_sub   =  ~A_sum  + 1'b1;
  assign A_2sub  =  ~A_2sum + 1'b1;

//-----------------booth--------------------
    always_comb  begin 
       case (y_q) 
          3'b000 , 3'b111 : begin 
             A = 'd0;
          end 
          3'b001 , 3'b010 : begin 
             A = $signed(A_sum);
          end 
          3'b011 : begin 
             A = $signed(A_2sum);
          end 
          3'b100 : begin 
             A = $signed(A_2sub);
          end 
          3'b101,3'b110 :begin 
             A = $signed(A_sub);
       end 
       endcase 
    end 
    assign A_out=A;
endmodule
