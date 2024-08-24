module padding (
                input clk,
                input reset,
                input en,
                input [8:0] count,


                input [3327:0] R_input,
                input [3327:0] G_input,
                input [3327:0] B_input,

                output reg [3343:0] R_padded,
                output reg [3343:0] G_padded,
                output reg [3343:0] B_padded,
					 
				output reg p_signal
					 



);



always @(posedge clk or posedge reset) begin // for reset

    if(reset) begin
        R_padded <= 0;
        G_padded <= 0;
        B_padded <= 0;
        p_signal <= 0;


	end

	else begin

        if(en) begin

            if(count==9'd0 || count==9'd415)  begin
                R_padded <= 0;
                G_padded <= 0;
                B_padded <= 0;
                p_signal <= p_signal + 1'b1;
            end


            else begin
                R_padded <= {8'b0, R_input, 8'b0};
                G_padded <= {8'b0, G_input, 8'b0};
                B_padded <= {8'b0, B_input, 8'b0};
                p_signal <= p_signal + 1'b1;

            end

            
				
        end

    end

end
    
endmodule

