# Mapping Fast DNA Polymerase Exchange at the Replication Fork

This repository offers a suite of Jupyter notebooks designed for the analysis of DNA polymerase dynamics at the replicaiton fork using fluorescence microscopy images and force measurement data. It provides tools for in-depth understanding of DNA polymerase activities at the molecular level. All scripts process data in `.tdms` format, and an example trace is provided in the folder `example data analysis`.

## Dependencies and requirements
To ensure smooth operation, please install the following dependencies:
- Python (version 3.9 or above)
- JupyterLab (version 3.0.12)
- Other Python packages as listed in `requirements.txt`

## Quick Start
1. Clone the repository: `git clone https://github.com/longfuxu/DNAPolymeraseProject.git`
2. Install dependencies: `pip install -r requirements.txt`
3. Navigate to the `example data analysis` folder to see a walkthrough with sample data.
**Note**The MATLAB engine used in the second notebook is not a package that can be installed via pip. Users need to install this separately following the instructions on the MathWorks website.

## Overview of Notebooks
1. **Calculating DNA Polymerase Trace (OT)**: Analyzes mechanical data from Optical Tweezer systems.This [Calculating DNA Polymerase Trace (OT)](1_CalculatingDNApTrace_OT.ipynb) notebook is designed to process and analyze the mechanical data from Optical Tweezer system. The script reads data from a TDMS file, plots force against time, and performs analysis on specific cycles related to DNA polymerase and exonuclease activities. It starts by calculating the end-to-end distance between two optically trapped beads. This distance includes fractions of ssDNA and dsDNA. The notebook aids in determining the percentages of ssDNA and dsDNA, as well as the junction position between them. Finally, the variations in this junction position are plotted over time.
2. **Correlation between Image and Force**: Correlates image data with force measurements for DNAp-bound events.This [Correlation between Image and Force](2_Correlation_image_force.ipynb) notebook, provides a comprehensive tool for analyzing the correlation between image data and force measurements,aiming on extracting DNAp-bound events. It includes data import, processing, detailed analysis, visualization, and exporting results. It uses the AutoStepfinder tool in MATLAB to detect the step behavior in the fluorescence intensity of DNAp. - The notebook is pre-configured with certain parameters and file paths. Adjust these according to your data. Ensure all dependencies are installed before running the notebook.
3. **Correlated Segment Analysis**: Dedicated to the analysis of correlated segments in DNA polymerase activities.This [Correlated Segment Analysis](3_Correlated_segement_analysis.ipynb) notebook is dedicated to the analysis of correlated segments.Please run the notebook cells in sequence to avoid any dependencies issues. Also, modify and adapt the code as needed for your specific data analysis requirements.
4. **Heatmap of Intensity vs. Activity**: Generates heatmaps correlating DNAp activity data with fluorescence intensity.This [Heatmap of Intensity vs. Activity](4_Heatmap_intensity_activity.ipynb) notebook starts by binarize the DNAP activity data with a threshold (refer to manuscript), and then proceeds to plot a correlation heatmap. The analysis delves deep into the correlation heatmap data, focusing on ratios of non-fluorescent pausing to all pausing events and further nuances of the data.

## Example Trace:
An example trace of the analysis is provided in the folder example data analysis. Users can refer to this example to understand the expected outcomes at each step of the process. Please use the `example_dataset` for a [walkthrough](example_dataset).

## Example analysis:
#### Step1.0_Download and prepare the code
- Download the analysis code and the example data by `git clone https://github.com/longfuxu/DNAPolymeraseProject.git`, follow the instructions and have fun.
- Begin with the notebook `1_CalculatingDNApTrace_OT.ipynb`.Always record the starting and ending times of exo and pol as they define the ROI.
#### Step1.1_Get your interested cycle
![first_cycle](example_dataset/force%20data/20190529-143504%2030nM%20DNAp%20%2B%20trx%20%20%2B%20625uM%20dNTPs%20%23012-001-cycle%2301-DataFit2Model.png)
#### Step1.2_Calculate the ssDNAS%
![first_cycle](example_dataset/force%20data/20190529-143504%2030nM%20DNAp%20%2B%20trx%20%20%2B%20625uM%20dNTPs%20%23012-001-cycle%2301-ssDNA_percentage.png)
#### Step1.3_Find the ssDNA/dsDNA Junctions (the thick green line)
![first_cycle](example_dataset/force%20data/20190529-143504%2030nM%20DNAp%20%2B%20trx%20%20%2B%20625uM%20dNTPs%20%23012-001-cycle%2301-DNApTraces.png)

