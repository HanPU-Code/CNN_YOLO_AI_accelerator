module counter (
                input clk,
                input reset,
                input en,
                output reg [1:0] cycle,
                output reg [8:0] count
);




always @(posedge clk or posedge reset ) begin 

    if(reset)begin
        count<=0;
        cycle<=0;
    end

    else begin
        if(en) begin


            if(cycle>2'd3)
                cycle<=0;

            if(count>9'd415)
                count<=0;
        
            count<=count+1'b1;
            cycle<=cycle+1'b1;
            
        end

        else begin
            count<=0;
            cycle<=0;
        end
    



		end
	end
	
endmodule
