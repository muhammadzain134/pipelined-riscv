# Pipelined RISC-V Processor (5-Stage)

This repository contains the implementation of a **5-stage Pipelined RISC-V Processor** designed in **SystemVerilog**, following the RV32I instruction set architecture.  
The processor improves throughput by executing multiple instructions concurrently using classic pipeline stages.

This project builds upon the single-cycle design and adds pipeline registers, hazard handling, and forwarding logic.

---

## Pipeline Stages (5-Stage RISC-V)

The processor implements the standard pipeline architecture:

1. **IF – Instruction Fetch**
2. **ID – Instruction Decode**
3. **EX – Execute**
4. **MEM – Memory Access**
5. **WB – Write Back**

Pipeline registers separate each stage to allow instruction-level parallelism.

---

## Key Features

- Fully pipelined 5-stage RISC-V processor  
- Supports RV32I instruction set  
- **Hazard Detection Unit** (stalling)  
- **Forwarding Unit** (data forwarding to reduce stalls)  
- **Pipeline Registers:** IF/ID, ID/EX, EX/MEM, MEM/WB   
- ALU with basic arithmetic & logic ops  
- Immediate Generator  
- Instruction & Data Memory  
- Testbench included for simulation  

---

## 🧩 Block Diagram

<p align="center">
<img width="1170" height="729" alt="pipeline" src="https://github.com/user-attachments/assets/8577c95d-31ce-4d0b-bc56-cc7c0c2852c4" />
</p>


