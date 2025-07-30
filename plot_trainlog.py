import re
import matplotlib.pyplot as plt

# Path to the training log file
log_file = "gns_train.o7244337"

# Lists to store extracted step and loss values
steps = []
losses = []

# Regular expression pattern to extract step and loss
pattern = re.compile(r"step = (\d+)/\d+, loss = ([\d\.eE+-]+)")

# Read the log file and extract values
with open(log_file, "r") as f:
    for line in f:
        match = pattern.search(line)
        if match:
            step = int(match.group(1))
            loss = float(match.group(2))
            steps.append(step)
            losses.append(loss)

# Downsample the data to avoid overplotting
stride = 100  # Plot every 100th point
steps_sampled = steps[::stride]
losses_sampled = losses[::stride]

# Create the plot
plt.figure(figsize=(10, 5))
plt.plot(steps_sampled, losses_sampled, linewidth=1)
plt.xlabel("Step")
plt.ylabel("Loss")
plt.yscale("log")
plt.title(f"Training Loss Curve (sampled every {stride} steps)")
plt.grid(True)
plt.tight_layout()

# Save the plot as a PNG file (do not display)
plt.savefig("loss_curve_log.png", dpi=200)
plt.close()

print("✅ Loss curve saved as 'loss_curve_log.png'")
