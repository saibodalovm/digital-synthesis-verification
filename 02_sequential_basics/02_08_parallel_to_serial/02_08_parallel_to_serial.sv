//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module parallel_to_serial
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      parallel_valid,
    input        [width - 1:0] parallel_data,

    output                     busy,
    output logic               serial_valid,
    output logic               serial_data
);
    logic [width-1:0] current_bit;
    logic [width-1:0] data_reg;
    logic busy_reg;

    always_ff @(posedge clk)
        if (rst) begin
            data_reg <= '0;
            busy_reg <= '0;
            current_bit <= '0;
        end
        else if (busy_reg) begin
            if (current_bit + 1 == width) begin
                busy_reg <= '0;
                current_bit <= '0;
            end
            else 
                current_bit <= current_bit + 1;
        end
        else if (parallel_valid) begin
            data_reg <= parallel_data;
            busy_reg <= '1;
            current_bit <= 1;
        end

    assign serial_valid = parallel_valid | busy;
    assign serial_data = busy ? data_reg[current_bit] : parallel_data[0];
    assign busy = busy_reg;

endmodule
