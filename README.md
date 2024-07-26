# eduBOS5
A soft configurable RISC-V micro-controller, custom-tailored for FPGAs, high on compute power, low on everything else. 

This project includes a complete, pre-configured toolchain and workflow for deploying custom hardware and software for our eduBOS5 core. While Gowin FPGAs were the initial target, porting to Xilinx, LatticeSemi and CologneChip is also underway. For best results, we recommend using proprietary FPGA synthesis and place-and-route tools. This is not to say that Yosys won't work, but rather that _nextpnr_ and _P_R_ are still [lacking](https://github.com/chili-chips-ba/openCologne/issues/18#issuecomment-2249085341) on timing-driven and even timing-aware side of things. 

The entire verification flow, including QA and linting, is based on open-source tools. 

Given that eduBOS5 RTL is not in open-source domain, the build steps are not included in this public repo. Reach out to fpga@chili-chips.com to learn more about our design service engagement models, esp. related to putting together complete apps with eduBOS5, including custom accelerators and custom SOCs for your tasks at hand.

## Design overview
**eduBOS5** is a single-threaded, optional Machine privilege mode implementation of RV32I RISC-V ISA. The RTL is written in clean SystemVerilog-2017, making use of language features that enhance readability and simplify debugging. 

What sets it apart is a relatively short 2-cycle execution pipeline. Yet, the 3-cycle pipeline option is also provided for higher Fmax. When used in combination with MCPs, even higher operating frequencies are within reach. The Gowin variant also includes option for building ALU from DSP HMs. That brings about at least 30MHz Fmax boost compared to the stock, LUT-based implementation. 

Simulation is another major differentor. We provide two options there:
- cycle-accurate
- fast, ISS-based HW/SW co-sim, by tapping into [Vproc](https://github.com/wyvernSemi/vproc) technology.

Other customization options are:
- Superscalar implementation
- Instruction & data prefetch 
- Branch prediction
- Interrupt handling

Zicsr is not implemented at the moment, and eduBOS5 currenty runs only deeply-embedded, bare-metal, self-standing programs. However, FreeRTOS support is in the plans. Misaligned data access is based on software traps.

### Block diagram
CPU is of Harvard architecture type, it features separate busses and ports for Instruction and Data memory. This diagram doesn't include some pipeline registers, carefully placed optimizing for Fmax.

![eduBOS5 RISC-V block diagram](/0.doc/cpu_top_view_V2.png)

## Verification strategy
Both static (Formal) and dynamic (Functional) methods are used to verify **eduBOS5** RISC-V compliance, utilizing open-source [SymbiYosys](https://github.com/YosysHQ/sby) and [Verilator](https://github.com/verilator/verilator). Verilator testbench is written in SystemVerilog with a supporting C++ backend.

During development, hand-written assembly tests, functional simulation, and waveform analysis are utilized to verify each individual instruction and instruction type. Once the core is complete, it will undergo standard compliance testing using [riscv-tests](https://github.com/riscv-software-src/riscv-tests). 
Finally, formal verification will be conducted using [RISC-V Formal tests](https://github.com/YosysHQ/riscv-formal) to conclude the verification process.

## Current/Target performance and size (WIP)

At the time, **eduBOS5** is RV32I compliant excluding Zicsr and misaligned data access and runs bare-metal C.  The intent is to have a small, yet capable core, waiting for it's deployment in specialized embedded applications achieving significant performance, along with custom FPGA accelerators. There already are a number of variants of the CPU implementation:
- [Register file implemented in SSRAM distributed memory (LUTRAM) or BSRAM]
- [DSP block or LUT ALU]
- [Superscalar or singe-cycle]

Main development platform is the Gowin LittleBee and Arora FPGA family, in general, handing in utilization and performance figures of:
- **CPI 2/3**
- ~**1000 Gowin LUTs**
- ~**400  FFs**
- **80-100 MHz Fmax**
### Performance evaluation and comparison
Dhrystone yielded in **0.39 DMIPS/MHz**, **2.56 CPI**, combined with a significant Fmax **eduBOS5** is no short of performance, especially when comparing to base version of [PicoRV2](https://github.com/YosysHQ/picorv32) as a referent design. 

![eduBOS5 RISC-V block diagram](/0.doc/dhry.png)

Assessing performance beyond synthetic tests, computing the Mandelbrot set and comparing times with **PicoRV32** is presented below.

<img src="0.doc/dhrystone.gif" width="720" height="420" alt="Description of the GIF">

### Performance/Power/Area table across FPGAs
Numbers listed are acquired using a minimal SOC, featuring an UART, memory, LEDs and user buttons. Although not shown in this table, **eduBOS5** is frequency resilient to adding more peripherals while PicoRV32 hasn't expressed same properties. Base **PicoRV32** is used for comparison as both fall into the same size/area category. In this configuraton, **eduBOS5** needs some optimizations (DSP_ALU) to achieve same Fmax as **PicoRV32**, but nevertheless outperforms it in it's LUT-only version with it's much shorter pipeline.

![eduBOS5 RISC-V block diagram](/0.doc/performance_table.png)

#### End-of-Document
