# 4-bit Adder/Subtractor --- RTL Design & Verification

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Domain](https://img.shields.io/badge/Domain-Digital%20VLSI-orange)
![Design](https://img.shields.io/badge/Design-4--bit%20Adder%2FSubtractor-green)
![Tool](https://img.shields.io/badge/Synthesis-Cadence%20Genus-red)

## Project Information

  Item           Details
  -------------- ----------------------------------
  Project        Day 1
  Design Title   `adder_subtractor_4bit`
  Domain         Digital VLSI / RTL Design
  HDL            Verilog HDL
  Design Type    Combinational Arithmetic Circuit
  Verification   Directed RTL Testbench
  Synthesis      Cadence Genus
  Library        `tsmc18`
  Top Module     `adder_subtractor_4bit`

------------------------------------------------------------------------

## 1. Project Overview

This project implements and verifies a **4-bit binary adder/subtractor**
using structural Verilog HDL.

The design supports two arithmetic operations selected by the `MODE`
input:

-   `MODE = 0` → 4-bit addition
-   `MODE = 1` → 4-bit subtraction using two's-complement arithmetic

The project was developed through an RTL-to-synthesis flow covering:

**Specification → RTL Design → Testbench → Simulation → Waveform
Verification → Gate-Level Verification → Synthesis → Hierarchy → Area →
Power → Timing Analysis**

------------------------------------------------------------------------

## 2. Design Objective

The objectives of this project are:

-   Understand hierarchical RTL design.
-   Implement basic logic gates using Verilog.
-   Build a half adder from XOR and AND gates.
-   Build a full adder from two half adders and an OR gate.
-   Construct a 4-bit ripple-carry adder.
-   Implement addition/subtraction using conditional inversion of
    operand `B`.
-   Develop a directed functional verification testbench.
-   Analyze the synthesized RTL hierarchy.
-   Obtain synthesis area, power, and timing reports using Cadence
    Genus.
-   Understand the relationship between RTL hierarchy and synthesized
    standard-cell implementation.

------------------------------------------------------------------------

## 3. Functional Specification

### Inputs

  Signal     Width Description
  -------- ------- ------------------
  `A`        4-bit First operand
  `B`        4-bit Second operand
  `MODE`     1-bit Operation select

### Outputs

  Signal       Width Description
  ---------- ------- -----------------------------------------
  `RESULT`     4-bit Arithmetic result
  `COUT`       1-bit Carry-out / arithmetic carry indication

### Operation Table

    MODE Operation     Function
  ------ ------------- ----------
     `0` Addition      `A + B`
     `1` Subtraction   `A - B`

------------------------------------------------------------------------

## 4. Arithmetic Architecture

The top-level implementation uses XOR gates to conditionally invert `B`.

The implemented equation is:

\[ RESULT = A + (B `\oplus `{=tex}MODE) + MODE \]

Therefore:

### Addition

For `MODE = 0`:

\[ B\_{modified}=B \]

\[ RESULT=A+B \]

### Subtraction

For `MODE = 1`:

\[ B\_{modified}=`\overline{B}`{=tex} \]

\[ RESULT=A+`\overline{B}`{=tex}+1 \]

which implements:

\[ A-B=A+`\overline{B}`{=tex}+1 \]

------------------------------------------------------------------------

## 5. RTL Architecture

The RTL is organized hierarchically.

``` text
adder_subtractor_4bit
│
├── XOR0
├── XOR1
├── XOR2
├── XOR3
│
└── ADD_SUB
    │
    └── ripple_carry_adder_4bit
        │
        ├── FA0
        │   ├── HA1
        │   │   ├── XOR
        │   │   └── AND
        │   ├── HA2
        │   │   ├── XOR
        │   │   └── AND
        │   └── OR
        │
        ├── FA1
        ├── FA2
        └── FA3
```

The final top-level architecture contains:

-   4 XOR gates for conditional inversion of `B`
-   4 full adders for the 4-bit ripple-carry adder
-   Each full adder contains:
    -   2 half adders
    -   1 OR gate
-   Each half adder contains:
    -   1 XOR gate
    -   1 AND gate

------------------------------------------------------------------------

## 6. RTL Modules

The source RTL contains the following modules:

-   `and_gate`
-   `or_gate`
-   `not_gate`
-   `nand_gate`
-   `nor_gate`
-   `xor_gate`
-   `half_adder`
-   `full_adder`
-   `ripple_carry_adder_4bit`
-   `mux_2to1`
-   `twos_complement_4bit`
-   `subtractor_4bit`
-   `adder_subtractor_4bit`

The final synthesized top module is:

``` text
adder_subtractor_4bit
```

The final top-level implementation directly instantiates the four XOR
gates and the ripple-carry adder.

------------------------------------------------------------------------

## 7. Verification Environment

The project uses a directed Verilog testbench:

``` text
day1_tb.v
```

The testbench instantiates and verifies the RTL hierarchy, including:

-   Basic logic gates
-   Half adder
-   Full adder
-   4-bit ripple-carry adder
-   2:1 multiplexer
-   4-bit two's-complement block
-   4-bit subtractor
-   Final 4-bit adder/subtractor

The testbench uses `$display` statements and conditional `if/else`
checks to report `PASS` or `FAIL`.

------------------------------------------------------------------------

## 8. Test Cases

  Block                        Test Cases
  -------------------------- ------------
  Basic Gates                           4
  Half Adder                            4
  Full Adder                            8
  4-bit Ripple-Carry Adder              4
  2:1 MUX                               4
  4-bit Two's Complement                4
  4-bit Subtractor                      4
  Final Adder/Subtractor                7

### Full Adder Verification

The full adder is tested for all eight possible combinations of:

``` text
A, B, Cin
```

This provides exhaustive combinational testing for the 1-bit full-adder
block.

### Final Adder/Subtractor Verification

The top-level design is tested for both addition and subtraction,
including cases such as:

``` text
5 + 3
15 + 1
7 + 2

5 - 3
10 - 4
3 - 5
15 - 15
```

The top-level test cases are directed functional tests and are **not
exhaustive for all 4-bit input combinations**.

------------------------------------------------------------------------

## 9. Verification Status

-   [x] RTL simulation
-   [x] Directed functional testing
-   [x] Waveform inspection
-   [x] Synthesis
-   [x] Synthesized hierarchy analysis
-   [x] Area analysis
-   [x] Power analysis
-   [x] Timing-path analysis
-   [ ] Functional coverage analysis
-   [ ] Formal verification
-   [ ] Constrained-random verification
-   [ ] UVM verification

> Coverage analysis, formal verification, constrained-random
> verification, and UVM are not claimed for this project unless
> corresponding evidence is added to the repository.

------------------------------------------------------------------------

## 10. Synthesis

### Synthesis Tool

**Cadence Genus Synthesis Solution**

Reported tool version:

``` text
Genus(TM) Synthesis Solution 21.14-s082_1
```

### Top Module

``` text
adder_subtractor_4bit
```

### Operating Condition

``` text
slow (balanced_tree)
```

### Wireload Mode

``` text
enclosed
```

------------------------------------------------------------------------

## 11. Synthesized Design Hierarchy

The Genus hierarchy report confirms the following synthesized structure:

``` text
adder_subtractor_4bit
│
├── ADD_SUB
│   └── ripple_carry_adder_4bit
│       ├── FA0
│       ├── FA1
│       ├── FA2
│       └── FA3
│
├── XOR0
├── XOR1
├── XOR2
└── XOR3
```

Each full adder is synthesized as:

``` text
Full Adder
├── HA1
│   ├── AND
│   └── XOR
├── HA2
│   ├── AND
│   └── XOR
└── OR
```

The synthesized hierarchy matches the intended RTL architecture.

------------------------------------------------------------------------

## 12. Area Analysis

The Genus cell-area report gives:

  Cell Type     Instances   Reported Area
  ----------- ----------- ---------------
  `AND2X1`              8         106.445
  `OR2X1`               3          39.917
  `OR2XL`               1          13.306
  `XOR2XL`             12         319.334
  **Total**        **24**     **479.002**

### Area Summary

-   Total synthesized cell instances: **24**
-   Total reported area: **479.002 library area units**
-   Logic area: **479.002**
-   Physical-cell area: **0**

The unit of `479.002` should not be labeled as `µm²` unless the
corresponding `tsmc18` library documentation explicitly defines the
reported area in square micrometers.

### Hierarchical Area

  Hierarchy                   Cells   Reported Area
  ------------------------- ------- ---------------
  `adder_subtractor_4bit`        24         479.002
  `ADD_SUB` / 4-bit RCA          20         372.557
  `FA0`                           5          93.139
  `FA1`                           5          93.139
  `FA2`                           5          93.139
  `FA3`                           5          93.139
  Top-level XOR gates             4       106.445\*

\*The individual XOR contribution is represented by the four `XOR2XL`
cells in the cell-area report.

The synthesized design therefore consists of:

\[ 4 XOR + 4(2 XOR + 2 AND + 1 OR)=24 cells \]

------------------------------------------------------------------------

## 13. Power Analysis

The Genus power report was generated for:

``` text
PDB Frame: /stim#0/frame#0
Power Unit: W
```

  Power Component             Value (W)    Value (µW)   Percentage
  ----------------- ------------------- ------------- ------------
  Leakage                 `2.33863e-08`   `0.0233863`        0.12%
  Internal                `1.44756e-05`     `14.4756`       75.05%
  Switching               `4.78905e-06`     `4.78905`       24.83%
  **Total**           **`1.92881e-05`**   **19.2881**     **100%**

### Power Observation

The reported total power is:

\[ P\_{total}=1.92881`\times10`{=tex}\^{-5} W \]

or:

\[ P\_{total}=19.2881 `\mu `{=tex}W \]

The reported power is dominated by internal power, followed by switching
power.

Power results are dependent on the stimulus, technology library
characterization, operating conditions, and synthesis/power-analysis
configuration.

------------------------------------------------------------------------

## 14. Timing Analysis

The Genus timing report contains the following path:

  Parameter             Reported Value
  --------------------- ------------------------
  Path Type             **UNCONSTRAINED**
  Startpoint            `B[0]`
  Endpoint              `COUT`
  Data Path             `2352 ps`
  Data Path             `2.352 ns`
  Operating Condition   `slow (balanced_tree)`

The reported path represents carry propagation through:

``` text
FA0 → FA1 → FA2 → FA3 → COUT
```

### Reported Delay

\[ 2352 ps = 2.352 ns \]

### Timing Interpretation

The `2.352 ns` value is the reported data-path delay for the displayed
unconstrained path.

Because the path is reported as **UNCONSTRAINED**, this report should
**not** be used to claim:

-   Timing closure
-   Setup slack
-   Hold slack
-   Maximum operating frequency
-   A valid clock period

A proper clock-constrained timing analysis would be required before
making those claims.

------------------------------------------------------------------------

## 15. RTL-to-Synthesis Correlation

The synthesized implementation corresponds directly to the RTL
hierarchy.

### RTL

``` text
adder_subtractor_4bit
 ├── 4 × XOR
 └── ripple_carry_adder_4bit
      └── 4 × full_adder
```

### Synthesized Cell Structure

``` text
4 × XOR
+
4 × full_adder

Each full_adder:
2 × XOR
2 × AND
1 × OR
```

Therefore:

``` text
4 top-level XOR
+ 4 × (2 XOR + 2 AND + 1 OR)
= 12 XOR + 8 AND + 4 OR
= 24 cells
```

This matches the Genus cell-area report.

------------------------------------------------------------------------

## 16. Simulation and Waveform

The repository contains simulation and waveform evidence for the RTL
design.

Recommended image placement:

``` text
images/
├── rtl_waveform.png
└── gate_level_waveform.png
```

Example waveform checks should demonstrate:

-   Addition mode
-   Subtraction mode
-   Result transitions
-   Carry-out behavior
-   Correct response to input changes

------------------------------------------------------------------------

## 17. Gate-Level Verification

Gate-level verification should be documented using the synthesized
netlist and corresponding gate-level simulation results.

The repository should contain the actual gate-level waveform/report
evidence used for this claim.

``` text
simulation/
└── gate_level/
```

> The RTL testbench itself does not prove gate-level verification.
> Gate-level verification is claimed only when the synthesized netlist
> has actually been simulated and the corresponding evidence is
> included.

------------------------------------------------------------------------

## 18. Repository Structure

``` text
Day-1/
│
├── README.md
│
├── rtl/
│   └── day1_design.v
│
├── tb/
│   └── day1_tb.v
│
├── simulation/
│   ├── rtl_simulation/
│   ├── waveform/
│   └── gate_level/
│
├── synthesis/
│   ├── genus/
│   ├── hierarchy/
│   ├── area/
│   ├── power/
│   └── timing/
│
├── reports/
│   ├── area_report.txt
│   ├── cell_area_report.txt
│   ├── hierarchy_report.txt
│   ├── power_report.txt
│   └── timing_report.txt
│
├── images/
│   ├── rtl_waveform.png
│   ├── gate_level_waveform.png
│   ├── synthesis_hierarchy.png
│   ├── area.png
│   ├── power.png
│   └── timing.png
│
├── docs/
│   └── project_report.pdf
│
└── src/
    └── adder_subtractor_4bit.v
```

Adjust filenames and folders to match the actual files uploaded to the
repository.

------------------------------------------------------------------------

## 19. Tools and Technologies

### HDL

-   Verilog HDL

### Simulation / Verification

-   RTL simulation
-   Directed testbench
-   Waveform analysis
-   Gate-level simulation, where applicable

### Synthesis / Analysis

-   Cadence Genus Synthesis Solution `21.14-s082_1`
-   `tsmc18` standard-cell library
-   Area analysis
-   Power analysis
-   Timing-path analysis
-   Hierarchy analysis

------------------------------------------------------------------------

## 20. Key Learning Outcomes

Through this project, the following concepts were practiced:

-   Structural Verilog design
-   Combinational logic design
-   Half-adder and full-adder architecture
-   Ripple-carry addition
-   Two's-complement subtraction
-   Hierarchical RTL design
-   Directed functional verification
-   Waveform-based debugging
-   RTL-to-gate synthesis
-   Standard-cell mapping
-   Hierarchy inspection
-   Area analysis
-   Power analysis
-   Timing-path analysis
-   RTL-to-synthesis correlation

------------------------------------------------------------------------

## 21. Design Considerations

### Ripple-Carry Architecture

The design uses a ripple-carry adder. Carry information propagates from
the least significant full adder toward the most significant full adder.

Therefore, the critical path can include multiple full-adder stages.

### Conditional Operand Inversion

The XOR gates implement:

``` text
MODE = 0 → B_modified = B
MODE = 1 → B_modified = ~B
```

The same `MODE` signal is also applied as the carry-in to implement the
`+1` required for two's-complement subtraction.

------------------------------------------------------------------------

## 22. Limitations

The current Day-1 implementation has the following scope:

-   Ripple-carry architecture has serial carry propagation.
-   Top-level directed tests are not exhaustive.
-   No UVM environment is included.
-   No constrained-random verification is included.
-   No formal verification is included.
-   Coverage analysis is not claimed without corresponding evidence.
-   Timing is reported for an unconstrained path; timing closure is not
    claimed.
-   Area units should be interpreted according to the technology library
    definition.

------------------------------------------------------------------------

## 23. Possible Future Improvements

Potential extensions include:

-   Exhaustive top-level functional verification
-   SystemVerilog assertions
-   Functional coverage
-   Constrained-random verification
-   UVM-based verification
-   Clock-constrained timing analysis
-   Comparison with carry-lookahead architecture
-   Comparison with carry-select architecture
-   PPA comparison between different adder architectures
-   FPGA implementation and resource analysis

------------------------------------------------------------------------

## 24. Interview Discussion Points

### Q1. How does the design perform subtraction?

It uses two's-complement arithmetic:

\[ A-B=A+`\overline{B}`{=tex}+1 \]

### Q2. Why is XOR used before the ripple-carry adder?

The XOR gates conditionally invert `B` according to `MODE`.

### Q3. Why is `MODE` connected to the adder carry-in?

When `MODE=1`, it supplies the `+1` required by two's-complement
subtraction.

### Q4. What is the main timing limitation of the architecture?

The ripple-carry structure requires carry propagation through multiple
full-adder stages.

### Q5. What did synthesis produce?

The reported implementation contains **24 standard-cell instances** with
a reported area of **479.002 library area units**.

### Q6. What is the reported power?

The Genus report gives a total power of:

\[ 19.2881 `\mu `{=tex}W \]

for the reported stimulus frame.

### Q7. What timing value was reported?

The displayed unconstrained path from `B[0]` to `COUT` has a reported
data-path delay of:

\[ 2.352 ns \]

------------------------------------------------------------------------

## 25. Project Status

**Day 1 --- Completed RTL Design and Initial RTL-to-Synthesis Analysis**

Current evidence includes:

-   RTL design
-   Directed testbench
-   Functional verification
-   Waveform analysis
-   Synthesized hierarchy
-   Cell-area report
-   Power report
-   Timing-path report

Additional verification claims should be added only when the
corresponding evidence is included in the repository.

------------------------------------------------------------------------

## 26. Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering\
SDM Institute of Technology, Ujire, Karnataka

### Portfolio

-   GitHub: `Omkar-hadapad`
-   LinkedIn: `omkar-kalmesh-hadapad`

------------------------------------------------------------------------

## 27. License

This project is intended for academic, learning, portfolio, and
educational purposes.
