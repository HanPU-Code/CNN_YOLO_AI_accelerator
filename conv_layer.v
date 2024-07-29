module conv_layer(
    input wire clk_i,
    input wire rst_n,
    input wire signed [7:0] input_data [0:417*417*3-1], // Flattened input data
    input wire signed [7:0] kernels [0:16*9-1],  // 16 filters, each with 3x3 kernel flattened
    output reg signed [31:0] output_data [0:416*416*16-1] // Flattened output data
);

    wire signed [63:0] conv_result [0:15][0:15];

    integer i, j, f, p;

    // Flattened input data indexing function
    function signed [7:0] get_input_data;
        input integer x;
        input integer y;
        input integer c;
        get_input_data = input_data[(x * 417 + y) * 3 + c];
    endfunction

    // Flattened kernel indexing function
    function signed [7:0] get_kernel_data;
        input integer f;
        input integer idx;
        get_kernel_data = kernels[f * 9 + idx];
    endfunction

    // Flattened output data indexing function
    function signed [31:0] get_output_data;
        input integer x;
        input integer y;
        input integer f;
        get_output_data = output_data[(x * 416 + y) * 16 + f];
    endfunction

    // Instantiate 16 conv modules for 16 positions in parallel
    generate
        for (f = 0; f < 16; f = f + 1) begin : conv_gen
            for (p = 0; p < 16; p = p + 1) begin : pos_gen
                conv conv_inst (
                    .clk_i(clk_i),
                    .rst_n(rst_n),
                    .k_0(get_kernel_data(f, 0)), .k_1(get_kernel_data(f, 1)), .k_2(get_kernel_data(f, 2)),
                    .k_3(get_kernel_data(f, 3)), .k_4(get_kernel_data(f, 4)), .k_5(get_kernel_data(f, 5)),
                    .k_6(get_kernel_data(f, 6)), .k_7(get_kernel_data(f, 7)), .k_8(get_kernel_data(f, 8)),
                    .w_0(get_input_data(i + p / 4, j + p % 4, 0)),
                    .w_1(get_input_data(i + p / 4, j + p % 4 + 1, 0)),
                    .w_2(get_input_data(i + p / 4, j + p % 4 + 2, 0)),
                    .w_3(get_input_data(i + p / 4 + 1, j + p % 4, 0)),
                    .w_4(get_input_data(i + p / 4 + 1, j + p % 4 + 1, 0)),
                    .w_5(get_input_data(i + p / 4 + 1, j + p % 4 + 2, 0)),
                    .w_6(get_input_data(i + p / 4 + 2, j + p % 4, 0)),
                    .w_7(get_input_data(i + p / 4 + 2, j + p % 4 + 1, 0)),
                    .w_8(get_input_data(i + p / 4 + 2, j + p % 4 + 2, 0)),
                    .r_o(conv_result[f][p])
                );

                always @(posedge clk_i or negedge rst_n) begin
                    if (!rst_n) begin
                        output_data[(i + p / 4) * 416 * 16 + (j + p % 4) * 16 + f] <= 0;
                    end else begin
                        output_data[(i + p / 4) * 416 * 16 + (j + p % 4) * 16 + f] <= conv_result[f][p];
                    end
                end
            end
        end
    endgenerate

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            for (f = 0; f < 16; f = f + 1) begin
                for (i = 0; i < 416; i = i + 1) begin
                    for (j = 0; j < 416; j = j + 1) begin
                        output_data[(i * 416 + j) * 16 + f] <= 0;
                    end
                end
            end
        end else begin
            for (i = 0; i < 416; i = i + 4) begin
                for (j = 0; j < 416; j = j + 4) begin
                    // 현재 윈도우에서 16개의 위치에 대한 연산 수행
                    for (p = 0; p < 16; p = p + 1) begin
                        for (f = 0; f < 16; f = f + 1) begin
                            output_data[(i + p / 4) * 416 * 16 + (j + p % 4) * 16 + f] <= conv_result[f][p];
                        end
                    end
                end
            end
        end
    end

endmodule
