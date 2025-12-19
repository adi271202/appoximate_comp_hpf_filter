Approximate High-Pass Filter (HPF) Project

Overview

This repository contains an experimental hardware and software project implementing an approximate high-pass filter (HPF) and related components. The work includes RTL sources (SystemVerilog / Verilog), testbenches, FPGA/implementation constraints, MATLAB scripts for simulation and image processing, and example images and outputs. The focus is on exploring approximate arithmetic (e.g., approximate adders/multipliers) and their impact on filter output quality and resource usage.

Key components

- `rtl_and_constraint/`
  - SystemVerilog and Verilog RTL for filter, multiplier, adders, line buffer, sliding window, and RAM modules.
  - Constraint file `time.xdc` for FPGA timing/place-and-route.
  - Examples: `filter.sv`, `mult_8bits.sv`, `full_adder.v`, `half_adder.v`, `rca.sv`, `SDP_RAM.sv`, `sliding_window.sv`, `line_buffer.sv`.

- `tb/`
  - Testbenches for simulation and verification: `tb_filter.sv`, `tb_line_buffer.sv`, `tb_mult.sv`, etc.

- `filters_cv/`
  - Vivado project files and work configurations for behavioral and timing simulations.
  - `filters_cv.xpr` and waveform configurations for testbenches.

- `Matlab_scripts_and_images/`
  - MATLAB scripts for applying filters, computing errors, and visualizing results.
  - Utility scripts to read/write binary image files and to compute error/metrics.
  - Example images and binary files used in experiments.

- `Mulitplier_design/`
  - Spreadsheet(s) and design notes for multiplier design and Booth/Dadda configurations.

- `result_and_output_images/`
  - Resulting images (exact vs approximated) and histogram plots comparing errors.

What this project demonstrates

- How approximate arithmetic units (e.g., approximate adders, multipliers) affect a simple image filter pipeline.
- Trade-offs between hardware resource usage / performance and output quality.
- End-to-end flow from RTL simulation to MATLAB-based image evaluation.

How to use

Quick notes (assumes Vivado + MATLAB installed):

1. RTL simulation / testbenches
   - Open the Vivado project in `filters_cv/filters_cv.xpr`.
   - Run behavioral simulations using the provided waveform configurations (e.g., `tb_behav_filter.wcfg`).
   - Use the `tb/` testbenches to simulate specific modules.

2. MATLAB scripts
   - Open MATLAB and add `Matlab_scripts_and_images/` to your path.
   - Use `apply_filter_extended.m`, `filter_cv.m`, and `error_calculation.m` to apply the filter and compute error metrics between exact and approximated outputs.
   - Example helper scripts: `read_bin_file.m`, `saveImageBinaryFile.m`, `viewImageBinaryFile.m`.

3. FPGA implementation
   - Constraints are available in `rtl_and_constraint/time.xdc`.
   - The RTL is written to be synthesizable; adapt top-level I/O and constraints to your target board before running implementation.

Files of interest

- `rtl_and_constraint/filter.sv` — top-level filter implementation.
- `rtl_and_constraint/booth_dadda_9bits.sv` — multiplier module used in the design.
- `Matlab_scripts_and_images/apply_filter_extended.m` — example script to run the filter on image data.
- `tb/tb_filter.sv` — top-level filter testbench used for verification.

Sample output could be seen in `result_and_output_images` folder.

License and credits

This repository includes a `LICENSE` file at the root. Refer to it for license terms.

Contact: mathuriyaditya002@gmail.com

Repository owner: adi271202
