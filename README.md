4-Bit Programmable Pattern Detector in Verilog


A.Description

4-bit pattern detector in Verilog with FSM. Detects user-defined patterns in serial input, supports overlapping matches, and runs synchronously. Includes testbench for verification. Organized repo with clear README and MIT License. Ideal for FPGA/ASIC. Showcases Verilog, FSM design, and testing skills.

B. Features

1. Programmable Pattern: Detects any 4-bit pattern loaded via control signal.

2. Overlapping Matches: Identifies consecutive matches in serial input.

3. Synchronous FSM: Operates with clock and active-low reset across IDLE, SHIFT, and MATCH states.

4. Robust Testbench: Tests multiple patterns, mid-stream changes, and edge cases.

C. Getting Started

	Prerequisites

	- Verilog simulator (e.g., ModelSim, Vivado, IRUN, simVision).

	- Git for cloning the repository.

	Installation
	
	- Clone the repository:

	- Open files in a Verilog simulator.

D. Running the Testbench

	- Compile src/patterndetector.v and testbench/patterndetector_tb.v.

	- Run simulation to verify patterns (e.g., 1010, 1000, 1100).

	- Check match signal and waveform (wave.shm) in ModelSim or compatible simulator.

E. Simulation Results

	- Pattern 1010 detection in stream 101010.

	- Overlapping matches for 1000.

	- Mid-stream pattern change to 1100.

	- No false positives for incomplete inputs.

	- Can simulate against custom testbenches and cases.

F. Future Enhancements

	- Support variable pattern lengths.

	- Add parallel input mode.

	- Include randomized test cases.

G. License

Licensed under the MIT License. See LICENSE for details.

H. Contact

File issues or questions via GitHub Issues.



Designed by [varungraj].