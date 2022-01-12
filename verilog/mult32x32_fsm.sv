// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic a_sel,           // Select one 2-byte word from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [1:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);


typedef enum  { start, st1, st2, st3, st4 } state;
// Put your code here
// ------------------
state cur_state;
state next_state;

always_ff @(posedge clk, posedge reset) begin
    if(reset == 1'b1) begin
        cur_state <= start;
    end
    else begin
        cur_state <= next_state;
    end
end

always_comb begin
    next_state = cur_state;
    if(reset = 1'b1) begin
        clr_prod = 1'b1;
        a_sel = 1'b0;
        b_sel = 1'b0;
        shift_sel = 2'b00;
        upd_prod = 1'b0;
        busy = 1'b0;
    end
    else begin
        clr_prod = 1'b0;
    end
    case(cur_state)
        start: begin
            if (start == 1'b1) begin
                next_state = st1;
                busy = 1'b1;
                a_sel = 1'b0;
                b_sel = 1'b0;
                shift_sel = 2'b00;
                upd_prod = 1'b1;
                clr_prod = 1'b1;
            end
        end
        st1: begin
            next_state = st2;
            a_sel = 1'b0;
            b_sel = 1'b1;
            shift_sel = 2'b01;
            upd_prod = 1'b1;
            clr_prod = 1'b0;
        end
        st2: begin
            next_state = st3;
            a_sel = 1'b1;
            b_sel = 1'b0;
            shift_sel = 2'b01;
        end
        st3:begin
            next_state = st4;
            a_sel = 1'b1;
            b_sel = 1'b1;
            shift_sel = 2'b10;
        end
        st4:begin
            next_state = start;
            a_sel = 1'b0;
            b_sel = 1'b0;
            shift_sel = 2'b00;
            upd_prod = 1'b0;
            busy = 1'b0;
        end
        default:
    endcase
end

// Put your code here
// ------------------

// End of your code

endmodule
