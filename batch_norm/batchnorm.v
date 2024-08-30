module batchnorm #(parameter WIDTH = 8, parameter FRACTION_BITS = 8)(
    input wire signed [WIDTH-1:0] x,       // 입력값
    input wire signed [WIDTH-1:0] mean,    // 평균값
    input wire signed [WIDTH-1:0] var,     // 분산값
    input wire signed [WIDTH-1:0] epsilon, // 작은 상수 (epsilon)
    output wire signed [WIDTH-1:0] result  // 결과값
);

    // 중간 결과 저장용 변수
    wire signed [WIDTH-1:0] x_minus_mean;
    wire signed [WIDTH-1:0] var_plus_epsilon;
    wire signed [WIDTH-1:0] sqrt_var_plus_epsilon;
    wire signed [WIDTH*2-1:0] numerator; // (x - mean)
    wire signed [WIDTH*2-1:0] denominator; // sqrt(var + epsilon)

    // x - mean 계산
    assign x_minus_mean = x - mean;

    // var + epsilon 계산
    assign var_plus_epsilon = var + epsilon;

    // sqrt(var + epsilon)를 고정소수점으로 근사 계산 (정확한 sqrt 계산은 복잡하므로 근사치 사용)
    // 예를 들어, 간단한 뉴턴-랩슨 방법이나 테일러 급수를 사용한 근사 계산
    // 여기서는 간단하게 직접 비트 시프트를 사용하여 계산한다고 가정
    assign sqrt_var_plus_epsilon = var_plus_epsilon >> (FRACTION_BITS/2);  // 간단한 sqrt 근사 (비트 시프트)

    // 분자 (numerator) = x - mean
    assign numerator = x_minus_mean;

    // 분모 (denominator) = sqrt(var + epsilon)
    assign denominator = sqrt_var_plus_epsilon;

    // (x - mean) / sqrt(var + epsilon) 계산 (고정소수점 연산에 따른 스케일 조정 포함)
    assign result = (numerator << FRACTION_BITS) / denominator;

endmodule

