module padding_top (
                input clk,
                input reset,
                input en,

                input [3327:0] R_input,
                input [3327:0] G_input,
                input [3327:0] B_input,

                output [3343:0] R_row0, //418x8=3344
                output [3343:0] G_row0,
                output [3343:0] B_row0,
                 
                output [3343:0] R_row1, //418x8=3344
                output [3343:0] G_row1,
                output [3343:0] B_row1,
                
                output [3343:0] R_row2, //418x8=3344
                output [3343:0] G_row2,
                output [3343:0] B_row2

);



    
wire [3343:0] R_padded;
wire [3343:0] G_padded;
wire [3343:0] B_padded;

wire p_signal;
wire [8:0] count;




padding padding(
                .clk(clk),
                .reset(reset),
                .en(en),
                .count(count),
                .p_signal(p_signal),
                .R_input(R_input),
                .G_input(G_input),
                .B_input(B_input),
                .R_padded(R_padded),
                .G_padded(G_padded),
                .B_padded(B_padded)

);
 
padding_reg padding_reg (
                .clk(clk),
                .reset(reset),
                .en(en),
                .p_signal(p_signal),

                .R_padded(R_padded),
                .G_padded(G_padded),
                .B_padded(B_padded),

                .R_row0(R_row0), //418x8=3344
                .G_row0(G_row0),
                .B_row0(B_row0),
                 
                .R_row1(R_row1), //418x8=3344
                .G_row1(G_row1),
                .B_row1(B_row1),
                
                .R_row2(R_row2), //418x8=3344
                .G_row2(G_row2),
                .B_row2(B_row2),
                .count(count)

);
   

endmodule