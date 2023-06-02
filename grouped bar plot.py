import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Set the style for the plot
sns.set(style="whitegrid", font_scale=1.2, rc={"figure.figsize": (12, 6)})
sns.set_palette("Set2")

# Data
conditions = ["P->P->P", "P->P->E", "P->E->E", "P->E->P", "E->P->E", "E->P->P", "E->E->E", "E->E->P"]
data = [147, 3, 5, 4, 2, 11, 22, 5]

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

# Create the bar plot with error bars
fig, ax = plt.subplots()
bar_plot = ax.bar(conditions, means, yerr=standard_errors, capsize=10, alpha=0.8)

# Customize the plot
ax.set_ylabel("Counts", fontsize=14)
# ax.set_title("Comparison of Eight Conditions", fontsize=16, fontweight="bold")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

# Calculate the total number of events
total_events = sum(data)

# Calculate the percentages
percentages = [condition_data / total_events * 100 for condition_data in data]

# Annotate the bars with the mean values and percentages
for rect, mean_value, percentage in zip(bar_plot, means, percentages):
    ax.text(rect.get_x() + rect.get_width() / 2, rect.get_height() + 0.5,
            f"{mean_value:.1f}\n({percentage:.1f}%)",
            ha="center", va="bottom", fontsize=14, fontweight="bold")

# Save and display the plot
plt.tight_layout()
plt.savefig('/Users/longfu/Library/CloudStorage/Dropbox/3-T7 DNAp_Nat Com～working/SI_data/eight_config_pol-event'+'.eps', format='eps', dpi=300, bbox_inches='tight')
plt.show()
