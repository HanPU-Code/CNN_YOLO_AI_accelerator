module padding (
                input clk,
                input reset,
                input en,
                input [3:0] count,
                input [8:0] cycle,

                input [51:0] R_input,
                input [51:0] G_input,
                input [51:0] B_input,

                output reg [51:0] R_normal,
                output reg [51:0] G_normal,
                output reg [51:0] B_normal,
                output reg [67:0] R_padded,
                output reg [67:0] G_padded,
                output reg [67:0] B_padded

);

always @(posedge clk or posedge reset) begin // for reset

    if(reset) begin
        R_normal <= 0;
        G_normal <= 0;
        B_normal <= 0;
        R_padded <= 0;
        G_padded <= 0;
        B_padded <= 0;
	end

	else begin

    if(cycle == 9'd0 || cycle == 9'd415) begin //for first and last rows
        R_padded <= 0;
        G_padded <= 0;
        B_padded <= 0; 
    end

    else begin //mid rows

        if(count==4'd0) begin
            R_padded <= {8'b0, R_input};
            G_padded <= {8'b0, G_input};
            B_padded <= {8'b0, B_input};
        end

        else if(count>4'd0 && count<4'd7) begin
            R_normal <= {R_input};
            G_normal <= {G_input};
            B_normal <= {B_input};
        end

        if(count==4'd7) begin
            R_padded <= {R_input, 8'b0};
            G_padded <= {G_input, 8'b0};
            B_padded <= {B_input, 8'b0};
        end
    end

end

end
    
endmodule

