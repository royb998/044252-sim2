// 32X32 Multiplier test template
module mult32x32_fast_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
// ------------------

parameter cycle = 2;

mult32x32_fast mult(
    clk, reset,
    start,
    a, b,
    busy, product
);

initial begin
    clk = 1'b1;
end

always begin
    #(cycle / 2) clk = ~clk;
end

initial begin
    reset = 1;
    start = 0;
    a = 32'h0;
    b = 32'h0;
    #(cycle * 4);

    reset = 0;
    #cycle;

    a = 209161439;
    b = 315075937;
    start = 1;
    #cycle;
    start = 0;
    #(cycle * 4);

    a = a & 32'h0000ffff;
    b = b & 32'h0000ffff;
    start = 1;
    #cycle;
    start = 0;
    #(cycle * 5);
end

// End of your code

endmodule
