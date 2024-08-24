module padding_reg (
                input clk,
                input reset,
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
    

reg [1:0] state, next_state;


parameter S0=2'd0;
parameter S1=2'd1;
parameter S2=2'd2;
parameter S3=2'd3;




always @(posedge clk or posedge reset) begin 
    
    if(reset)   state <= S0;

    else        state <= next_state;

end

always @(p_signal or en) begin //next state

    if(en) begin
        case(state)

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

endmodule