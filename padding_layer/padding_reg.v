`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/26 22:14:06
// Design Name: 
// Module Name: padding_reg
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

// fsm
module padding_reg (
                input clk,
                input rst_n,
                input en,
                input p_signal,

                input [3343:0] R_padded,
                input [3343:0] G_padded,
                input [3343:0] B_padded,

                output reg [3343:0] R_row0, //418x8=3344
                output reg [3343:0] G_row0,
                output reg [3343:0] B_row0,
                 
                output reg [3343:0] R_row1, //418x8=3344
                output reg [3343:0] G_row1,
                output reg [3343:0] B_row1,
                
                output reg [3343:0] R_row2, //418x8=3344
                output reg [3343:0] G_row2,
                output reg [3343:0] B_row2,
                output reg [8:0] count

);
    

reg [1:0] present_state, next_state;
reg [1:0] ctrl;

/*
parameter S0=2'd0;
parameter S1=2'd1;
parameter S2=2'd2;
parameter S3=2'd3;
*/
localparam IDLE = 2'b00;
localparam S1   = 2'b01;
localparam S2   = 2'b11;
localparam S3   = 2'b10;

always @(posedge clk) begin 
    if(!rst_n) begin
        present_state <= IDLE;
    end
    else begin
        present_state <= next_state;
    end
end

/*
always @(*) begin //next state
    if(en) begin
        case(present_state)
            S0  :if(en) //reset state
                    next_state <= S1;
                else
                    next_state <= S0;

            S1  :if(p_signal)
                    next_state <= S2;
                else
                    next_state <= S1;

            S2  :if(p_signal)
                    next_state <= S3;
                else
                    next_state <= S2;

            S3  :if(p_signal)
                    next_state <= S1;
                else
                    next_state <= S3;
        endcase
    end
end
*/

    always @(*) begin
        case (present_state)
            IDLE: begin
                if (en) begin
                    next_state = S1;
                end
                else begin
                    next_state = IDLE;
                end
            end
            S1: begin
                if (ctrl == 1) begin
                    next_state = S2;
                end
                else begin
                    next_state = S1;
                end
            end
            S2: begin
                if (ctrl == 2) begin
                    next_state = S3;
                end
                else begin
                    next_state = S2;
                end
            end
            S3: begin
                if (ctrl == 3) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = S3;
                end
            end
            default: begin
                next_state = IDLE;
            end
            // DONE signal 만들어야할 듯.
        endcase
    end

/*
always @(state) begin               //processing
    
    case(state)
        
        S0  :begin
                R_row0 <= 0;
                G_row0 <= 0;
                B_row0 <= 0;
                count  <= 0;
            end
        
        S1  :begin
                R_row0 <= R_padded;
                G_row0 <= G_padded;
                B_row0 <= B_padded;
                count  <= count+1'b1;
            end

        S2  :begin
                R_row1 <= R_padded;
                G_row1 <= G_padded;
                B_row1 <= B_padded;
                count  <= count+1'b1;
            end
        
        S3  :begin
                R_row2 <= R_padded;
                G_row2 <= G_padded;
                B_row2 <= B_padded;
                count  <= count+1'b1;
            end

    endcase
    
	 if(count==9'd416)
		count<=0;


end
*/

    always @(posedge clk) begin
        if (!rst_n) begin
            R_row0 <= 0;
            G_row0 <= 0;
            B_row0 <= 0;
            R_row1 <= 0;
            G_row1 <= 0;
            B_row1 <= 0;
            R_row2 <= 0;
            G_row2 <= 0;
            B_row2 <= 0;
            count  <= 0;
            ctrl   <= 0;
        end
        else begin
            case (present_state)
                IDLE: begin
                    R_row0 <= 0;
                    G_row0 <= 0;
                    B_row0 <= 0;
                    R_row1 <= 0;
                    G_row1 <= 0;
                    B_row1 <= 0;
                    R_row2 <= 0;
                    G_row2 <= 0;
                    B_row2 <= 0;
                    count  <= 0;
                    ctrl   <= 0;
                end 
                S1: begin
                    R_row0 <= R_padded;
                    G_row0 <= G_padded;
                    B_row0 <= B_padded;
                    R_row1 <= 0;
                    G_row1 <= 0;
                    B_row1 <= 0;
                    R_row2 <= 0;
                    G_row2 <= 0;
                    B_row2 <= 0;
                    // count  <= count + 1'b1;
                    if (count == 9'd416) begin
                        count <= 0;
                        ctrl  <= ctrl + 1;  // 1
                    end
                    else begin
                        count <= count + 1;
                    end
                end
                S2: begin
                    R_row0 <= 0;
                    G_row0 <= 0;
                    B_row0 <= 0;
                    R_row1 <= R_padded;
                    G_row1 <= G_padded;
                    B_row1 <= B_padded;
                    R_row2 <= 0;
                    G_row2 <= 0;
                    B_row2 <= 0;
                    count  <= count + 1'b1;
                    if (count == 9'd416) begin
                        count <= 0;
                        ctrl  <= ctrl + 1;  // 2
                    end
                end
                S3: begin
                    R_row0 <= 0;
                    G_row0 <= 0;
                    B_row0 <= 0;
                    R_row1 <= 0;
                    G_row1 <= 0;
                    B_row1 <= 0;
                    R_row2 <= R_padded;
                    G_row2 <= G_padded;
                    B_row2 <= B_padded;
                    count  <= count + 1'b1;
                    if (count == 9'd416) begin
                        count <= 0;
                        ctrl  <= ctrl + 1;
                    end
                end
                default: begin
                    R_row0 <= 0;
                    G_row0 <= 0;
                    B_row0 <= 0;
                    R_row1 <= 0;
                    G_row1 <= 0;
                    B_row1 <= 0;
                    R_row2 <= 0;
                    G_row2 <= 0;
                    B_row2 <= 0;
                    count  <= 0;
                    ctrl   <= 0;
                end
            endcase
        end
    end

endmodule
