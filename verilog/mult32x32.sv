// 32X32 Iterative Multiplier template
module mult32x32 (
    input logic clk,            // Clock
    input logic reset,          // Reset
    input logic start,          // Start signal
    input logic [31:0] a,       // Input a
    input logic [31:0] b,       // Input b
    output logic busy,          // Multiplier busy indication
    output logic [63:0] product // Miltiplication product
);

// Put your code here
// ------------------

logic a_sel;
logic b_sel;
logic [1:0] shift_sel;
logic upd_prod;
logic clr_prod;

mult32x32_arith arith(
    clk, reset,
    a, b, a_sel, b_sel,
    shift_sel,
    upd_prod, clr_prod,
    product
);

mult32x32_fsm fsm(
    clk, reset,
    start, busy,
    a_sel, b_sel, shift_sel,
    upd_prod, clr_prod
);

// End of your code

endmodule
