module counter (
                input clk,
                input reset,
                input en,

                output reg [3:0] count,
                output reg [8:0] cycle
);




always @(posedge clk or posedge reset ) begin 

    if(reset)begin
        cycle<=0;
        count<=0;
    end

    else begin
        if(en) begin
            count<=count+1'b1;
        end

        else begin
            count<=0;
            cycle<=0;
        end
    

        if(count==4'd7) begin
            count<=0;
            cycle<=cycle+1'b1;
        end


		end
	end
	
endmodule
