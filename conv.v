`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/25 12:09:25
// Design Name: 
// Module Name: conv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conv(
    input   wire                            clk_i,
    input   wire                            rst_n,

    input   wire    signed      [7:0]       k_0,
    input   wire    signed      [7:0]       k_1,
    input   wire    signed      [7:0]       k_2,
    input   wire    signed      [7:0]       k_3,
    input   wire    signed      [7:0]       k_4,
    input   wire    signed      [7:0]       k_5,
    input   wire    signed      [7:0]       k_6,
    input   wire    signed      [7:0]       k_7,
    input   wire    signed      [7:0]       k_8,

    input   wire    signed      [7:0]       w_0,
    input   wire    signed      [7:0]       w_1,
    input   wire    signed      [7:0]       w_2,
    input   wire    signed      [7:0]       w_3,
    input   wire    signed      [7:0]       w_4,
    input   wire    signed      [7:0]       w_5,
    input   wire    signed      [7:0]       w_6,
    input   wire    signed      [7:0]       w_7,
    input   wire    signed      [7:0]       w_8,

    output  reg     signed      [63:0]      r_o
    );

    wire    signed  [31:0]      t [8:0];

    mul mul_t0  (
        .A      (k_0),
        .B      (w_0),
        .O      (t[0])
    );

    mul mul_t1  (
        .A      (k_1),
        .B      (w_1),
        .O      (t[1])
    );

    mul mul_t2  (
        .A      (k_2),
        .B      (w_2),
        .O      (t[2])
    );

    mul mul_t3  (
        .A      (k_3),
        .B      (w_3),
        .O      (t[3])
    );

    mul mul_t4  (
        .A      (k_4),
        .B      (w_4),
        .O      (t[4])
    );

    mul mul_t5  (
        .A      (k_5),
        .B      (w_5),
        .O      (t[5])
    );

    mul mul_t6  (
        .A      (k_6),
        .B      (w_6),
        .O      (t[6])
    );

    mul mul_t7  (
        .A      (k_7),
        .B      (w_7),
        .O      (t[7])
    );

    mul mul_t8  (
        .A      (k_8),
        .B      (w_8),
        .O      (t[8])
    );

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            r_o <= 0;
        end
        else begin
            r_o <= t[0] + t[1] + t[2] + t[3] + t[4] + t[5] + t[6] + t[7] + t[8];
        end
    end
    
endmodule
