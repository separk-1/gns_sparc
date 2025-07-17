# GNS Training on Frontera

[Original README](README_original.md)

This project is focused on training the Graph Network Simulator (GNS) on the Frontera supercomputer. 

## Current Status

As of now, the virtual environment has been set up, dataset directories created, and the SLURM batch script has been written and successfully submitted.

---

## 1. Environment Setup

Create the virtual environment using:

```bash
sh build_venv_frontera.sh
```

Then activate the environment:

```bash
source start_venv.sh
```

---

## 2. Dataset Path Configuration

```bash
TMP_DIR="./data"
DATASET_NAME="mydata01"
DATA_PATH="${TMP_DIR}/${DATASET_NAME}/dataset/"
MODEL_PATH="${TMP_DIR}/${DATASET_NAME}/models/"
```

---

## 3. SLURM Batch Script (train.slurm)

```bash
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

# Activate environment
set -e
source start_venv_frontera.sh

# Define paths
DATASET="mydata01"
DATA_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/dataset/"

# Define job-specific output paths
JOB_ID=${SLURM_JOB_ID}
MODEL_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/models_${JOB_ID}/"
OUTPUT_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/rollouts_${JOB_ID}/"
mkdir -p "${MODEL_PATH}" "${OUTPUT_PATH}"

# Run Training
python -u -m gns.train \
  --data_path="${DATA_PATH}" \
  --model_path="${MODEL_PATH}" \
  --output_path="${OUTPUT_PATH}" \
  --nsave_steps=10000 \
  --ntraining_steps=5000000

  #--model_file="latest" \
  #--train_state_file="latest"
```

---

## 4. Job Submission and Monitoring

Submit the job:

```bash
sbatch train.slurm
```

Check job status:

```bash
squeue -u $USER
```

Follow the log output in real-time:

```bash
tail -f gns_train.out
```

---

## 5. MPM Ground Truth Data

The GNS is trained on 2D Material Point Method (MPM) numerical simulations generated in Taichi.
See [the Taichi-Elements repository here](https://github.com/taichi-dev/taichi_elements/).

---

## 6. Rendering Rollouts Locally

Once training is complete, you can visualize the simulation rollouts by converting them into `.gif` files.

### Step 1: Launch an Interactive GPU Session

Request a GPU node on the `rtx` partition for 120 minutes:

```bash
idev -p rtx -m 120
```

### Step 2: Activate the Virtual Environment

Once inside the interactive session, activate the Python environment:

```bash
source start_venv_frontera.sh
```

### Step 3: Define the Output Path

Set the path where your rollout results are saved (example below uses job ID `7243783`):

```bash
DATASET="mydata01"
OUTPUT_PATH="${SCRATCH}/gns_sparc/data/${DATASET}/rollouts_7243783/"
```

### Step 4: Run the Renderer

Render the rollout into a gif:

```bash
python3 -m gns.render_rollout \
  --output_mode="gif" \
  --rollout_dir=${OUTPUT_PATH} \
  --rollout_name="rollout_ex0"
```

---