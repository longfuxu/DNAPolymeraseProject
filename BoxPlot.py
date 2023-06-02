import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Set the style for the plot
sns.set(style="whitegrid")

# Data
conditions = ["Single", "Transition"]
data = [73, 7]

# Prepare the data for box plot and violin plot
data_single = np.full(data[0], conditions[0])
data_transition = np.full(data[1], conditions[1])
all_data = np.concatenate([data_single, data_transition])

# Create a DataFrame
df = pd.DataFrame({"Condition": all_data})

# Violin plot
fig, ax = plt.subplots()
sns.violinplot(x="Condition", y=df.index, data=df, ax=ax)
ax.set_ylabel("Data")
ax.set_title("Comparison of Two Conditions - Violin Plot")
plt.savefig("comparison_violin_plot.png")
plt.show()
