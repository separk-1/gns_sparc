import torch
import matplotlib.pyplot as plt

# Set global font to Times New Roman
plt.rcParams['font.family'] = 'DejaVu Serif'

# Load train_state file
path = './data/mydata01/models_7244337/train_state-270000.pt'
train_state = torch.load(path, map_location='cpu')

# Extract loss history
loss_history = train_state['loss_history']
train_loss_data = loss_history.get('train', [])

# Split into epochs and loss values
epochs = [e for e, _ in train_loss_data]
losses = [max(l, 1e-8) for _, l in train_loss_data]  # avoid log(0)

# Plot
plt.figure(figsize=(10, 5))
plt.plot(epochs, losses, linewidth=2, color='#4C6EF5', label='Train Loss')  # custom color
plt.yscale('log')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.title('Training Loss')
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.legend()
plt.tight_layout()
plt.savefig('loss_log_plot.png', dpi=300)
