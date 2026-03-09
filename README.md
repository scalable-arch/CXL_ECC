# DDR5 x4 Memory Error Correction Simulator

This project provides a reliability simulator to demonstrate that our proposed ECC algorithm can successfully correct up to **2 failed chips (Single Chip Failure)** in a standard **x4 DDR5 memory environment**.

## Core Objective

The primary goal of this implementation is to prove the error correction robustness of our algorithm at the Rank-Level (RL-ECC):
* **Sub-channel Architecture**: A DDR5 DIMM is consist of two independent sub-channels.
* **Scalability Proof**: This simulator operates on a single sub-channel and confirms that **1 full chip failure per sub-channel** is 100% correctable.
* **Total System Reliability**: By successfully protecting 1 chip per sub-channel, the algorithm inherently guarantees the recovery of **2 failed chips** across the entire 64-bit DDR5 memory channel.

---

## Error Modes & Evaluation Metrics

To clearly understand the simulation results, we define the following fault models and outcomes.

### 1. Error Modes

* **SCE (Single Chip Error)**: An entire x4 DRAM chip fails, corrupting all bits output by that chip.

### 2. Evaluation Metrics

* **CE (Correctable Error)**: The error is detected and perfectly restored to the original data. The system continues to operate without interruption.
* **DUE (Detectable Uncorrectable Error)**: The error is detected, but the data cannot be recovered. The system triggers a halt to prevent data contamination.
* **SDC (Silent Data Corruption)**: **The most critical failure.** The error is either not detected or is incorrectly "fixed," leading the system to continue with corrupted data.

---

## How it Proves 2-Chip Correction

The simulation targets a single 32-bit sub-channel, which typically contains 10 physical chips (8 for data and 2 for redundancy).



1.  **Fault Injection**: The simulator injects a "Single Chip Error (SCE)" where an entire chip's output is corrupted.
2.  **Algorithm Recovery**: Our RL-ECC algorithm identifies the failed chip's position and restores the lost data using the redundant symbols.
3.  **Result Verification**: If the simulation reports **CE = 100%**, it confirms that the sub-channel is immune to a single chip failure.

---

## File Descriptions

| File Name | Functional Role |
| :--- | :--- |
| **`Fault_sim.cpp`** | The core C++ engine that performs error injection and executes the decoding algorithm to measure CE, DUE, and SDC ratios. |
| **`run.py`** | A Python automation script that uses `multiprocessing` to run multiple error scenarios in parallel, optimizing simulation time. |
| **`run.sh`** | The master shell script that handles the end-to-end pipeline: cleanup, compilation, execution, and final PASS/FAIL verification. |
| **`Makefile`** | Defines the build process using `g++` with `-O2` optimization for high-speed simulation performance. |
| **`GF_2^8__...txt`** | Required configuration file for Galois Field $GF(2^8)$ arithmetic tables. |
| **`H_Matrix_SEC.txt`** | Required file containing the parity-check matrix for baseline On-Die ECC (SEC) comparison. |

---

## Usage Instructions

1.  **Grant execution permission**:
    ```bash
    chmod +x run.sh
    ```
2.  **Run the pipeline**:
    ```bash
    ./run.sh
    ```

The script will automatically compile the code, run the necessary tasks, and print **"PASS"** if the chipkill correction rate is exactly **100%**. (Ensure all required `.txt` files are in the root directory to avoid a Segmentation Fault).
