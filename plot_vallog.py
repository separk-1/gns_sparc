import matplotlib.pyplot as plt
import pandas as pd

# Load validation loss log
df = pd.read_csv('valid_origintest_sum.txt')

# Sort by step if not already
df = df.sort_values(by='step')

# Set style to match the provided code
plt.rcParams['font.family'] = 'DejaVu Serif'

# Plot
plt.figure(figsize=(10, 5))
plt.plot(df['step'], df['loss'], linewidth=2, color='#4C6EF5', label='Validation Loss')
#plt.plot(df['step'], df['loss'], marker='o', linestyle='', color='#4C6EF5', label='Validation Loss')
plt.yscale('log')
plt.xlabel('Step')
plt.ylabel('Validation Loss')
plt.title('Validation Loss')
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.legend()
plt.tight_layout()
plt.savefig('val_loss_log_plot.png', dpi=300)
