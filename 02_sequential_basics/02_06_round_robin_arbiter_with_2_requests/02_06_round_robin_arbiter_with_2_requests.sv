//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);

    logic priority_reg;
    logic [1:0] grants_comb;

    always_comb begin
    case (requests)
        2'b00: grants_comb = 2'b00;
        2'b01: grants_comb = 2'b01;
        2'b10: grants_comb = 2'b10;
        2'b11: begin
            if (priority_reg == 1'b0)
                grants_comb = 2'b01;
            else
                grants_comb = 2'b10;
        end
        default: grants_comb = 2'b00;
    endcase
    end

    assign grants = grants_comb;

    always_ff @(posedge clk)
        if (rst)
            priority_reg <= '0;
        else if (grants_comb == 2'b01)
            priority_reg <= 1'b1;
        else if (grants_comb == 2'b10) begin
            priority_reg <= 1'b0;
        end

endmodule
