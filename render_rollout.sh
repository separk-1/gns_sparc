DATASET="mydata02"
DATA_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/dataset/"

# Define job-specific output paths
JOB_ID="7243783"
MODEL_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/models_${JOB_ID}/"
OUTPUT_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/rollouts_${JOB_ID}/"
STEPS="50000"

python3 -m gns.train --mode="rollout" --data_path=${DATA_PATH} --model_path=${MODEL_PATH} --output_path=${OUTPUT_PATH} --model_file="model-${STEPS}.pt" --train_state_file="train_state-${STEPS}.pt"
#python3 -m gns.train --mode="valid" --data_path=${DATA_PATH} --model_path=${MODEL_PATH} --output_path=${OUTPUT_PATH} --model_file="model-${STEPS}.pt" --train_state_file="train_state-${STEPS}.pt"

# For particulate domain,
#python3 -m gns.render_rollout --output_mode="gif" --rollout_dir=${OUTPUT_PATH} --rollout_name="rollout_ex0"