#!/bin/bash
#SBATCH --job-name=gns_train
#SBATCH --output=gns_train.o%j
#SBATCH --error=gns_train.e%j
#SBATCH --partition=rtx     
#SBATCH --time=48:00:00   
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mail-type=END            
#SBATCH --mail-user=seongeup@andrew.cmu.edu
#SBATCH -A BCS20003


set -e
source start_venv_frontera.sh

DATASET="mydata01"
DATA_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/dataset/"

# Define job-specific output paths
JOB_ID=${SLURM_JOB_ID}
MODEL_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/models_${JOB_ID}/"
OUTPUT_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/rollouts_${JOB_ID}/"
mkdir -p "${MODEL_PATH}" "${OUTPUT_PATH}"

python -u -m gns.train \
  --data_path="${DATA_PATH}" \
  --model_path="${MODEL_PATH}" \
  --output_path="${OUTPUT_PATH}" \
  --nsave_steps=1000 \
  --ntraining_steps=10000
  
  
  #--model_file="latest" \
  #--train_state_file="latest"