- Now let's proceed to the second notebook `2_Correlation_image_force.ipynb`.
#### Step2.1_Read into the protein kymograph
![first_cycle](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%231-protein_traj.png)

#### Step2.2_Read into the junciton position from step 1.3 and correlate it with the protein kymograph
![first_cycle](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-overlap-optimizing.png)

#### Step2.3_Extract the fluorescence intensity along DNAp trajectory and correlate it with the DNAp activity
![Squeezed DNAp Trace](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-Squeezed%20DNAp%20Trace.png)
![raw Bp intensity](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-raw%20Bp%20-intensity%20along%20DNAp%20Trajectory.png)

#### Step2.4_Filter the background noise and step-fitting the data
![Intensity along DNA polymerase Trajectory](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301Intensity%20along%20DNA%20polymerase%20Trajectory-1.png)
![Step Intensity along DNAp](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-Intensity%20along%20DNA%20polymerase%20Trajectory.png)
![Filtered and Binarized Intensity](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-filtered%20and%20binirized%20intensity.png)
- Make sure to check and adjust settings, especially when switching to MATLAB in the second notebook. Ensure the MATLAB setup is correct, especially when using the AutoStepfinder tool.

#### Step2.4_Let's visualize all the correlated now
![DNA Polymerase Trace-2](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-DNA%20Polymerase%20Trace-2.png)
![raw basepairs-Binarized intensity](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-raw%20basepairs-Binarized%20intensity.png)
![all_correlated-zoomin](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%2301-all_correlated-zoomin.png)

#### Step3.1_Now let's plot the DNAp activity bursts and correlate them with the binarized fluorescence signal
![Activity Burst Correlates with Fluorescence Signal-zoomedin](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%231-Activity%20Burst%20Correlates%20with%20Fluorescence%20Signal-zoomedin.png)
#### Step3.2_Segementize the DNAP events in exo and pol (exo as an example here)
![exo-segments](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%231-exo-segments.png)

#### Step4.1_Now let's binarize the DNAp activity using a threshold (see publication) and transform the two binarized data into a matrix
 ![correlation heatmap updated](example_dataset/image%20data/20190529-143510%2030nM%20DNAp%20+%20trx%20%20+%20625uM%20dNTPs%20%23012-001-cycle%231-correlation_heatmap_updated.png)

#### Note
Please be noted in these notebooks, some of the code block are filled with values or commented out for demonstration purpose, while they need to be filled with your own data values, for example the filepath, the ROI range

## Roadmap
- **UI Development**: Aiming to make this tool accessible for users without a coding background.
- **Methodology Improvement**: Adopting more Python-centric methodologies for data analysis, like this one [ bayesian_changepoint_detection_for_single_molecule_analysis](https://github.com/longfuxu/bayesian_changepoint_detection_single_molecule) 
- **Batch Analysis**: Scripting for handling large datasets efficiently.
- **Tool Integration**: Expanding capabilities to include two-protein interaction analysis, like this one [DNAP_interacting_with_SSB](https://github.com/longfuxu/DNAP_interacting_with_SSB).

## Contributing
We welcome contributions to enhance and expand this project. Please fork the repository, make your changes, and submit a pull request. For contribution you can aslo contact Longfu Xu or Prof. Gijs Wuite

## Support and Contact
Please note that the code in this repository is custom written for internal lab use and still may contain bugs. For questions, support, or feedback, please contact Dr. Longfu Xu at [longfu2.xu@gmail.com](mailto:longfu2.xu@gmail.com). 

## Citation
Xu, L. (2023) Grab, manipulate and watch single DNA molecule replication. PhD-Thesis - Research and graduation internal. Available at: https://doi.org/10.5463/thesis.424.

## License
This project is licensed under MPL-2.0 license. See `LICENSE` file for more details.

## Acknowledgments
All codes listed in this repository are developed by Dr. Longfu Xu (longfuxu.com) during the PhD work in [Gijs Wuite Lab](http://www.gijswuite.com/). Special thanks to all contributors and supporters of this project.