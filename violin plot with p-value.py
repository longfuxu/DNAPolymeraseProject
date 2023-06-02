import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import ttest_ind
from matplotlib.ticker import ScalarFormatter


# Set the style for the plot
sns.set(style="whitegrid", font_scale=1.2, rc={"figure.figsize": (8, 6)})
sns.set_palette("Set2")

# Read the data from the Excel file
data = pd.read_excel("/Users/longfu/Library/CloudStorage/Dropbox/3-T7 DNAp_Nat Com～working/SI_data/tracksumamry.xlsx")
# Drop rows with missing values
data = data.dropna()

# Perform the independent two-sample t-test
t_stat, p_value = ttest_ind(data["DNAp on ssDNA"], data["DNAp on dsDNA"], equal_var=False)

# Create the box plot with overlaid scatter points
fig, ax = plt.subplots()
sns.boxplot(data=data, width=0.5, fliersize=5)
sns.stripplot(data=data, jitter=True, linewidth=1, edgecolor="gray", alpha=0.6)

# Customize the plot
ax.set_ylabel("Diffusion Constants", fontsize=14)
# ax.set_title("Comparison of Diffusion Constants on ssDNA vs. dsDNA", fontsize=16, fontweight="bold")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

# Change the y-axis to scientific notation
ax.yaxis.set_major_formatter(ScalarFormatter(useMathText=True))
ax.ticklabel_format(style='sci', axis='y', scilimits=(0, 0))

# Calculate the mean values
ssDNA_mean = np.mean(data["DNAp on ssDNA"])
dsDNA_mean = np.mean(data["DNAp on dsDNA"])

# Add mean value annotations on top of each group
ax.annotate(f"{ssDNA_mean:.2e}", xy=(0, ssDNA_mean), xytext=(0, ssDNA_mean + 0.5),
            ha="center", va="bottom", fontsize=12, fontweight="bold",
            bbox=dict(facecolor="white", edgecolor="none", pad=2))
ax.annotate(f"{dsDNA_mean:.2e}", xy=(1, dsDNA_mean), xytext=(1, dsDNA_mean + 0.5),
            ha="center", va="bottom", fontsize=12, fontweight="bold",
            bbox=dict(facecolor="white", edgecolor="none", pad=2))


# Annotate the p-value on the plot
ax.annotate(f"p = {p_value:.2e}", xy=(0.5, 1), xycoords="axes fraction", ha="center", va="bottom",
            fontsize=14, fontweight="bold", bbox=dict(facecolor="white", edgecolor="none", pad=5))

# Save and display the plot
plt.tight_layout()
plt.savefig('/Users/longfu/Library/CloudStorage/Dropbox/3-T7 DNAp_Nat Com～working/SI_data/diffusion_constants_box_plot_scatter_nature'+'.eps', format='eps', dpi=300, bbox_inches='tight')
plt.show()