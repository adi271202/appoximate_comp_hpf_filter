`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mathuriya 
//////////////////////////////////////////////////////////////////////////////////

(* DONT_TOUCH = "yes" *)
module booth_dadda_9bits(
   input  logic [8:0]  x   ,
   input  logic [8:0]  y   ,
   output logic [17:0] mult 
);

//-------------------signals----------------------
   logic [10:0]a1,a2,a3,a4,a5; 
   logic [46:1] s,c;
   logic [17:0] a_in,b_in; 
//------------------------------------------------
   
//------------------booth's inst------------------
//--ppg
  booth_radix4 inst1 (
      .x    (x),
      .y_q  ({y[1:0],1'b0}),
      .A_out(a1)
   );
     
  booth_radix4 inst2 (
      .x    (x),
      .y_q  (y[3:1]),
      .A_out(a2)
   );
     
  booth_radix4 inst3 (
      .x    (x),
      .y_q  (y[5:3]),
      .A_out(a3)
   );
     
  booth_radix4 inst4 (
      .x    (x),
      .y_q  (y[7:5]),
      .A_out(a4)
     );
     
  booth_radix4 inst5 (
      .x    (x),
      .y_q  ({y[8],y[8],y[7]}),
      .A_out(a5)
   );
//-------------------------------------------------------   

//---------------------dadda-----------------------------
//--ppr

//--stage 1 5->4
   half_adder ha1 (
.a(a1[4]),.b(a2[2]),.cout(c[1]),.s(s[1]));
   
   full_adder fa1 (
.a(a1[5]),.b(a2[3]),.cin(a3[1]),.cout(c[2]),.s(s[2]));
   
   full_adder fa2 (
.a(a1[6]),.b(a2[4]),.cin(a3[2]),.cout(c[3]),.s(s[3]));
   
   full_adder fa3 (
.a(a1[7]),.b(a2[5]),.cin(a3[3]),.cout(c[4]),.s(s[4]));
   
   full_adder fa4 (
.a(a1[8]),.b(a2[6]),.cin(a3[4]),.cout(c[5]),.s(s[5]));
   
   half_adder ha2 (.a(a4[2]),.b(a5[0]),.cout(c[6]),.s(s[6]));
   
   full_adder fa5 (
.a(a1[9]),.b(a2[7]),.cin(a3[5]),.cout(c[7]),.s(s[7]));
   
   half_adder ha3 (.a(a4[3]),.b(a5[1]),.cout(c[8]),.s(s[8]));
   
   full_adder fa6 (
.a(a1[10]),.b(a2[8]),.cin(a3[6]),.cout(c[9]),.s(s[9]));
   
   half_adder ha4 (.a(a4[4]),.b(a5[2]),.cout(c[10]),.s(s[10]));
   
   full_adder fa7 (
.a(a1[10]),.b(a2[9]),.cin(a3[7]),.cout(c[11]),.s(s[11]));
   
   half_adder ha5 (.a(a4[5]),.b(a5[3]),.cout(c[12]),.s(s[12]));
   
   full_adder fa8 (
.a(a1[10]),.b(a2[10]),.cin(a3[8]),.cout(c[13]),.s(s[13]));
   
   half_adder ha6 (.a(a4[6]),.b(a5[4]),.cout(c[14]),.s(s[14]));
   
   full_adder fa9 (
.a(~a1[10]),.b(~a2[10]),.cin(a3[9]),.cout(c[15]),.s(s[15]));
   
   half_adder ha7 (.a(a4[7]),.b(a5[5]),.cout(c[16]),.s(s[16]));
   
   full_adder fa10 (.a(1'b1),.b(a3[10]),.cin(a4[8]),.cout(c[17]),.s(s[17])); 
  
   full_adder fa11 (.a(~a3[10]),.b(a4[9]),.cin(a5[7]),.cout(c[18]),.s(s[18]));
   
   full_adder fa12 (.a(1'b1),.b(a4[10]),.cin(a5[8]),.cout(c[19]),.s(s[19]));
   
   half_adder ha8 (.a(~a4[10]),.b(a5[9]),.cout(c[20]),.s(s[20]));
   
   half_adder ha9 (.a(1'b1),.b(a5[10]),.cout(c[21]),.s(s[21]));


//-stage 4->3
   half_adder ha10 (.a(s[3]),.b(a4[0]),.cout(c[22]),.s(s[22]));  
   
   full_adder fa13 (.a(s[4]),.b(a4[1]),.cin(c[3]),.cout(c[23]),.s(s[23]));
    
   full_adder fa14 (.a(s[5]),.b(s[6]),.cin(c[4]),.cout(c[24]),.s(s[24])); 
   
   full_adder fa15 (.a(s[7]),.b(s[8]),.cin(c[5]),.cout(c[25]),.s(s[25]));
    
   full_adder fa16 (.a(s[9]),.b(s[10]),.cin(c[7]),.cout(c[26]),.s(s[26]));
    
   full_adder fa17 (.a(s[11]),.b(s[12]),.cin(c[9]),.cout(c[27]),.s(s[27]));
    
   full_adder fa18 (.a(s[13]),.b(s[14]),.cin(c[11]),.cout(c[28]),.s(s[28])); 
   
   full_adder fa19 (.a(s[15]),.b(s[16]),.cin(c[13]),.cout(c[29]),.s(s[29]));
    
   full_adder fa20 (.a(s[17]),.b(a5[6]),.cin(c[15]),.cout(c[30]),.s(s[30]));
    
   half_adder ha11 (.a(s[18]),.b(c[17]),.cout(c[31]),.s(s[31])); 
              
   half_adder ha12 (.a(s[19]),.b(c[18]),.cout(c[32]),.s(s[32])); 
   
   half_adder ha13 (.a(s[20]),.b(c[19]),.cout(c[33]),.s(s[33])); 
   
   half_adder ha14 (.a(s[21]),.b(c[20]),.cout(c[34]),.s(s[34])); 
   
   half_adder ha15 (.a(~a5[10]),.b(c[21]),.cout(c[35]),.s(s[35])); 
   
//-stage 3->2

   half_adder ha16 (.a(s[25]),.b(c[24]),.cout(c[36]),.s(s[36])); 
             
   full_adder fa21 (.a(s[26]),.b(c[25]),.cin(c[8]),.cout(c[37]),.s(s[37])); 
             
   full_adder fa22 (.a(s[27]),.b(c[26]),.cin(c[10]),.cout(c[38]),.s(s[38]));
   
   full_adder fa23 (.a(s[28]),.b(c[27]),.cin(c[12]),.cout(c[39]),.s(s[39]));
   
   full_adder fa24 (.a(s[29]),.b(c[28]),.cin(c[14]),.cout(c[40]),.s(s[40]));
   
   full_adder fa25 (.a(s[30]),.b(c[29]),.cin(c[16]),.cout(c[41]),.s(s[41]));
   
   half_adder ha17 (.a(s[31]),.b(c[30]),.cout(c[42]),.s(s[42])); 
   
   half_adder ha18 (.a(s[32]),.b(c[31]),.cout(c[43]),.s(s[43])); 
   
   half_adder ha19 (.a(s[33]),.b(c[32]),.cout(c[44]),.s(s[44])); 
   
   half_adder ha20 (.a(s[34]),.b(c[33]),.cout(c[45]),.s(s[45]));
   
   half_adder ha21 (.a(s[35]),.b(c[34]),.cout(c[46]),.s(s[46]));  
              
//--cla addition 

assign a_in[3:0]   = a1[3:0]; 
assign a_in[5:4]   = s[2:1]; 
assign a_in[8:6]   = s[24:22]; 
assign a_in[17:9]  = s[44:36]; 

assign b_in[1:0]   = 2'b0; 
assign b_in[3:2]   = a2[1:0];
assign b_in[4]     = a3[0]; 
assign b_in[6:5]   = c[2:1]; 
assign b_in[9:7]   = {c[6],c[23:22]}; 
assign b_in[17:10] = c[43:36];  

//------------------------cla exact------------------
//cla #(
//    .BITS(18)
//)cla_final_stage (
//    ._a_in (a_in),
//    ._b_in (b_in),
//    . _c_in(1'b0),
//    ._s_out(mult),
//    ._c_out()
//);

//-----------------------rca half approx half exact-----------
rca rca_half_app (
   .i_a(b_in), 
   .i_b(a_in), 
   .i_c(1'b0), 
   .o_s(mult), 
   .o_c()
    );
   
endmodule
