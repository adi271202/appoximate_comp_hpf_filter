`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mathuriya 
//////////////////////////////////////////////////////////////////////////////////


module mult_8bits(
   input  logic        [7:0] i_a    ,  // unsigned
   input  logic signed [7:0] i_b    ,  // signed
   output logic signed [15:0] o_mult
);
    
    always_comb begin
        // Cast i_a to signed to ensure proper signed multiplication
        o_mult = $signed({1'b0, i_a}) * i_b;  // 9-bit signed * 8-bit signed = 17-bit signed
    end

endmodule

