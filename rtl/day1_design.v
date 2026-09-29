//==============================================================
// DAY 1 : ARITHMETIC RTL FROM GATE LEVEL
// File   : day1_design.v
// Language : Verilog-2001
//==============================================================


//==============================================================
// 1. AND GATE
//==============================================================
module and_gate (
    input A,
    input B,
    output Y
);

    assign Y = A & B;

endmodule


//==============================================================
// 2. OR GATE
//==============================================================
module or_gate (
    input A,
    input B,
    output Y
);

    assign Y = A | B;

endmodule


//==============================================================
// 3. NOT GATE
//==============================================================
module not_gate (
    input A,
    output Y
);

    assign Y = ~A;

endmodule


//==============================================================
// 4. NAND GATE
//==============================================================
module nand_gate (
    input A,
    input B,
    output Y
);

    assign Y = ~(A & B);

endmodule


//==============================================================
// 5. NOR GATE
//==============================================================
module nor_gate (
    input A,
    input B,
    output Y
);

    assign Y = ~(A | B);

endmodule


//==============================================================
// 6. XOR GATE
//==============================================================
module xor_gate (
    input A,
    input B,
    output Y
);

    assign Y = A ^ B;

endmodule


//==============================================================
// 7. HALF ADDER
//
// Sum   = A XOR B
// Carry = A AND B
//
// Built using the gate modules above.
//==============================================================
module half_adder (
    input A,
    input B,
    output Sum,
    output Carry
);

    xor_gate XOR1 (
        .A(A),
        .B(B),
        .Y(Sum)
    );

    and_gate AND1 (
        .A(A),
        .B(B),
        .Y(Carry)
    );

endmodule


//==============================================================
// 8. FULL ADDER
//
// Full Adder = Two Half Adders + OR Gate
//
// HA1:
// A + B
//
// HA2:
// HA1 Sum + Cin
//
// Final Carry:
// HA1 Carry OR HA2 Carry
//==============================================================
module full_adder (
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

    wire sum1;
    wire carry1;
    wire carry2;

    half_adder HA1 (
        .A(A),
        .B(B),
        .Sum(sum1),
        .Carry(carry1)
    );

    half_adder HA2 (
        .A(sum1),
        .B(Cin),
        .Sum(Sum),
        .Carry(carry2)
    );

    or_gate OR1 (
        .A(carry1),
        .B(carry2),
        .Y(Cout)
    );

endmodule


//==============================================================
// 9. 4-BIT RIPPLE CARRY ADDER
//
// Four Full Adders are connected together.
//
// A[0] + B[0] -> FA0
// A[1] + B[1] -> FA1
// A[2] + B[2] -> FA2
// A[3] + B[3] -> FA3
//
// Carry ripples from LSB to MSB.
//==============================================================
module ripple_carry_adder_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire C1;
    wire C2;
    wire C3;

    full_adder FA0 (
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),
        .Sum(Sum[0]),
        .Cout(C1)
    );

    full_adder FA1 (
        .A(A[1]),
        .B(B[1]),
        .Cin(C1),
        .Sum(Sum[1]),
        .Cout(C2)
    );

    full_adder FA2 (
        .A(A[2]),
        .B(B[2]),
        .Cin(C2),
        .Sum(Sum[2]),
        .Cout(C3)
    );

    full_adder FA3 (
        .A(A[3]),
        .B(B[3]),
        .Cin(C3),
        .Sum(Sum[3]),
        .Cout(Cout)
    );

endmodule


//==============================================================
// 10. 2:1 MUX
//
// S = 0 -> Y = I0
// S = 1 -> Y = I1
//==============================================================
module mux_2to1 (
    input I0,
    input I1,
    input S,
    output Y
);

    assign Y = S ? I1 : I0;

endmodule


//==============================================================
// 11. 2'S COMPLEMENT
//
// 2's complement = ~B + 1
//
// Four-bit implementation.
//==============================================================
module twos_complement_4bit (
    input [3:0] B,
    output [3:0] Y
);

    assign Y = ~B + 4'b0001;

endmodule


//==============================================================
// 12. 4-BIT SUBTRACTOR
//
// A - B
//
// A - B = A + (~B + 1)
//
// Uses:
//   2's complement of B
//   4-bit Ripple Carry Adder
//==============================================================
module subtractor_4bit (
    input [3:0] A,
    input [3:0] B,
    output [3:0] Difference,
    output Cout
);

    wire [3:0] B_complement;

    twos_complement_4bit TC1 (
        .B(B),
        .Y(B_complement)
    );

    ripple_carry_adder_4bit ADD1 (
        .A(A),
        .B(B_complement),
        .Cin(1'b0),
        .Sum(Difference),
        .Cout(Cout)
    );

endmodule


//==============================================================
// 13. FINAL 4-BIT ADDER / SUBTRACTOR
//
// MODE = 0 -> ADD
//        A + B
//
// MODE = 1 -> SUBTRACT
//        A - B
//
// For subtraction:
//
// B_modified = B XOR MODE
//
// MODE = 0:
// B_modified = B
//
// MODE = 1:
// B_modified = ~B
//
// Cin = MODE
//
// Therefore:
//
// ADD:
// A + B + 0
//
// SUB:
// A + ~B + 1
//==============================================================
module adder_subtractor_4bit (
    input [3:0] A,
    input [3:0] B,
    input MODE,
    output [3:0] RESULT,
    output COUT
);

    wire [3:0] B_modified;

    // Four 2:1 MUXes implemented using XOR control.
    // MODE = 0 -> B
    // MODE = 1 -> ~B

    xor_gate XOR0 (
        .A(B[0]),
        .B(MODE),
        .Y(B_modified[0])
    );

    xor_gate XOR1 (
        .A(B[1]),
        .B(MODE),
        .Y(B_modified[1])
    );

    xor_gate XOR2 (
        .A(B[2]),
        .B(MODE),
        .Y(B_modified[2])
    );

    xor_gate XOR3 (
        .A(B[3]),
        .B(MODE),
        .Y(B_modified[3])
    );

    // Final 4-bit addition.
    ripple_carry_adder_4bit ADD_SUB (
        .A(A),
        .B(B_modified),
        .Cin(MODE),
        .Sum(RESULT),
        .Cout(COUT)
    );

endmodule





