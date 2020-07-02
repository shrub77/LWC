LWC HARDWARE API
==============

This is a development package for the GMU authenticated encryption hardware API.
This package is divided into two primary parts, hardware and software.


Hardware
-----------

`$root/hardware`

Templates for CryptoCore and design_pkg.

* `./LWCsrc`

    Universal Pre- and Post-processors and the associated testbench.
    
*  `./dummy_lwc`
   
    Example implementation of a dummy authenticated cipher and hash function. 

    The full source list required to implement and simulate the design can be found in the ModelSim script located in the /scripts folder.
    Note: It is recommended to use the provided ModelSim script for a quick evaluation of the design.

    * `./src_rtl`
   
        Code that is required for implementation.
        
    * `./KAT`
    
        Known-Answer-Test files folder.

        * `./KAT_{8,16,32}`
    
            Known-Answer-Test files for a 8, 16, and 32 bus width
           
        * `./KAT_MS_{8,16,32}`
    
            Known-Answer-Test files with multiple segments for
            plaintext, ciphertext, associated data and hash message


    * `./scripts`
    
        ModelSim script for a quick simulation.
        Vivado script for a quick simulation.

### LWC Lint, Simulation, and Synthesis Framework
The lint, simulation, and synthesis framework consists of a set of user-includable base makefiles (lwc_*.mk). 
Core developers should provide their design specific Makefile which incorporates the framework functionality 
through a series of “include” statements.

A core designers would a create a `Makefile` in their design directory. In this design-specific `Makefile`, they 
would set the variable `LWC_ROOT` to point to the top LWC package directory (e.g. relative path where LWC package is added as a 
[git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules)) and "include" the desired `lwc.mk` file to 
gain access to the corresponding tools through the use of make rules. 

Please see the accompanying example `dummy_lwc` [Makefile](hardware/dummy_lwc/src_rtl/Makefile).

After setting up the `Makefile`, invoking any of the tools would be as easy as issuing:

`$ make <RULENAME>`

Where `<RULENAME>` is any of the following available rules:


- Lint rules:
    - `lint-vhdl`: invokes GHDL in checking mode. Requires installation of GHDL.
    - `lint-vhdl-synth`: invokes GHDL synthesis without generating any output files. Requires installation of GHDL.
    - `lint-verilog`: invokes Verilator in lint mode. Requires installation of Verilator
    - `lint-yosys`: which reads both Verilog and VHDL files in yosys and performs a quick check. Requires installation of yosys, GHDL, and ghdl-yosys-plugin.

- Simulation rules:
    - `sim-ghdl`: run GHDL simulation of core using `LWC_TB` as testbench. Input data and golden output files can be specified in `config.ini`.

- Synthesis rules:
  - FPGA:
    - `synth-xilinx-yosys-xc7`: Yosys FPGA synthesis targeting Xilinx series-7 devices.
  - ASIC:
    - `synth-dc`: ASIC synthesis using Synopsys Design Compiler. PDK and standard-cell library can be configured. FreePDK-45/nangate library is included.

Tool dependencies
- [GHDL](https://github.com/ghdl/ghdl) open-source VHDL simulator and synthesizer: Version 0.38 (upon release), master, or [nightly binaries](https://github.com/ghdl/ghdl/releases/tag/nightly)
- [Verilator](https://github.com/verilator/verilator) fast open-source Verilog/SystemVerilog simulator: Version v4.036
- [Yosys](https://github.com/YosysHQ/yosys) Open SYnthesis Suite: 0.9+ or master
- [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin) for VHDL synthesis using ghdl and yosys: master
- Python 3.7+
- GNU Make 4.2+


External core examples incorporating the framework:
- Modified COMET-CHAM from Virginia Tech: https://github.com/kammoh/comet_cham_lwc_v2/tree/asic (`asic` branch)


Software
----------

* `$root/software/crypto_aead`

    Folder follows SUPERCOP package structure.
    It contains the dummy reference implementation for AEAD.
    
* `$root/software/crypto_hash`

    Folder follows SUPERCOP package structure. It contains the dummy reference implementation for hash.
    
    User should obtain the latest reference code from [SUPERCOP's website](https://bench.cr.yp.to/supercop.html) and place relevant implementation in the above locations.
    
* `$root/software/prepare_src`

  A Python utility to help prepare code from `$root/software/crypto_aead` and `$root/software/crypto_hash` for test vector generation.
    
* `$root/software/cryptotvgen`

   Python package for the cryptographic hardware test vector generation tool.

Notes
------

Please refer to the latest Implementer’s Guide to the LWC Hardware API
available at https://cryptography.gmu.edu/athena/index.php?id=LWC
for more detail.
