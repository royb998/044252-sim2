// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msw_is_0,       // Indicates MSW of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic a_sel,           // Select one 2-byte word from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [1:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

typedef enum  { st0, st1, st2, st3, st4 } state;
// Put your code here
// ------------------
state cur_state;
state next_state;

always_ff @(posedge clk, posedge reset) begin
    if(reset == 1'b1) begin
        cur_state <= st0;
    end
    else begin
        cur_state <= next_state;
    end
end

always_comb begin
    next_state = cur_state;
    if(reset == 1'b1) begin
        next_state = st0;
        clr_prod = 1'b1;
        a_sel = 1'b0;
        b_sel = 1'b0;
        shift_sel = 2'b00;
        upd_prod = 1'b0;
        busy = 1'b0;
    end else begin
        clr_prod = 1'b0;
        a_sel = 1'b0;
        b_sel = 1'b0;
        shift_sel = 2'b00;
        upd_prod = 1'b0;
        busy = 1'b0;
    end

    case(cur_state)
        st0: begin
            if (start == 1'b1) begin
                next_state = st1;
                busy = 1'b0;
                a_sel = 1'b0;
                b_sel = 1'b0;
                shift_sel = 2'b00;
                upd_prod = 1'b0;
                clr_prod = 1'b1;
            end 
            else if (reset == 1'b1) begin
                next_state = cur_state;
                clr_prod = 1'b1;
            end
            else begin
                next_state = cur_state;
                busy = 1'b0;
                a_sel = 1'b0;
                b_sel = 1'b0;
                shift_sel = 2'b00;
                upd_prod = 1'b0;
                clr_prod = 1'b0;
            end
        end
        st1: begin
        if ((a_msw_is_0 == 1'b1) &&(b_msw_is_0 == 1'b1)) begin
            next_state = st0;                
            a_sel = 1'b0;
            b_sel = 1'b0;
            shift_sel = 2'b00;
            busy = 1'b1;
            upd_prod = 1'b1;
            clr_prod = 1'b0;
        end else if(b_msw_is_0 == 1'b1) begin
            next_state = st4;
            a_sel = 1'b1;
            b_sel = 1'b0;
            shift_sel = 2'b01;
            busy = 1'b1;
            upd_prod = 1'b1;
            clr_prod = 1'b0;
        end else if(a_msw_is_0 == 1'b1) begin
            next_state = st3;
            a_sel = 1'b0;
            b_sel = 1'b1;
            shift_sel = 2'b01;
            busy = 1'b1;
            upd_prod = 1'b1;
            clr_prod = 1'b0;
        end else begin
            next_state = st2;
            a_sel = 1'b1;
            b_sel = 1'b1;
            shift_sel = 2'b10;
            busy = 1'b1;
            upd_prod = 1'b1;
            clr_prod = 1'b0;
        end
        end

        st2: begin
            next_state = st3;
            a_sel = 1'b0;
            b_sel = 1'b1;
            shift_sel = 2'b01;
        end

        st3:begin
            next_state = st4;
            a_sel = 1'b1;
            b_sel = 1'b0;
            shift_sel = 2'b01;
        end

        st4:begin
            next_state = st0;
            a_sel = 1'b0;
            b_sel = 1'b0;
            shift_sel = 2'b00;
        end
        
    endcase

end

// Put your code here
// ------------------

// End of your code

endmodule
