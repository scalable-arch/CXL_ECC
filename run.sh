#!/bin/bash

# 1. Clean previous build artifacts
echo "========================================"
echo " 1. Cleaning previous builds (make clean) "
echo "========================================"
make clean

# 2. Build the simulator
echo ""
echo "========================================"
echo " 2. Building the simulator (make) "
echo "========================================"
make

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "ERROR: Build failed. Please check your Makefile and source code."
    exit 1
fi

# 3. Execute simulations via Python script
echo ""
echo "========================================"
echo " 3. Running simulations (python3 run.py) "
echo "========================================"
python3 run.py

# Check if python script execution was successful
if [ $? -ne 0 ]; then
    echo "ERROR: Python script execution failed."
    exit 1
fi

# 4. Verify Chipkill Correction Result
echo ""
echo "========================================"
echo " 4. Verifying Chipkill Correction Result "
echo "========================================"
RESULT_FILE="HSIAO_SSC_DEC_CHIPKILL_NE_NE.S"

# Check if the result file exists and is not empty
if [ -f "$RESULT_FILE" ] && [ -s "$RESULT_FILE" ]; then
    
    # Extract the last reported CE rate (formatted as %.11f in C++)
    # According to the logic, Unity ECC should achieve 100% correction for SCE [cite: 47, 113, 331]
    CE_RATE=$(grep "CE :" "$RESULT_FILE" | tail -n 1 | awk '{print $3}')
    
    # A 100% correction rate is represented as 1.00000000000
    if [ "$CE_RATE" == "1.00000000000" ]; then
        echo "PASS (Chipkill Correction: 100%)"
    else
        echo "FAIL (Chipkill Correction: $CE_RATE)"
    fi

else
    echo "WARNING: Result file not found or empty: $RESULT_FILE"
    echo "This may be due to a Segmentation Fault caused by missing configuration files."
fi
echo "========================================"