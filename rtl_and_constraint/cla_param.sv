`timescale 1ns / 1ps
// Author : Aditya Mathuriya 

module cla #(
    parameter BITS = 32
)(
    input  logic  [BITS - 1:0] _a_in,
    input  logic  [BITS - 1:0] _b_in,
    input  logic  _c_in,
    output logic  [BITS - 1:0] _s_out,
    output logic  _c_out
);
    // Propagate / Generate
    wire [BITS - 1:0] w_prop;
    assign w_prop[BITS - 1:0] = _a_in[BITS - 1:0] ^ _b_in[BITS - 1:0];

    wire [BITS - 1:0] w_gen;
    assign w_gen[BITS - 1:0] = _a_in[BITS - 1:0] & _b_in[BITS - 1:0];

    wire [BITS:0] w_carry;

    assign w_carry[0] = _c_in; // Sets w_carry[0] = _c_in

    // Carry Lookahead Unit
    genvar carryBitIndex;
    generate
        for (carryBitIndex = 1; carryBitIndex <= BITS; carryBitIndex = carryBitIndex + 1)
        begin
            wire [carryBitIndex:0] components;

            assign components[0] = w_gen[carryBitIndex - 1];

            genvar i;
            for (i = 1; i < carryBitIndex; i = i + 1)
            begin
                assign components[i] = w_gen[carryBitIndex - i - 1] & &w_prop[carryBitIndex - 1 : carryBitIndex - i];
            end
            assign components[carryBitIndex] = w_carry[0] & &w_prop[carryBitIndex - 1:0];


            assign w_carry[carryBitIndex] = |components;

        end
    endgenerate

    // Assigning outputs
    assign _s_out[BITS - 1:0] = w_prop[BITS - 1:0] ^ w_carry[BITS - 1:0];
    assign _c_out = w_carry[BITS];
endmodule