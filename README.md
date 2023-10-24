# Mapping Fast DNA Polymerase Exchange at the Replication Fork

This repository contains four separate Jupyter notebooks for analyzing fluorescence microscopy images of DNA polymerase molecules and processing force measurement data. All scripts process data in `.tdms` format, and used together, they can provide insights into the dynamics of DNA polymerase activity. An example trace is provided in the folder `example data analysis`

## Dependencies

- python==3.9
- jupyterlab==3.0.12
- matplotlib==3.3.4
- more-itertools==8.7.0
- npTDMS==1.1.0
- numpy==1.20.1
- opencv-python==4.5.1.48
- pandas==1.2.3
- scipy==1.6.1
- tifffile==2021.3.5
- sympy

## Overview

1. [Calculating DNA Polymerase Trace (OT)](1_CalculatingDNApTrace_OT.ipynb): Calculate the end-to-end distance between two optically trapped beads. This distance includes fractions of ssDNA and dsDNA. The notebook aids in determining the percentages of ssDNA and dsDNA, as well as the junction position between them. Finally, the variations in this junction position are plotted over time.

2. [Correlation between Image and Force](2_Correlation_image_force.ipynb): This notebook focuses on extracting DNAp-bound events. It uses the AutoStepfinder tool in MATLAB to detect the step behavior in the fluorescence intensity of DNAp.

3. [Correlated Segment Analysis](3_Correlated_segement_analysis.ipynb): This notebook dives further into the correlated segment analysis. 

4. [Heatmap of Intensity vs. Activity](4_Heatmap_intensity_activity.ipynb): Starts by verifying data from steps 1 and 2. It then proceeds to plot a correlation heatmap. The analysis delves deep into the correlation heatmap data, focusing on ratios of non-fluorescent pausing to all pausing events and further nuances of the data.

### Example Trace:
An example trace of the analysis is provided in the folder example data analysis. Users can refer to this example to understand the expected outcomes at each step of the process. Please use the `example_dataset` for a [walkthrough](example_dataset).

### Usage:
- Begin with the notebook 1_CalculatingDNApTrace_OT.ipynb and follow the instructions.
Proceed sequentially through the notebooks.

- Make sure to check and adjust settings, especially when switching to MATLAB in the second notebook.

- Always record the starting and ending times of exo and pol as they define the ROI.
Ensure the MATLAB setup is correct, especially when using the AutoStepfinder tool.

- Some notebooks might require additional tools or software. Ensure you have them installed and properly configured.


# 🛡 Disclaimer

All codes listed in this repository are developed by Longfu Xu (longfuxu.com) during the phD work in [Gijs Wuite Group](http://www.gijswuite.com/).

Please note that the code in this repository is custom written for internal lab use and still may contain bugs; we highly welcome contributions!


Developer:

Longfu Xu (longfuxu.com) . Maintenance, development, support. For questions or reports, e-mail: [longfu2.xu@gmail.com](mailto:l2.xu@vu.nl)

# 🚀 Contributing
We highly welcome contributions! For contribution please contact Longfu xu or Prof. Gijs Wuite