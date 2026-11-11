//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module sort_two_floats_ab (
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,

    output logic [FLEN - 1:0] res0,
    output logic [FLEN - 1:0] res1,
    output                    err
);

    logic a_less_or_equal_b;

    f_less_or_equal i_floe (
        .a   ( a                 ),
        .b   ( b                 ),
        .res ( a_less_or_equal_b ),
        .err ( err               )
    );

    always_comb begin : a_b_compare
        if ( a_less_or_equal_b ) begin
            res0 = a;
            res1 = b;
        end
        else
        begin
            res0 = b;
            res1 = a;
        end
    end

endmodule

//----------------------------------------------------------------------------
// Example - different style
//----------------------------------------------------------------------------

module sort_two_floats_array
(
    input        [0:1][FLEN - 1:0] unsorted,
    output logic [0:1][FLEN - 1:0] sorted,
    output                         err
);

    logic u0_less_or_equal_u1;

    f_less_or_equal i_floe
    (
        .a   ( unsorted [0]        ),
        .b   ( unsorted [1]        ),
        .res ( u0_less_or_equal_u1 ),
        .err ( err                 )
    );

    always_comb
        if (u0_less_or_equal_u1)
            sorted = unsorted;
        else
              {   sorted [0],   sorted [1] }
            = { unsorted [1], unsorted [0] };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_three_floats (
    input        [0:2][FLEN - 1:0] unsorted,
    output logic [0:2][FLEN - 1:0] sorted,
    output                         err
);

    logic cmp0_res, cmp1_res, cmp2_res;
    logic err0, err1, err2;

    logic [FLEN - 1:0] st1_low,  st1_high;
    logic [FLEN - 1:0] st2_low;

    f_less_or_equal i_cmp0 (.a(unsorted[0]), .b(unsorted[1]), .res(cmp0_res), .err(err0));
    f_less_or_equal i_cmp1 (.a(st1_high),    .b(unsorted[2]), .res(cmp1_res), .err(err1));
    f_less_or_equal i_cmp2 (.a(st1_low),     .b(st2_low),     .res(cmp2_res), .err(err2));

    assign err = err0 | err1 | err2;

    always_comb begin
        if (cmp0_res) begin
            st1_low  = unsorted[0];
            st1_high = unsorted[1];
        end else begin
            st1_low  = unsorted[1];
            st1_high = unsorted[0];
        end

        if (cmp1_res) begin
            st2_low   = st1_high;
            sorted[2] = unsorted[2];
        end else begin
            st2_low   = unsorted[2];
            sorted[2] = st1_high;
        end

        if (cmp2_res) begin
            sorted[0] = st1_low;
            sorted[1] = st2_low;
        end else begin
            sorted[0] = st2_low;
            sorted[1] = st1_low;
        end
    end

endmodule
