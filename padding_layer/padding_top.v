module padding_top (
                input clk,
                input reset,
                input en,

                input [51:0] R_input,
                input [51:0] G_input,
                input [51:0] B_input,

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
    



reg [51:0]   R_temp_normal;
reg [51:0]   G_temp_normal;
reg [51:0]   B_temp_normal;
reg [67:0]   R_temp_padded;
reg [67:0]   G_temp_padded;
reg [67:0]   B_temp_padded;


wire [51:0] R_temp_normal_wire; 
wire [51:0] G_temp_normal_wire;
wire [51:0] B_temp_normal_wire;
wire [67:0] R_temp_padded_wire;
wire [67:0] G_temp_padded_wire;
wire [67:0] B_temp_padded_wire;



wire [3:0] count;
wire [8:0] cycle;



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
                .cycle(cycle),
                .R_input(R_input),
                .G_input(G_input),
                .B_input(B_input),
                .R_normal(R_temp_normal_wire),
                .G_normal(G_temp_normal_wire),
                .B_normal(B_temp_normal_wire),
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

        R_temp_normal   <=0;
        G_temp_normal   <=0;
        B_temp_normal   <=0;
        R_temp_padded   <=0;
        G_temp_padded   <=0;
        B_temp_padded   <=0;  
    end

    else begin
        if (en) begin
		  
		    R_temp_normal <= R_temp_normal_wire;
            G_temp_normal <= G_temp_normal_wire;
            B_temp_normal <= B_temp_normal_wire;
            R_temp_padded <= R_temp_padded_wire;
            G_temp_padded <= G_temp_padded_wire;
            B_temp_padded <= B_temp_padded_wire;
		  
            if(cycle<9'd7) begin
                if(count==4'd0) begin
                    R_row0 <= {R_row0[3343:68], R_temp_padded}<<68;
                    B_row0 <= {B_row0[3343:68], B_temp_padded}<<68;
                    G_row0 <= {G_row0[3343:68], G_temp_padded}<<68; 
                end

                else if(count>4'd0 && count<4'd7) begin
                    R_row0 <= {R_row0[3343:53], R_temp_normal}<<52;
                    G_row0 <= {B_row0[3343:53], G_temp_normal}<<52; 
                    B_row0 <= {G_row0[3343:53], B_temp_normal}<<52;
                end

                else if(count==4'd7) begin
                    R_row0 <= {R_row0[3343:68], R_temp_padded};
                    G_row0 <= {B_row0[3343:68], G_temp_padded};
                    B_row0 <= {G_row0[3343:68], B_temp_padded};
                end
            end

            else if(cycle>=9'd7 && cycle<=9'd15) begin
                if(count==4'd0) begin
                    R_row1 <= {R_row1[3343:68], R_temp_padded}<<68;
                    G_row1 <= {G_row1[3343:68], G_temp_padded}<<68; 
                    B_row1 <= {B_row1[3343:68], B_temp_padded}<<68;
                end

                else if(count>4'd0 && count<4'd7) begin
                    R_row1 <= {R_row1[3343:52], R_temp_normal}<<52;
                    G_row1 <= {G_row1[3343:52], G_temp_normal}<<52; 
                    B_row1 <= {B_row1[3343:52], B_temp_normal}<<52;
                end

                else if(count==4'd7) begin
                    R_row1 <= {R_row1[3343:68], R_temp_padded};
                    G_row1 <= {B_row1[3343:68], G_temp_padded};
                    B_row1 <= {G_row1[3343:68], B_temp_padded};
                end
            end

            else if(cycle>9'd15 && cycle<=9'd23) begin
                if(count==4'd0) begin
                    R_row2 <= {R_row2[3343:68], R_temp_padded}<<68;
                    G_row2 <= {G_row2[3343:68], G_temp_padded}<<68; 
                    B_row2 <= {B_row2[3343:68], B_temp_padded}<<68;
                end

                else if(count>4'd0 && count<4'd7) begin
                    R_row2 <= {R_row2[3343:52], R_temp_normal}<<52;
                    G_row2 <= {G_row2[3343:52], G_temp_normal}<<52; 
                    B_row2 <= {B_row2[3343:52], B_temp_normal}<<52;
                end

                else if(count==4'd7) begin
                    R_row2 <= {R_row2[3343:68], R_temp_padded};
                    G_row2 <= {B_row2[3343:68], G_temp_padded};
                    B_row2 <= {G_row2[3343:68], B_temp_padded};
                end
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

            R_temp_normal   <=0;
            G_temp_normal   <=0;
            B_temp_normal   <=0;
            R_temp_padded   <=0;
            G_temp_padded   <=0;
            B_temp_padded   <=0;  
        end

    end //for reset

end //for always module

endmodule