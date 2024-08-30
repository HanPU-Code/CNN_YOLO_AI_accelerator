module make_mean(
    input unsigned [127:0] avg_in,
    output unsigned [7:0]	avg_mean 
    );

	wire	[11:0]	avg_sum	;
	wire	[11:0]	temp	;

	 assign avg_sum = avg_in[7:0]    +  // 첫 번째 8비트
                     avg_in[15:8]   +  // 두 번째 8비트
                     avg_in[23:16]  +  // 세 번째 8비트
                     avg_in[31:24]  +  // 네 번째 8비트
                     avg_in[39:32]  +  // 다섯 번째 8비트
                     avg_in[47:40]  +  // 여섯 번째 8비트
                     avg_in[55:48]  +  // 일곱 번째 8비트
                     avg_in[63:56]  +  // 여덟 번째 8비트
                     avg_in[71:64]  +  // 아홉 번째 8비트
                     avg_in[79:72]  +  // 열 번째 8비트
                     avg_in[87:80]  +  // 열한 번째 8비트
                     avg_in[95:88]  +  // 열두 번째 8비트
                     avg_in[103:96] +  // 열세 번째 8비트
                     avg_in[111:104]+  // 열네 번째 8비트
                     avg_in[119:112]+  // 열다섯 번째 8비트
                     avg_in[127:120];  // 열여섯 번째 8비트
	assign	temp =	avg_sum >> 4	;
	assign	avg_mean = temp[7:0]	;
 
endmodule
