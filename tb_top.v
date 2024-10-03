`timescale 1ns/1ps
`define headerSize 1080 
`define imageSize 416*416*3  // Each pixel now has 3 bytes (R, G, B)

module tb();

    reg clk;
    reg reset;
    reg [7:0] imgDataR, imgDataG, imgDataB;
    integer file, file1, file2, i;
    reg imgDataValid;
    integer sentSize;
    // We have to write code here about output signal to testbench...
    wire intr;  // This is control signal interrupt.
    wire outDataValid;
    integer receivedData = 0;

    initial begin
        clk = 1'b0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        reset = 0;
        sentSize = 0;
        imgDataValid = 0;
        #100;
        reset = 1;
        #100;
        file = $fopen("image_416x416_rgb.bmp", "rb");  // 파일명에 맞게 수정
        file1 = $fopen("lined_image_416x416_rgb.bmp", "wb");
        file2 = $fopen("imageData.h", "w");

        // Copy header
        for(i = 0; i < `headerSize; i = i + 1) begin
            $fscanf(file, "%c", imgDataR);  // 헤더는 imgDataR로 처리
            $fwrite(file1, "%c", imgDataR);
        end

        // Process image data (RGB)
        for(i = 0; i < 4 * 416 * 3; i = i + 3) begin
            @(posedge clk);
            $fscanf(file, "%c%c%c", imgDataR, imgDataG, imgDataB);  // R, G, B 읽기
            $fwrite(file2, "%0d,%0d,%0d,", imgDataR, imgDataG, imgDataB);
            imgDataValid <= 1'b1;
        end

        sentSize = 4 * 416 * 3;
        @(posedge clk);
        imgDataValid <= 1'b0;

        while(sentSize < `imageSize) begin
            @(posedge intr);
            for(i = 0; i < 416 * 3; i = i + 3) begin
                @(posedge clk);
                $fscanf(file, "%c%c%c", imgDataR, imgDataG, imgDataB);  // R, G, B 읽기
                $fwrite(file2, "%0d,%0d,%0d,", imgDataR, imgDataG, imgDataB);
                imgDataValid <= 1'b1;
            end
            @(posedge clk);
            imgDataValid <= 1'b0;
            sentSize = sentSize + 416 * 3;
        end

        @(posedge clk);
        imgDataValid <= 1'b0;

        // 패딩 처리 (필요시 0으로 채움)
        @(posedge intr);
        for(i = 0; i < 416 * 3; i = i + 3) begin
            @(posedge clk);
            imgDataR <= 0;
            imgDataG <= 0;
            imgDataB <= 0;
            imgDataValid <= 1'b1;
            $fwrite(file2, "%0d,%0d,%0d,", 0, 0, 0);
        end
        @(posedge clk);
        imgDataValid <= 1'b0;

        $fclose(file);
        $fclose(file2);
    end

    always @(posedge clk) begin
        if(outDataValid) begin
            $fwrite(file1, "%c", outData);
            receivedData = receivedData + 1;
        end
        if(receivedData == `imageSize) begin
            $fclose(file1);
            $stop;
        end
    end

    top dut(
        // our module
    );

endmodule