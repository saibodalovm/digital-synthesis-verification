//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    logic [width - 1:0] current_bit;

    always_ff @(posedge clk)
        if (rst) begin
            current_bit <= '0;
            parallel_valid <= '0;
        end
        else begin
            parallel_valid <= 1'b0;
            if (serial_valid) begin
            parallel_data[current_bit] <= serial_data;

            if (current_bit == width-1) begin
                parallel_valid <= '1;
                current_bit <= '0;
            end
            else begin
                current_bit <= current_bit + 1;
            end
        end
        end
endmodule
