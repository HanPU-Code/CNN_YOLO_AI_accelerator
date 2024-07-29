module conv_layer #(
    CONV_SIZE = 3 * 3,
    INPUT_CHANNEL = 3,
    NUM_OF_FILTERS = 16
)
(
    input   wire                                                                 clk_i,
    input   wire                                                                 rst_n,
    input   wire  [CONV_SIZE * INPUT_CHANNEL * NUM_OF_FILTERS * 8 - 1:0]         in_data,
    input   wire  [CONV_SIZE * INPUT_CHANNEL * NUM_OF_FILTERS * 8 - 1:0]         in_weight,
    output  reg   [NUM_OF_FILTERS * 8 - 1:0]                                     out_data
);

    localparam DATA_WIDTH = 8;
    localparam CHUNK_SIZE = CONV_SIZE * INPUT_CHANNEL * DATA_WIDTH;
    localparam NUM_CHUNKS = NUM_OF_FILTERS;

    wire [CHUNK_SIZE - 1:0] sliced_in_data[0:NUM_CHUNKS - 1];
    wire [CHUNK_SIZE - 1:0] sliced_in_weight[0:NUM_CHUNKS - 1];
    wire [DATA_WIDTH - 1:0] result[0:NUM_CHUNKS - 1];

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : gen_chunks
            assign sliced_in_data[i] = in_data[(i+1)*CHUNK_SIZE-1:i*CHUNK_SIZE];
            assign sliced_in_weight[i] = in_weight[(i+1)*CHUNK_SIZE-1:i*CHUNK_SIZE];
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : conv_op
            conv_RGB conv_RGB_dut (
                    .clk_i          (clk_i),
                    .rst_n          (rst_n),
                    .rgb_data_i     (sliced_in_data[j]),
                    .rgb_weight_i   (sliced_in_weight[j]),
                    .result_o       (result[j])
            );
        end
    endgenerate

    always @(posedge clk_i) begin
        if (!rst_n) begin
            out_data <= 0;
        end
        else begin
            out_data <= {result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15]
                        };
        end
    end

endmodule