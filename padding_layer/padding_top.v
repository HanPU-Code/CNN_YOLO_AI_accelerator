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
    




reg     [3343:0] R_temp_padded;
reg     [3343:0] G_temp_padded;
reg     [3343:0] B_temp_padded;
wire    [3343:0] R_temp_padded_wire;
wire    [3343:0] G_temp_padded_wire;
wire    [3343:0] B_temp_padded_wire;


wire [1:0] cycle;
wire [8:0] count;




counter counter(
                .clk(clk),
                .reset(reset),
                .en(en),
                .count(count),
                .cycle(cycle)
);

padding padding(
                .clk(clk),
                .reset(reset),
                .en(en),
                .count(count),
                .R_input(R_input),
                .G_input(G_input),
                .B_input(B_input),
                .R_padded(R_temp_padded_wire),
                .G_padded(G_temp_padded_wire),
                .B_padded(B_temp_padded_wire)
);

always @(posedge clk or posedge reset) begin

   if(reset) begin
        R_row0          <=0;
        G_row0          <=0;
        B_row0          <=0;
        R_row1          <=0;
        G_row1          <=0;
        B_row1          <=0;
        R_row2          <=0;
        G_row2          <=0;
        B_row2          <=0;
        R_temp_padded   <=0;
        G_temp_padded   <=0;
        B_temp_padded   <=0;  
    end

    else begin
        if (en) begin
		  
            R_temp_padded <= R_temp_padded_wire;
            G_temp_padded <= G_temp_padded_wire;
            B_temp_padded <= B_temp_padded_wire;
		  
            if(cycle==2'd0) begin

                R_row0 <= R_temp_padded;
                B_row0 <= B_temp_padded;
                G_row0 <= G_temp_padded; 

            end

            else if(cycle==2'd1) begin

                R_row1 <= R_temp_padded;
                G_row1 <= G_temp_padded; 
                B_row1 <= B_temp_padded;
                
            end


            else if(cycle==2'd2) begin
                
                R_row2 <= R_temp_padded;
                G_row2 <= G_temp_padded; 
                B_row2 <= B_temp_padded;
            
            end



        end //end en=1

        else begin //for en=0
            R_row0          <=0;
            G_row0          <=0;
            B_row0          <=0;
            R_row1          <=0;
            G_row1          <=0;
            B_row1          <=0;
            R_row2          <=0;
            G_row2          <=0;
            B_row2          <=0;

            R_temp_padded   <=0;
            G_temp_padded   <=0;
            B_temp_padded   <=0;  
        end

    end //for reset

end //for always module

endmodule