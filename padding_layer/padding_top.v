module padding_top (
                input clk,
                input reset,
                input en,

                input [3327:0] R_input,
                input [3327:0] G_input,
                input [3327:0] B_input,

                output reg [3343:0] R_row0, //418x8=3344
                output reg [3343:0] G_row0,
                output reg [3343:0] B_row0,
                 
                output reg [3343:0] R_row1, //418x8=3344
                output reg [3343:0] G_row1,
                output reg [3343:0] B_row1,
                
                output reg [3343:0] R_row2, //418x8=3344
                output reg [3343:0] G_row2,
                output reg [3343:0] B_row2

);
    
wire [3343:0] R_padded;
wire [3343:0] G_padded;
wire [3343:0] B_padded;

wire [1:0] cycle;
wire [8:0] count;
wire p_signal;

counter counter (
                .clk(clk),
                .reset(reset),
                .en(en),
                .p_signal(p_signal),
                .cycle(cycle),
                .count(count)
);

padding padding(
                .clk(clk),
                .reset(reset),
                .en(en),
                .count(count),
                .R_input(R_input),
                .G_input(G_input),
                .B_input(B_input),
                .R_padded(R_padded),
                .G_padded(G_padded),
                .B_padded(B_padded),
                .p_signal(p_signal)
);

always @(posedge clk or posedge reset) begin
   if(reset) begin
        R_row0 <= 0;
        G_row0 <= 0;
        B_row0 <= 0;
        R_row1 <= 0;
        G_row1 <= 0;
        B_row1 <= 0;
        R_row2 <= 0;
        G_row2 <= 0;
        B_row2 <= 0;

    end 
    
    else if (en) begin
        case (cycle)
            2'd0: begin
                R_row0 <= R_padded;
                G_row0 <= G_padded;
                B_row0 <= B_padded;
            end
            2'd1: begin
                R_row1 <= R_padded;
                G_row1 <= G_padded;
                B_row1 <= B_padded;
            end
            2'd2: begin
                R_row2 <= R_padded;
                G_row2 <= G_padded;
                B_row2 <= B_padded;
            end
        endcase
    end 
    
    else begin
        R_row0 <= 0;
        G_row0 <= 0;
        B_row0 <= 0;
        R_row1 <= 0;
        G_row1 <= 0;
        B_row1 <= 0;
        R_row2 <= 0;
        G_row2 <= 0;
        B_row2 <= 0;
    end
end

endmodule
