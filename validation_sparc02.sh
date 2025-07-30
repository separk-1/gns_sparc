#!/bin/bash

DATASET="mydata_sparc02"
DATA_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/dataset/"

JOB_ID="7244337"
MODEL_PATH="${SCRATCH}/gns_sparc/data/mydata01/models_${JOB_ID}/"
OUTPUT_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/rollouts_${JOB_ID}/"

# Validation steps
STEPS_LIST=(10000 20000 30000 40000 50000 60000 70000 80000 90000 100000 \
110000 120000 130000 140000 150000 160000 170000 180000 190000 200000 \
210000 220000 230000 240000 250000 260000 270000)

# Output summary file
SUMMARY_LOG="valid_sparc02.txt"
echo "step,loss" > "$SUMMARY_LOG"

for STEPS in "${STEPS_LIST[@]}"; do
    echo "Running validation for step $STEPS..."

    # Run validation and capture output
    VALID_LOG=$(python3 -m gns.train \
        --mode="valid" \
        --data_path="${DATA_PATH}" \
        --model_path="${MODEL_PATH}" \
        --output_path="${OUTPUT_PATH}" \
        --model_file="model-${STEPS}.pt" \
        --train_state_file="train_state-${STEPS}.pt")

    echo "$VALID_LOG" > "valid_${STEPS}.txt"  # optional: keep full log per step

    # Extract mean loss
    LOSS=$(echo "$VALID_LOG" | grep "Mean loss on rollout prediction" | awk '{print $6}')

    # Append to summary log
    if [[ -n "$LOSS" ]]; then
        echo "${STEPS},${LOSS}" >> "$SUMMARY_LOG"
        echo "Step ${STEPS}: loss = ${LOSS}"
    else
        echo "${STEPS},N/A" >> "$SUMMARY_LOG"
        echo "Step ${STEPS}: loss not found"
    fi
done
