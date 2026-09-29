from pathlib import Path

readme = r"""# Day 1 — 4-Bit Adder/Subtractor

<p align="center">
  <b>Digital VLSI • Verilog RTL • Functional Verification • Cadence Genus</b>
</p>

<p align="center">
  <code>RTL → Simulation → Waveform → Synthesis → Hierarchy → Area → Power → Timing</code>
</p>

---

## 1. Project Overview

This is **Day 1** of a structured **Digital VLSI / RTL Design training project series**.

The project implements a hierarchical **4-bit Adder/Subtractor** in **Verilog HDL** and takes the design through an RTL-to-synthesis analysis flow.

### Main Design

```text
adder_subtractor_4bit

The design supports:

4-bit binary addition
4-bit binary subtraction
Two's-complement subtraction
Structural RTL hierarchy
Directed functional verification
RTL waveform verification
Cadence Genus synthesis
Synthesized hierarchy analysis
Cell-area analysis
Power analysis
Timing-path analysis
Engineering Flow
Specification
     │
     ▼
RTL Architecture
     │
     ▼
Verilog RTL
     │
     ▼
Testbench
     │
     ▼
RTL Simulation
     │
     ├── Console Verification
     └── Waveform Verification
     │
     ▼
Cadence Genus Synthesis
     │
     ├── Hierarchy
     ├── Cell Area
     ├── Power
     └── Timing
2. Project Information
Parameter	Details
Project	Day 1
Design	adder_subtractor_4bit
Domain	Digital VLSI / RTL Design
HDL	Verilog HDL
Design Type	Combinational Arithmetic Circuit
Top Module	adder_subtractor_4bit
Architecture	4-bit Ripple-Carry Adder with Conditional B Inversion
Verification	Directed RTL Testbench
Synthesis Tool	Cadence Genus Synthesis Solution
Genus Version	21.14-s082_1
Technology Library	tsmc18
Operating Condition	slow (balanced_tree)
Wireload Mode	enclosed
3. Objectives

The project was developed to build practical understanding of:

Structural Verilog design
Hierarchical RTL architecture
Logic-gate implementation
Half-adder design
Full-adder design
Ripple-carry addition
Two's-complement subtraction
Arithmetic datapath design
Directed functional verification
RTL waveform analysis
RTL-to-gate synthesis
Standard-cell mapping
Hierarchy analysis
Area analysis
Power analysis
Timing-path analysis
RTL-to-synthesis correlation

The goal is not only to write Verilog, but to understand:

Specification
      ↓
Hardware Architecture
      ↓
RTL
      ↓
Verification
      ↓
Synthesis
      ↓
PPA Analysis
      ↓
Engineering Interpretation
4. Functional Specification
4.1 Top-Level Interface
module adder_subtractor_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input        MODE,
    output [3:0] RESULT,
    output       COUT
);
4.2 Inputs
Signal	Width	Description
A	4 bits	First arithmetic operand
B	4 bits	Second arithmetic operand
MODE	1 bit	Operation select
4.3 Outputs
Signal	Width	Description
RESULT	4 bits	4-bit arithmetic result
COUT	1 bit	Final carry-out
4.4 Operation Selection
MODE	Operation	Mathematical Operation
0	Addition	A + B
1	Subtraction	A - B
5. Arithmetic Principle

The design uses a single ripple-carry adder for both addition and subtraction.

The second operand is modified using XOR gates:

B_modified = B XOR MODE

The same MODE signal is connected to the carry-in of the ripple-carry adder.

Therefore:

$$ RESULT = A + (B \oplus MODE) + MODE $$
MODE = 0 — Addition
B_modified = B
Cin = 0

Therefore:

$$ RESULT = A+B $$
MODE = 1 — Subtraction
B_modified = ~B
Cin = 1

Therefore:

$$ RESULT = A+\overline{B}+1 $$

which is the two's-complement implementation of:

$$ A-B $$
Key Design Insight

The same adder hardware performs both operations.

             MODE
               │
               ├──────────────► Cin
               │
B[3:0] ────────┴──► XOR ───────► B_modified[3:0]
                                  │
A[3:0] ───────────────────────────┤
                                  ▼
                         4-bit Ripple Adder
                                  │
                          ┌───────┴───────┐
                          ▼               ▼
                       RESULT            COUT
6. RTL Architecture

The RTL was intentionally written hierarchically rather than describing the entire arithmetic function as a single behavioral expression.

Module Set
and_gate
or_gate
not_gate
nand_gate
nor_gate
xor_gate

half_adder
full_adder
ripple_carry_adder_4bit

mux_2to1
twos_complement_4bit
subtractor_4bit

adder_subtractor_4bit
7. Logic Hierarchy
7.1 Half Adder

The half adder is constructed from:

1 × XOR
1 × AND

Equations:

$$ Sum=A\oplus B $$ $$ Carry=A\cdot B $$

Architecture:

A ─────┬────► XOR ───► Sum
       │
B ─────┼────► AND ───► Carry
       │
7.2 Full Adder

The full adder is constructed using:

2 × Half Adder
1 × OR gate

Architecture:

             ┌──────────────┐
A ──────────►│              │
B ──────────►│    HA1       │
             │              │
             └──────┬───────┘
                    │ sum1
                    ▼
             ┌──────────────┐
Cin ────────►│    HA2       │────► Sum
             └──────┬───────┘
                    │
             carry2 │
                    ▼
carry1 ─────────► OR ───────► Cout

Full-adder equations:

$$ Sum=A\oplus B\oplus Cin $$ $$ Cout=AB+Cin(A\oplus B) $$
8. 4-Bit Ripple-Carry Adder

Four full adders are connected sequentially.

A[0] B[0] Cin
       │
       ▼
     ┌─────┐
     │ FA0 │──► C1
     └─────┘
       │
       ▼
     ┌─────┐
     │ FA1 │──► C2
     └─────┘
       │
       ▼
     ┌─────┐
     │ FA2 │──► C3
     └─────┘
       │
       ▼
     ┌─────┐
     │ FA3 │──► COUT
     └─────┘

Carry propagation:

Cin → FA0 → C1 → FA1 → C2 → FA2 → C3 → FA3 → COUT

This architecture is simple and area-efficient for a small datapath, but the carry dependency creates a longer propagation path as the width increases.

9. Top-Level Architecture

The final module combines:

4 × XOR gates
+
4-bit Ripple-Carry Adder

Architecture:

                     MODE
                       │
           ┌───────────┼───────────┐
           │           │           │
          XOR         XOR         XOR         XOR
           ▲           ▲           ▲           ▲
          B[0]        B[1]        B[2]        B[3]
           │           │           │           │
           └───────────┴───────────┴───────────┘
                       │
                       ▼
                 B_modified[3:0]
                       │
                       ▼
A[3:0] ─────────► 4-bit RCA ◄──────── MODE
                       │
                 ┌─────┴─────┐
                 ▼           ▼
              RESULT        COUT
10. RTL Source

Primary RTL source:

rtl/day1_design.v

The source contains the complete hierarchical implementation, including:

Basic gates
Half adder
Full adder
4-bit ripple-carry adder
2:1 multiplexer
4-bit two's-complement block
4-bit subtractor
Final 4-bit adder/subtractor

The final top-level module is:

adder_subtractor_4bit
11. Verification

Testbench:

tb/day1_tb.v

The verification approach uses a directed Verilog testbench with console-based checking and waveform inspection.

Verification Flow
RTL
 │
 ▼
Testbench
 │
 ▼
Simulation
 ├──────────────► Console PASS/FAIL
 │
 └──────────────► Waveform
Verification Coverage

The testbench exercises:

Basic logic gates
Half adder
Full adder
4-bit ripple-carry adder
2:1 multiplexer
Two's-complement block
4-bit subtractor
Final adder/subtractor
Representative Arithmetic Cases
Addition:
5 + 3   = 8
15 + 1  = 16
7 + 2   = 9

Subtraction:
5 - 3   = 2
10 - 4  = 6
3 - 5   = -2  → 4'b1110
15 - 15 = 0

The top-level arithmetic tests are directed cases; they should not be described as exhaustive verification of every possible A, B, and MODE combination.

12. Simulation Evidence

Simulation-related evidence is maintained under:

simulation/

and screenshots are maintained under:

images/

The evidence is intended to demonstrate:

Correct input application
Correct operation-mode selection
Correct result generation
Correct carry-out behavior
Correct arithmetic transitions
PASS/FAIL verification output
13. Cadence Genus Synthesis

The design was synthesized using:

Cadence Genus Synthesis Solution
Version: 21.14-s082_1
Report Configuration
Module:
adder_subtractor_4bit

Operating condition:
slow (balanced_tree)

Wireload mode:
enclosed

Area mode:
timing library

Technology library:
tsmc18
14. Synthesis Hierarchy

The synthesized hierarchy reported by Genus is consistent with the intended RTL structure.

adder_subtractor_4bit
│
├── ADD_SUB
│   └── ripple_carry_adder_4bit
│       │
│       ├── FA0
│       │   ├── HA1
│       │   │   ├── AND1
│       │   │   └── XOR1
│       │   ├── HA2
│       │   │   ├── AND1
│       │   │   └── XOR1
│       │   └── OR1
│       │
│       ├── FA1
│       ├── FA2
│       └── FA3
│
├── XOR0
├── XOR1
├── XOR2
└── XOR3

The four full-adder stages form the ripple-carry datapath.

15. Cell Area Analysis

The Genus cell-area report gives:

Standard Cell	Instances	Area
AND2X1	8	106.445
OR2X1	3	39.917
OR2XL	1	13.306
XOR2XL	12	319.334
Total	24	479.002
Area Summary
Total cells = 24
Logic cells = 24
Physical cells = 0
Total reported area = 479.002

The supplied Genus report does not explicitly establish µm² as the area unit. Therefore, this repository reports the value as:

479.002 library area units

rather than incorrectly labeling it as physical area.

16. Cell Composition

The synthesized design contains:

12 × XOR
 8 × AND
 4 × OR
--------------
24 total cells

This agrees with the structural design:

4 top-level XOR gates

+

4 full adders ×
(
  2 XOR
  2 AND
  1 OR
)

= 12 XOR + 8 AND + 4 OR

= 24 cells

This is an important RTL-to-gate-level correlation.

17. Hierarchical Area

The hierarchical report gives:

Hierarchy	Cell Count	Area
adder_subtractor_4bit	24	479.002
ADD_SUB / RCA	20	372.557
FA0	5	93.139
FA1	5	93.139
FA2	5	93.139
FA3	5	93.139

Therefore:

RCA:
4 Full Adders × 5 cells
= 20 cells

Top-level XOR:
4 cells

Total:
20 + 4 = 24 cells
18. Power Analysis

The supplied Genus power report uses:

Power Unit: W
PDB Frame: /stim#0/frame#0
Power Breakdown
Category	Leakage	Internal	Switching	Total	Row %
Logic	2.33863e-08 W	1.44756e-05 W	4.78905e-06 W	1.92881e-05 W	100%
Total	2.33863e-08 W	1.44756e-05 W	4.78905e-06 W	1.92881e-05 W	100%
Percentage Breakdown
Power Component	Percentage
Leakage	0.12%
Internal	75.05%
Switching	24.83%
Total	100%
Total Power
$$ P_{total}=1.92881\times10^{-5}\ W $$ $$ P_{total}=19.2881\ \mu W $$

The reported power corresponds to the supplied stimulus frame and synthesis/power-analysis configuration.

19. Timing Analysis

The Genus timing report identifies:

Timing Parameter	Result
Path Type	UNCONSTRAINED
Startpoint	B[0]
Endpoint	COUT
Data Path	2352 ps
Equivalent	2.352 ns
Operating Condition	slow (balanced_tree)
Critical Observed Path
B[0]
 ↓
XOR
 ↓
FA0
 ↓
FA1
 ↓
FA2
 ↓
FA3
 ↓
COUT

The reported data-path delay is:

$$ 2352\ ps = 2.352\ ns $$
Important Timing Qualification

The report explicitly identifies the path as:

UNCONSTRAINED

Therefore, this project reports the observed synthesized data-path delay, but does not claim:

Timing closure
Positive setup slack
Positive hold slack
Maximum operating frequency
A validated clock period

Those conclusions require proper timing constraints and static timing analysis.

20. PPA Summary
Metric	Measured Result
Synthesized cells	24
Reported area	479.002 library area units
Total reported power	19.2881 µW
Observed data-path delay	2.352 ns
Timing path	B[0] → COUT
Timing status	Unconstrained
Operating condition	slow (balanced_tree)
Technology library	tsmc18
PPA Interpretation
AREA
24 standard-cell instances
        │
        ▼
479.002 library area units

POWER
        │
        ▼
19.2881 µW reported total power

TIMING
        │
        ▼
2.352 ns observed B[0] → COUT path
        │
        ▼
UNCONSTRAINED
21. RTL-to-Gate Correlation

One of the main objectives of this project is to understand what synthesis does to the RTL.

RTL Intent
4 × XOR
+
4 × Full Adder
Full-Adder RTL Structure
2 × Half Adder
+
1 × OR
Synthesized Cell Structure
12 × XOR2XL
8  × AND2X1
3  × OR2X1
1  × OR2XL
----------------
24 cells

The synthesized cell count matches the expected structural implementation.

This provides a direct connection between:

RTL hierarchy
      ↓
Logic structure
      ↓
Standard-cell mapping
      ↓
Area
      ↓
Timing
      ↓
Power
22. Repository Structure
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
│   └── [simulation console/output files]
│
├── reports/
│   ├── area_report.txt
│   ├── power_report.txt
│   ├── timing_report.txt
│   ├── hierarchy_report.txt
│   └── cell_area_report.txt
│
├── images/
│   ├── rtl_waveform.png
│   ├── gate_level_waveform.png
│   └── synthesis_hierarchy.png
│
├── docs/
│   └── project_report.pdf
│
└── src/
    └── adder_subtractor_4bit.v

Keep the actual filenames in GitHub consistent with this structure. If a file is not present, remove that entry rather than creating an empty placeholder.

23. File Description
Path	Purpose
README.md	Project documentation
rtl/day1_design.v	Complete hierarchical Verilog RTL
tb/day1_tb.v	Verification testbench
simulation/	Simulation evidence/output
reports/area_report.txt	Genus area report
reports/power_report.txt	Genus power report
reports/timing_report.txt	Genus timing report
reports/hierarchy_report.txt	Genus hierarchy report
reports/cell_area_report.txt	Standard-cell area report
images/	Waveform and synthesis screenshots
docs/project_report.pdf	Detailed project report
src/adder_subtractor_4bit.v	Dedicated top-level source copy
24. Tools Used
HDL / RTL
Verilog HDL
Structural RTL design
Verification
RTL simulation
Directed testbench
Console-based PASS/FAIL checking
Waveform analysis
Synthesis
Cadence Genus Synthesis Solution 21.14-s082_1
Technology
tsmc18 standard-cell library
25. Key Learning Outcomes

This project demonstrates practical understanding of:

RTL hierarchy
Structural Verilog
Combinational logic
Half adders
Full adders
Ripple-carry adders
Two's-complement arithmetic
Arithmetic datapaths
Directed verification
Waveform debugging
Synthesis
Standard-cell mapping
Hierarchy reports
Area reports
Power reports
Timing reports
RTL-to-gate correlation
Basic PPA analysis
26. Important Design Trade-Off

The selected architecture is a Ripple-Carry Adder (RCA).

Advantage
Simple architecture
        +
Low structural complexity
        +
Easy to design and verify
Limitation
Carry dependency
        ↓
Longer propagation delay
        ↓
Timing becomes worse as bit width increases

For larger datapaths, alternative architectures can be studied:

Ripple Carry
      vs
Carry Look-Ahead
      vs
Carry Select
      vs
Kogge-Stone
      vs
Brent-Kung

This Day-1 implementation establishes the baseline for future PPA comparisons.

27. Common Engineering Mistakes Avoided
1. Treating subtraction as a separate datapath

The design instead reuses the same adder:

$$ A-B=A+\overline B+1 $$
2. Forgetting the +1

Simply using:

A + ~B

does not implement two's-complement subtraction correctly.

The MODE signal provides the required carry-in:

Cin = MODE
3. Confusing carry-out with signed overflow

COUT is not automatically equivalent to signed overflow.

Signed overflow requires separate interpretation based on operand and result sign bits.

4. Calling an unconstrained timing result timing closure

The supplied Genus path is:

UNCONSTRAINED

Therefore, 2.352 ns is reported as an observed data-path delay, not as a timing-closure result.

28. Interview Questions
Q1. How does this design perform both addition and subtraction?

Using conditional inversion of B and setting the carry-in equal to MODE:

$$ A+(B\oplus MODE)+MODE $$
Q2. Why is XOR suitable for conditional inversion?

Because:

B XOR 0 = B
B XOR 1 = ~B
Q3. Why is MODE connected to the RCA carry-in?

For subtraction:

$$ A-B=A+\overline B+1 $$

MODE=1 supplies the required +1.

Q4. What architecture is used?

A 4-bit ripple-carry adder.

Q5. Why does ripple carry have a timing limitation?

Each full adder depends on the carry generated by the previous stage.

Q6. How many synthesized cells are reported?
24
Q7. What is the reported synthesized area?
479.002 library area units
Q8. What is the reported power?
1.92881e-05 W
= 19.2881 µW
Q9. What is the reported timing path?
B[0] → COUT
Q10. What is the reported path delay?
2352 ps = 2.352 ns
Q11. Is the timing path constrained?

No. The Genus report identifies it as:

UNCONSTRAINED
Q12. What would you change to improve timing?

For wider arithmetic datapaths, investigate faster carry architectures such as carry-lookahead, carry-select, or parallel-prefix adders, then compare area, power, and timing after synthesis.

29. Industry Relevance

This project demonstrates foundational skills used in:

RTL Design
ASIC Design
FPGA Design
Design Verification
Digital Logic Design
VLSI Front-End Design

The specific arithmetic block is representative of datapath logic used inside larger digital systems.

The important industry skill is not merely implementing an adder, but demonstrating the complete engineering process:

Design
→ Verify
→ Debug
→ Synthesize
→ Analyze
→ Document
→ Explain
30. Project Status
Completed
 Specification
 RTL architecture
 Structural Verilog
 Logic-gate modules
 Half adder
 Full adder
 4-bit ripple-carry adder
 Two's-complement subtraction
 4-bit adder/subtractor
 Directed testbench
 RTL simulation
 Console verification
 Waveform verification
 Genus synthesis
 Hierarchy analysis
 Area analysis
 Power analysis
 Timing-path analysis
 Project documentation
Not Claimed in This Day-1 Project
 UVM verification
 Constrained-random verification
 Formal verification
 Functional coverage
 Timing closure
 Physical design
 Place-and-route
 Signoff STA
31. Future Improvements

Possible next steps include:

Exhaustive top-level verification for all 256 A/B combinations in both modes.
SystemVerilog assertions.
Functional coverage.
Constrained-random verification.
Clock-constrained STA.
Comparison against carry-lookahead architecture.
Comparison against carry-select architecture.
Comparison against parallel-prefix adders.
PPA benchmarking across different adder architectures.
FPGA synthesis and resource comparison.
32. Project Evidence

The repository provides evidence for the engineering flow through:

RTL
 ↓
Testbench
 ↓
Simulation
 ↓
Waveform
 ↓
Genus Synthesis
 ↓
Hierarchy
 ↓
Area
 ↓
Power
 ↓
Timing
Evidence Files
reports/area_report.txt
reports/power_report.txt
reports/timing_report.txt
reports/hierarchy_report.txt
reports/cell_area_report.txt
Visual Evidence
images/rtl_waveform.png
images/gate_level_waveform.png
images/synthesis_hierarchy.png
Documentation
docs/project_report.pdf
33. Final Results
============================================================
DAY 1 — 4-BIT ADDER/SUBTRACTOR
============================================================

Top Module:
    adder_subtractor_4bit

HDL:
    Verilog

Synthesis:
    Cadence Genus 21.14-s082_1

Library:
    tsmc18

Operating Condition:
    slow (balanced_tree)

Synthesized Cells:
    24

Reported Area:
    479.002 library area units

Reported Total Power:
    1.92881e-05 W
    = 19.2881 µW

Observed Timing Path:
    B[0] → COUT

Observed Data Path:
    2352 ps
    = 2.352 ns

Timing Status:
    UNCONSTRAINED

============================================================
34. Author

Omkar Kalmesh Hadapad

B.E. Electronics & Communication Engineering
SDM Institute of Technology, Ujire, Karnataka, India

Focus: Digital VLSI • RTL Design • Verilog • ASIC Design • Verification

GitHub: Omkar-hadapad
LinkedIn: omkar-kalmesh-hadapad

35. Repository Purpose

This repository is part of a structured 30-project Digital VLSI / RTL Design training roadmap.

The long-term objective is to develop the ability to independently:

Understand a specification
        ↓
Design hardware architecture
        ↓
Write synthesizable RTL
        ↓
Build a verification environment
        ↓
Debug functional issues
        ↓
Synthesize the design
        ↓
Analyze area / power / timing
        ↓
Understand implementation trade-offs
        ↓
Document the project
        ↓
Explain the design in technical interviews
⭐ Day 1 Complete

Project: adder_subtractor_4bit
Domain: Digital VLSI / RTL Design
HDL: Verilog
Synthesis: Cadence Genus
Status: Completed
"""

path = Path("/mnt/data/Day-1_README.md")
path.write_text(readme, encoding="utf-8")

print(f"Created: {path}")
print(f"Lines: {len(readme.splitlines())}")
print(f"Characters: {len(readme)}")
