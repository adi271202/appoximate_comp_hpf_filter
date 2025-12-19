`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mathuriya 
//////////////////////////////////////////////////////////////////////////////////


module rca(
   input  logic [17:0] i_a, 
   input  logic [17:0] i_b, 
   input  logic        i_c, 
   output logic [17:0] o_s, 
   output logic        o_c
    );
    
// for this 18 bit adder, MSB 9 bits will utilize 
// accurate fa and LSB 9 bits will utliize approx fa 

//-----------------------signals-------------------
genvar i,k; 
logic  [18:0] w_c; 
//-------------------------------------------------

assign w_c[0] = i_c; 

generate 
   for (i=1; i<=9; i++) begin 
      fa_approx fa_app_gen (.a(i_a[i-1]),.b(i_b[i-1]),.cin(w_c[i-1]),.s(o_s[i-1]),.cout(w_c[i])); 
//      full_adder fa_app_gen (.a(i_a[i-1]),.b(i_b[i-1]),.cin(w_c[i-1]),.s(o_s[i-1]),.cout(w_c[i])); 
   end
   for (k=10; k<=18; k++) begin 
      fa_approx fa_gen (.a(i_a[k-1]),.b(i_b[k-1]),.cin(w_c[k-1]),.s(o_s[k-1]),.cout(w_c[k])); 
//      full_adder fa_gen (.a(i_a[k-1]),.b(i_b[k-1]),.cin(w_c[k-1]),.s(o_s[k-1]),.cout(w_c[k])); 
   end
endgenerate   

assign o_c = w_c[18];  
endmodule
