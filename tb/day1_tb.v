//==============================================================
// DAY 1 : COMPLETE VERIFICATION
// File : day1_tb.v
//==============================================================

module day1_tb;


    //==========================================================
    // SIGNALS FOR GATES
    //==========================================================

    reg A;
    reg B;

    wire and_y;
    wire or_y;
    wire nand_y;
    wire nor_y;
    wire xor_y;
    wire not_y;


    //==========================================================
    // GATE INSTANCES
    //==========================================================

    and_gate AND1 (
        .A(A),
        .B(B),
        .Y(and_y)
    );

    or_gate OR1 (
        .A(A),
        .B(B),
        .Y(or_y)
    );

    nand_gate NAND1 (
        .A(A),
        .B(B),
        .Y(nand_y)
    );

    nor_gate NOR1 (
        .A(A),
        .B(B),
        .Y(nor_y)
    );

    xor_gate XOR1 (
        .A(A),
        .B(B),
        .Y(xor_y)
    );

    not_gate NOT1 (
        .A(A),
        .Y(not_y)
    );


    //==========================================================
    // SIGNALS FOR HALF ADDER
    //==========================================================

    wire HA_Sum;
    wire HA_Carry;

    half_adder HA1 (
        .A(A),
        .B(B),
        .Sum(HA_Sum),
        .Carry(HA_Carry)
    );


    //==========================================================
    // SIGNALS FOR FULL ADDER
    //==========================================================

    reg Cin;

    wire FA_Sum;
    wire FA_Cout;

    full_adder FA1 (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(FA_Sum),
        .Cout(FA_Cout)
    );


    //==========================================================
    // SIGNALS FOR 4-BIT ADDER
    //==========================================================

    reg [3:0] A4;
    reg [3:0] B4;
    reg Cin4;

    wire [3:0] Sum4;
    wire Cout4;

    ripple_carry_adder_4bit RCA1 (
        .A(A4),
        .B(B4),
        .Cin(Cin4),
        .Sum(Sum4),
        .Cout(Cout4)
    );


    //==========================================================
    // SIGNALS FOR MUX
    //==========================================================

    reg I0;
    reg I1;
    reg S;

    wire MUX_Y;

    mux_2to1 MUX1 (
        .I0(I0),
        .I1(I1),
        .S(S),
        .Y(MUX_Y)
    );


    //==========================================================
    // SIGNALS FOR 2'S COMPLEMENT
    //==========================================================

    reg [3:0] TC_B;

    wire [3:0] TC_Y;

    twos_complement_4bit TC1 (
        .B(TC_B),
        .Y(TC_Y)
    );


    //==========================================================
    // SIGNALS FOR SUBTRACTOR
    //==========================================================

    wire [3:0] Difference;
    wire Sub_Cout;

    subtractor_4bit SUB1 (
        .A(A4),
        .B(B4),
        .Difference(Difference),
        .Cout(Sub_Cout)
    );


    //==========================================================
    // SIGNALS FOR FINAL ADDER/SUBTRACTOR
    //==========================================================

    reg MODE;

    wire [3:0] Result;
    wire Final_Cout;

    adder_subtractor_4bit DUT (
        .A(A4),
        .B(B4),
        .MODE(MODE),
        .RESULT(Result),
        .COUT(Final_Cout)
    );


    //==========================================================
    // TEST
    //==========================================================

    initial begin

        $display("=================================================");
        $display("       DAY 1 ARITHMETIC RTL VERIFICATION");
        $display("=================================================");


        //======================================================
        // 1. GATE VERIFICATION
        //======================================================

        $display("");
        $display("---- 1. GATE VERIFICATION ----");

        A = 0;
        B = 0;
        #10;

        if (and_y == 0 &&
            or_y   == 0 &&
            nand_y == 1 &&
            nor_y  == 1 &&
            xor_y  == 0 &&
            not_y  == 1)
            $display("GATE TEST 00 : PASS");
        else
            $display("GATE TEST 00 : FAIL");


        A = 0;
        B = 1;
        #10;

        if (and_y == 0 &&
            or_y   == 1 &&
            nand_y == 1 &&
            nor_y  == 0 &&
            xor_y  == 1 &&
            not_y  == 1)
            $display("GATE TEST 01 : PASS");
        else
            $display("GATE TEST 01 : FAIL");


        A = 1;
        B = 0;
        #10;

        if (and_y == 0 &&
            or_y   == 1 &&
            nand_y == 1 &&
            nor_y  == 0 &&
            xor_y  == 1 &&
            not_y  == 0)
            $display("GATE TEST 10 : PASS");
        else
            $display("GATE TEST 10 : FAIL");


        A = 1;
        B = 1;
        #10;

        if (and_y == 1 &&
            or_y   == 1 &&
            nand_y == 0 &&
            nor_y  == 0 &&
            xor_y  == 0 &&
            not_y  == 0)
            $display("GATE TEST 11 : PASS");
        else
            $display("GATE TEST 11 : FAIL");


        //======================================================
        // 2. HALF ADDER VERIFICATION
        //======================================================

        $display("");
        $display("---- 2. HALF ADDER VERIFICATION ----");

        A = 0;
        B = 0;
        #10;

        if (HA_Sum == 0 && HA_Carry == 0)
            $display("HA 00 : PASS");
        else
            $display("HA 00 : FAIL");


        A = 0;
        B = 1;
        #10;

        if (HA_Sum == 1 && HA_Carry == 0)
            $display("HA 01 : PASS");
        else
            $display("HA 01 : FAIL");


        A = 1;
        B = 0;
        #10;

        if (HA_Sum == 1 && HA_Carry == 0)
            $display("HA 10 : PASS");
        else
            $display("HA 10 : FAIL");


        A = 1;
        B = 1;
        #10;

        if (HA_Sum == 0 && HA_Carry == 1)
            $display("HA 11 : PASS");
        else
            $display("HA 11 : FAIL");


        //======================================================
        // 3. FULL ADDER VERIFICATION
        //======================================================

        $display("");
        $display("---- 3. FULL ADDER VERIFICATION ----");

        A = 0;
        B = 0;
        Cin = 0;
        #10;

        if (FA_Sum == 0 && FA_Cout == 0)
            $display("FA 000 : PASS");
        else
            $display("FA 000 : FAIL");


        A = 0;
        B = 0;
        Cin = 1;
        #10;

        if (FA_Sum == 1 && FA_Cout == 0)
            $display("FA 001 : PASS");
        else
            $display("FA 001 : FAIL");


        A = 0;
        B = 1;
        Cin = 0;
        #10;

        if (FA_Sum == 1 && FA_Cout == 0)
            $display("FA 010 : PASS");
        else
            $display("FA 010 : FAIL");


        A = 0;
        B = 1;
        Cin = 1;
        #10;

        if (FA_Sum == 0 && FA_Cout == 1)
            $display("FA 011 : PASS");
        else
            $display("FA 011 : FAIL");


        A = 1;
        B = 0;
        Cin = 0;
        #10;

        if (FA_Sum == 1 && FA_Cout == 0)
            $display("FA 100 : PASS");
        else
            $display("FA 100 : FAIL");


        A = 1;
        B = 0;
        Cin = 1;
        #10;

        if (FA_Sum == 0 && FA_Cout == 1)
            $display("FA 101 : PASS");
        else
            $display("FA 101 : FAIL");


        A = 1;
        B = 1;
        Cin = 0;
        #10;

        if (FA_Sum == 0 && FA_Cout == 1)
            $display("FA 110 : PASS");
        else
            $display("FA 110 : FAIL");


        A = 1;
        B = 1;
        Cin = 1;
        #10;

        if (FA_Sum == 1 && FA_Cout == 1)
            $display("FA 111 : PASS");
        else
            $display("FA 111 : FAIL");


        //======================================================
        // 4. 4-BIT RIPPLE CARRY ADDER
        //======================================================

        $display("");
        $display("---- 4. 4-BIT ADDER VERIFICATION ----");


        // 5 + 3 = 8
        A4 = 4'b0101;
        B4 = 4'b0011;
        Cin4 = 0;
        #10;

        if (Sum4 == 4'b1000 && Cout4 == 0)
            $display("RCA 5 + 3 : PASS");
        else
            $display("RCA 5 + 3 : FAIL");


        // 15 + 1 = 16
        A4 = 4'b1111;
        B4 = 4'b0001;
        Cin4 = 0;
        #10;

        if (Sum4 == 4'b0000 && Cout4 == 1)
            $display("RCA 15 + 1 : PASS");
        else
            $display("RCA 15 + 1 : FAIL");


        // 0 + 0 = 0
        A4 = 4'b0000;
        B4 = 4'b0000;
        Cin4 = 0;
        #10;

        if (Sum4 == 4'b0000 && Cout4 == 0)
            $display("RCA 0 + 0 : PASS");
        else
            $display("RCA 0 + 0 : FAIL");


        // 9 + 6 = 15
        A4 = 4'b1001;
        B4 = 4'b0110;
        Cin4 = 0;
        #10;

        if (Sum4 == 4'b1111 && Cout4 == 0)
            $display("RCA 9 + 6 : PASS");
        else
            $display("RCA 9 + 6 : FAIL");


        //======================================================
        // 5. MUX VERIFICATION
        //======================================================

        $display("");
        $display("---- 5. MUX VERIFICATION ----");

        I0 = 0;
        I1 = 1;
        S = 0;
        #10;

        if (MUX_Y == 0)
            $display("MUX S=0 : PASS");
        else
            $display("MUX S=0 : FAIL");


        I0 = 0;
        I1 = 1;
        S = 1;
        #10;

        if (MUX_Y == 1)
            $display("MUX S=1 : PASS");
        else
            $display("MUX S=1 : FAIL");


        I0 = 1;
        I1 = 0;
        S = 0;
        #10;

        if (MUX_Y == 1)
            $display("MUX 10 S=0 : PASS");
        else
            $display("MUX 10 S=0 : FAIL");


        I0 = 1;
        I1 = 0;
        S = 1;
        #10;

        if (MUX_Y == 0)
            $display("MUX 10 S=1 : PASS");
        else
            $display("MUX 10 S=1 : FAIL");


        //======================================================
        // 6. 2'S COMPLEMENT VERIFICATION
        //======================================================

        $display("");
        $display("---- 6. 2'S COMPLEMENT VERIFICATION ----");


        // 2's complement of 0000 = 0000
        TC_B = 4'b0000;
        #10;

        if (TC_Y == 4'b0000)
            $display("TC of 0000 : PASS");
        else
            $display("TC of 0000 : FAIL");


        // 2's complement of 0001 = 1111
        TC_B = 4'b0001;
        #10;

        if (TC_Y == 4'b1111)
            $display("TC of 0001 : PASS");
        else
            $display("TC of 0001 : FAIL");


        // 2's complement of 0011 = 1101
        TC_B = 4'b0011;
        #10;

        if (TC_Y == 4'b1101)
            $display("TC of 0011 : PASS");
        else
            $display("TC of 0011 : FAIL");


        // 2's complement of 0101 = 1011
        TC_B = 4'b0101;
        #10;

        if (TC_Y == 4'b1011)
            $display("TC of 0101 : PASS");
        else
            $display("TC of 0101 : FAIL");


        //======================================================
        // 7. 4-BIT SUBTRACTOR
        //======================================================

        $display("");
        $display("---- 7. 4-BIT SUBTRACTOR VERIFICATION ----");


        // 5 - 3 = 2
        A4 = 4'b0101;
        B4 = 4'b0011;
        #10;

        if (Difference == 4'b0010 && Sub_Cout == 1)
            $display("SUB 5 - 3 : PASS");
        else
            $display("SUB 5 - 3 : FAIL");


        // 10 - 4 = 6
        A4 = 4'b1010;
        B4 = 4'b0100;
        #10;

        if (Difference == 4'b0110 && Sub_Cout == 1)
            $display("SUB 10 - 4 : PASS");
        else
            $display("SUB 10 - 4 : FAIL");


        // 15 - 15 = 0
        A4 = 4'b1111;
        B4 = 4'b1111;
        #10;

        if (Difference == 4'b0000 && Sub_Cout == 1)
            $display("SUB 15 - 15 : PASS");
        else
            $display("SUB 15 - 15 : FAIL");


        // 3 - 5 = -2 = 1110
        A4 = 4'b0011;
        B4 = 4'b0101;
        #10;

        if (Difference == 4'b1110 && Sub_Cout == 0)
            $display("SUB 3 - 5 : PASS");
        else
            $display("SUB 3 - 5 : FAIL");


        //======================================================
        // 8. FINAL ADDER/SUBTRACTOR
        //======================================================

        $display("");
        $display("---- 8. FINAL ADDER/SUBTRACTOR ----");


        // ADD: 5 + 3 = 8
        A4 = 4'b0101;
        B4 = 4'b0011;
        MODE = 0;
        #10;

        if (Result == 4'b1000 && Final_Cout == 0)
            $display("FINAL ADD 5 + 3 : PASS");
        else
            $display("FINAL ADD 5 + 3 : FAIL");


        // ADD: 15 + 1 = 16
        A4 = 4'b1111;
        B4 = 4'b0001;
        MODE = 0;
        #10;

        if (Result == 4'b0000 && Final_Cout == 1)
            $display("FINAL ADD 15 + 1 : PASS");
        else
            $display("FINAL ADD 15 + 1 : FAIL");


        // ADD: 7 + 2 = 9
        A4 = 4'b0111;
        B4 = 4'b0010;
        MODE = 0;
        #10;

        if (Result == 4'b1001 && Final_Cout == 0)
            $display("FINAL ADD 7 + 2 : PASS");
        else
            $display("FINAL ADD 7 + 2 : FAIL");


        // SUB: 5 - 3 = 2
        A4 = 4'b0101;
        B4 = 4'b0011;
        MODE = 1;
        #10;

        if (Result == 4'b0010 && Final_Cout == 1)
            $display("FINAL SUB 5 - 3 : PASS");
        else
            $display("FINAL SUB 5 - 3 : FAIL");


        // SUB: 10 - 4 = 6
        A4 = 4'b1010;
        B4 = 4'b0100;
        MODE = 1;
        #10;

        if (Result == 4'b0110 && Final_Cout == 1)
            $display("FINAL SUB 10 - 4 : PASS");
        else
            $display("FINAL SUB 10 - 4 : FAIL");


        // SUB: 3 - 5 = -2 = 1110
        A4 = 4'b0011;
        B4 = 4'b0101;
        MODE = 1;
        #10;

        if (Result == 4'b1110 && Final_Cout == 0)
            $display("FINAL SUB 3 - 5 : PASS");
        else
            $display("FINAL SUB 3 - 5 : FAIL");


        // SUB: 15 - 15 = 0
        A4 = 4'b1111;
        B4 = 4'b1111;
        MODE = 1;
        #10;

        if (Result == 4'b0000 && Final_Cout == 1)
            $display("FINAL SUB 15 - 15 : PASS");
        else
            $display("FINAL SUB 15 - 15 : FAIL");


        //======================================================
        // FINISH
        //======================================================

        $display("");
        $display("=================================================");
        $display("       DAY 1 VERIFICATION COMPLETED");
        $display("=================================================");

        $finish;

    end

endmodule
