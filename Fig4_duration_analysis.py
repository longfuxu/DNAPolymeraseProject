import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

# assuming you've saved your data in a .txt file
filename = '/Users/longfu/Library/CloudStorage/Dropbox/3-T7 DNAp_Nat Com～working/fig_prep/Figure 4/DNAp on ssDNA/image data/20190517-104639 test 60nM labelled  DNAp-snap +2uL trx (RT for 15h) #008-001track_2Tracking.txt'
df = pd.read_csv(filename, sep='\t')

# Calculate life in seconds
df['Life_s'] = (df['tEnd_ms'] - df['tStart_ms']) / 1000

# Calculate mean life and SEM
mean_life = df['Life_s'].mean()
sem_life = df['Life_s'].sem()

print(f'Mean life: {mean_life} s')
print(f'SEM: {sem_life} s')

# Set style for nicer plots
sns.set(style='whitegrid')

# Create a figure and a grid of subplots
fig, ax = plt.subplots(figsize=(4,3))

# Box plot
sns.boxplot(y='Life_s', data=df, color='skyblue', ax=ax, showfliers=False)

# Scatter plot with jitter
sns.stripplot(y='Life_s', data=df, color='darkblue', size=4, jitter=1, ax=ax)

# Labeling the axes and setting the title
plt.xlabel(' ')
plt.ylabel('Life-time (s)')
# plt.title('Life of Tracks with SEM')

# Display mean and SEM on the plot
plt.text(0.05, 0.95, f'life_time: {mean_life:.2f} s\nSEM: {sem_life:.2f} s', 
         transform=plt.gca().transAxes, verticalalignment='top')

plt.tight_layout()
plt.savefig(filename.replace('.txt', 'life-time_plot') +'.eps', format='eps', dpi=300, bbox_inches='tight')
plt.savefig(filename.replace('.txt', 'life-time_plot') +'.eps', format='eps', dpi=300, bbox_inches='tight')

plt.show()
