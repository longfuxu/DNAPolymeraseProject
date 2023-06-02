import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Set the style for the plot
sns.set(style="whitegrid", font_scale=1.4, rc={"figure.figsize": (8, 6)})
sns.set_palette("Set2")

# Data
conditions = ["Single-burst Events", "Transitional Events"]
data = [167, 14]

# Bootstrapping parameters
n_bootstraps = 1000
bootstrap_means = []

# Perform bootstrapping
for condition_data in data:
    bootstrapped_means = []
    for _ in range(n_bootstraps):
        bootstrap_sample = np.random.choice([condition_data], size=condition_data, replace=True)
        bootstrapped_means.append(np.mean(bootstrap_sample))
    bootstrap_means.append(bootstrapped_means)

# Calculate means and standard errors
means = [np.mean(bs_means) for bs_means in bootstrap_means]
standard_errors = [np.std(bs_means) for bs_means in bootstrap_means]

fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True, figsize=(8, 6))

# Plot the data in the top subplot
ax1.bar(conditions, means, yerr=standard_errors, capsize=10, alpha=0.8)
ax1.set_ylim(130, 180)
ax1.spines['bottom'].set_visible(False)
ax1.tick_params(bottom=False, top=False, labelbottom=False)

# Plot the data in the bottom subplot
ax2.bar(conditions, means, yerr=standard_errors, capsize=10, alpha=0.8)
ax2.set_ylim(0, 30)
ax2.spines['top'].set_visible(False)

# Customize the plot
ax2.set_ylabel("Counts", fontsize=14)

# Calculate the total number of events
total_events = sum(data)

# Calculate the percentages
percentages = [condition_data / total_events * 100 for condition_data in data]

# Annotate the bars with the mean values and percentages
for rect, mean_value, percentage in zip(ax2.patches, means, percentages):
    ax2.text(rect.get_x() + rect.get_width() / 2, rect.get_height() + 1,
            f"{mean_value:.1f}\n({percentage:.1f}%)",
            ha="center", va="bottom", fontsize=14, fontweight="bold")
    
for rect, mean_value, percentage in zip(ax1.patches, means, percentages):
    ax1.text(rect.get_x() + rect.get_width() / 2, rect.get_height() + 1,
            f"{mean_value:.1f}\n({percentage:.1f}%)",
            ha="center", va="bottom", fontsize=14, fontweight="bold")

# Save and display the plot
plt.tight_layout()
plt.subplots_adjust(hspace=0.1)
plt.savefig('/Users/longfu/Library/CloudStorage/Dropbox/3-T7 DNAp_Nat Com～working/SI_data/comparison-single-transitional_exo-event.eps', format='eps', dpi=300, bbox_inches='tight')
plt.show()
