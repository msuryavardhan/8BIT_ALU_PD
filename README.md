# 8-Bit ALU — RTL to GDSII ASIC Implementation

An 8-bit registered ALU implemented through a complete RTL-to-GDSII digital ASIC flow using open-source EDA tools and the Nangate45 standard-cell library.

## Project Overview

This project implements an 8-bit RISC-V-inspired Arithmetic Logic Unit (ALU) and demonstrates the complete digital ASIC implementation flow:

**RTL â†’ Simulation â†’ Synthesis â†’ Floorplanning â†’ Placement â†’ Clock Tree Synthesis â†’ Routing â†’ Parasitic Extraction â†’ Post-Route STA â†’ GDSII**

The design was implemented and physically realized using open-source EDA tools with the Nangate45 standard-cell technology.

## ALU Operations

| ALU Operation | Description |
|---|---|
| ADD | 8-bit addition |
| SUB | 8-bit subtraction |
| AND | Bitwise AND |
| OR | Bitwise OR |
| XOR | Bitwise XOR |
| SLL | Logical left shift |
| SRL | Logical right shift |
| SLT | Set less-than comparison |

Status flags: Zero, Carry, Overflow, Negative.

## Architecture

The design uses a registered datapath:

```text
Input FF â†’ Combinational 8-bit ALU Logic â†’ Output FF
```

Supported operations are ADD, SUB, AND, OR, XOR, SLL, SRL and SLT.

## RTL Simulation

The RTL was simulated using **Icarus Verilog** and waveforms were inspected using **GTKWave**.

The testbench verifies all 8 supported ALU operations, synchronous reset, result generation, status flags and registered one-cycle output behavior.

**All 8 functional operation tests passed successfully during RTL simulation.**

## Synthesis

The RTL was synthesized using **Yosys** targeting the **Nangate45** standard-cell library.

### Synthesis Summary

| Metric | Result |
|---|---:|
| Technology | Nangate45 |
| Synthesis tool | Yosys |
| Total cells | 271 |
| D flip-flops | 31 |

Synthesized netlist:

```text
synthesis/rv8_alu_synth.v
```

## Physical Design Flow

The synthesized netlist was implemented using **OpenROAD**:

```text
Floorplan
   â†“
I/O Pin Placement
   â†“
Global Placement
   â†“
Detailed Placement
   â†“
Clock Tree Synthesis
   â†“
Global Routing
   â†“
Detailed Routing
   â†“
Parasitic Extraction
   â†“
Post-Route STA
   â†“
GDSII Stream-Out
```

### Floorplanning

| Metric | Result |
|---|---:|
| Die width | 32.5 Âµm |
| Die height | 32.5 Âµm |
| Core area | ~753 ÂµmÂ² |
| Target utilization | 50% |

### Placement

Global placement followed by detailed placement was completed using OpenROAD. Placement was checked for legal site alignment before CTS.

### Clock Tree Synthesis

CTS used:

```text
CLKBUF_X1
CLKBUF_X2
CLKBUF_X3
```

| Metric | Result |
|---|---:|
| Clock sinks | 31 |
| Clock buffers | 5 |
| Buffer types | 3 |
| Buffer levels | 2 |
| Reported setup skew | ~0 ns |

### Routing

Global and detailed routing were completed successfully.

```text
Routing violations: 0
```

Approximate final routed wire length:

```text
2.48 mm
```

Primary routing layers: Metal2, Metal3 and Metal4.

### Parasitic Extraction

Post-route parasitic extraction was performed using the Nangate45 RC extraction rules.

Output:

```text
results/rv8_alu.spef
```

## Post-Route Static Timing Analysis

Post-route STA was performed using **OpenSTA** with the extracted SPEF.

| Metric | Result |
|---|---:|
| Clock period | 10 ns |
| Target frequency | 100 MHz |
| Worst setup slack | +8.86 ns |
| Worst hold slack | +0.13 ns |
| Setup TNS | 0 ns |
| Hold TNS | 0 ns |

The implemented design is timing-clean under the applied constraints.

## Physical Design Summary

| Metric | Result |
|---|---:|
| Technology | Nangate45 |
| Die size | 32.5 Ã— 32.5 Âµm |
| Core area | ~753 ÂµmÂ² |
| Standard-cell design area | ~415 ÂµmÂ² |
| Reported utilization | ~55% |
| Routed wire length | ~2483 Âµm |
| Routing violations | 0 |
| Antenna net violations | 0 |
| Worst setup slack | +8.86 ns |
| Worst hold slack | +0.13 ns |
| Target frequency | 100 MHz |

## GDSII Generation

The final routed design was streamed out to **GDSII** using **KLayout** and the Nangate45 standard-cell GDS library.

