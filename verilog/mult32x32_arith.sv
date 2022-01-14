// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic a_sel,           // Select one 2-byte word from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [1:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------

logic [15:0] word_a;
logic [15:0] word_b;
logic [63:0] add;

logic [31:0] temp_product;

always_comb begin
    if (a_sel == 1'b1) begin
        word_a[15:0] = a[31:16];
    end else begin
        word_a = a[15:0];
    end

    if (b_sel) begin
        word_b = b[31:16];
    end else begin
        word_b = b[15:0];
    end

    temp_product = word_a * word_b;

    case (shift_sel)
        2'b00: add = temp_product;
        2'b01: add = temp_product << 8;
        2'b10: add = temp_product << 16;
        2'b11: add = temp_product << 24;
    endcase // shift_sel
end // always_comb

always_ff @(posedge clk or posedge reset) begin
    if (reset == 1 || clr_prod == 1) begin
        product <= 64'b0;
    end // if (reset == 1)

    if (upd_prod == 1) begin
        $display("Yay! %d %d", product, add);
        product <= product + add;
    end // if (upd_prod == 1)
end

// End of your code

endmodule
