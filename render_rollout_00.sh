#!/bin/bash

# Set dataset and paths
DATASET="mydata_sparc00"
DATA_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/dataset/"
JOB_ID="7244337"
MODEL_PATH="${SCRATCH}/gns_sparc/data/mydata01/models_${JOB_ID}/"
OUTPUT_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/rollouts_${JOB_ID}/"

# List of steps to generate rollouts for
STEPS_LIST=("270000")

for STEPS in "${STEPS_LIST[@]}"; do
    echo "========== STEP ${STEPS} =========="

    # 1. Generate rollout (this always creates rollout_ex0.pkl)
    python3 -m gns.train \
        --mode="rollout" \
        --data_path="${DATA_PATH}" \
        --model_path="${MODEL_PATH}" \
        --output_path="${OUTPUT_PATH}" \
        --model_file="model-${STEPS}.pt" \
        --train_state_file="train_state-${STEPS}.pt"

    # 2. Render GIF from rollout_ex0.pkl (creates rollout_ex0.gif)
    python3 -m gns.render_rollout \
        --output_mode="gif" \
        --rollout_dir="${OUTPUT_PATH}" \
        --rollout_name="rollout_ex0"

    # 3. Rename .pkl and .gif files for record keeping
    PKL_NAME="rollout_${DATASET}_${STEPS}.pkl"
    GIF_NAME="rollout_${DATASET}_${STEPS}.gif"

    cp "${OUTPUT_PATH}/rollout_ex0.pkl" "${OUTPUT_PATH}/${PKL_NAME}"
    mv "${OUTPUT_PATH}/rollout_ex0.gif" "${OUTPUT_PATH}/${GIF_NAME}"

    echo "✔ Saved: ${PKL_NAME}, ${GIF_NAME}"
    echo ""
done

echo "All rollouts and GIFs saved in ${OUTPUT_PATH}"