Final GDSII:

```text
results/rv8_alu_final.gds
```

The generated GDSII was successfully opened and inspected in KLayout.

The final RTL-to-GDS snapshot is preserved in this repository before subsequent DRC, LVS and PPA investigation.

## Layout Visualization

Implementation screenshots are available under:

```text
results/screenshots/
```

They document floorplanning, placement, I/O pins, CTS, post-CTS/parasitic extraction, final routing, KLayout inspection and KLayout 2.5D visualization.

## Design Rule Checking (DRC)

Initial DRC investigation was performed using the Nangate45/FreePDK45 KLayout DRC deck.

Current result:

```text
Total markers: 78
Primary rule: WELL.4
```

The markers correspond to the reported minimum well-width rule and are currently being investigated to determine whether they originate from top-level geometry or standard-cell/library geometry.

**DRC signoff is not claimed at this stage.**

## Layout Versus Schematic (LVS)

LVS verification is currently pending.

The final layout will be compared against the corresponding extracted/schematic representation using the appropriate Nangate45/FreePDK45 LVS flow.

**LVS signoff is not claimed at this stage.**

## Power Analysis

An initial OpenROAD power report was generated, but the available VCD activity was not successfully annotated to the gate-level design:

```text
Annotated pin activities: 0
```

Therefore, the resulting power value is **not considered a valid activity-based power result** and is not reported as final PPA.

A defensible power analysis will be performed after establishing correct gate-level switching activity or a clearly documented activity assumption.

## PPA Status

| PPA Metric | Current Status |
|---|---|
| Area | âœ… ~415 ÂµmÂ² |
| Performance | âœ… +8.86 ns worst setup slack |
| Hold timing | âœ… +0.13 ns worst hold slack |
| Power | â³ Pending valid activity analysis |

## Tools Used

| Tool | Purpose |
|---|---|
| Icarus Verilog | RTL simulation |
| GTKWave | Waveform visualization |
| Yosys | RTL synthesis |
| OpenROAD | Floorplanning, placement, CTS and routing |
| OpenSTA | Static timing analysis |
| KLayout | GDSII generation, layout inspection and DRC |
| Magic | Layout verification support |
| Netgen LVS | LVS verification |
| Nangate45 | Standard-cell technology |

## Project Structure

```text
8BIT_ALU_PD/
â”œâ”€â”€ .gitignore
â”œâ”€â”€ README.md
â”œâ”€â”€ rtl/
â”‚   â””â”€â”€ rv8_alu.v
â”œâ”€â”€ tb/
â”‚   â””â”€â”€ rv8_alu_tb.v
â”œâ”€â”€ constraints/
â”‚   â””â”€â”€ rv8_alu.sdc
â”œâ”€â”€ synthesis/
â”‚   â””â”€â”€ rv8_alu_synth.v
â””â”€â”€ results/
    â”œâ”€â”€ rv8_alu_final.gds
    â”œâ”€â”€ rv8_alu_final.def
    â”œâ”€â”€ rv8_alu_gds.def
    â”œâ”€â”€ rv8_alu_postroute.def
    â”œâ”€â”€ rv8_alu_postroute.v
    â”œâ”€â”€ rv8_alu.spef
    â””â”€â”€ screenshots/
```

## Reproducibility

Major implementation stages:

```text
1. RTL design
2. RTL simulation
3. RTL synthesis
4. Floorplan initialization
5. I/O pin placement
6. Global placement
7. Detailed placement
8. Clock Tree Synthesis
9. Global routing
10. Detailed routing
11. Parasitic extraction
12. Post-route STA
13. GDSII stream-out
```

The flow uses the Nangate45 standard-cell technology files and open-source EDA tools.

## Current Project Status

| Stage | Status |
|---|---|
| RTL design | âœ… Complete |
| RTL simulation | âœ… Complete |
| Synthesis | âœ… Complete |
| Floorplanning | âœ… Complete |
| Placement | âœ… Complete |
| Clock Tree Synthesis | âœ… Complete |
| Routing | âœ… Complete |
| Parasitic extraction | âœ… Complete |
| Post-route STA | âœ… Complete |
| GDSII generation | âœ… Complete |
| DRC | âš ï¸ Under investigation |
| LVS | â³ Pending |
| PPA | â³ Power analysis pending |

## Future Work

- Complete DRC investigation and validation
- Complete LVS
- Establish correct gate-level switching activity
- Generate a defensible power estimate
- Complete final PPA analysis
- Investigate area, timing and power trade-offs
- Document final verification results

## Author

**Manchikanti Surya Vardhan**

This project demonstrates practical experience across RTL design, functional verification, synthesis, physical implementation, static timing analysis and GDSII generation using open-source ASIC design tools.

