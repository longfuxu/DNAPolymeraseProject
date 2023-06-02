##### -*-coding:utf-8 -*-
# import all the libraries 
# python==3.10; jupyterlab==3.0.12; lumicks.pylake==0.8.1; matplotlib==3.3.4; more-itertools==8.7.0;
# npTDMS==1.1.0; numpy==1.20.1; opencv-python==4.5.1.48; pandas==1.2.3; scipy==1.6.1; tifffile==2021.3.5
from __future__ import division
import os
from sympy import *
from sympy import symbols, coth
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from nptdms import TdmsFile
from more_itertools import chunked

# Function to read TDMS file for force data
def load_tdms_force_file(filename):
    tdms_file = TdmsFile(filename)
    time = tdms_file['FD Data']['Time (ms)'][:]
    force = tdms_file['FD Data']['Force Channel 0 (pN)'][:]
    distance = tdms_file['FD Data']['Distance 1 (um)'][:]
    return np.array(time), np.array(force), np.array(distance)

# Function to get data ranges of exo and pol
def get_data_ranges(time_from_exo, time_to_exo, time_from_pol, time_to_pol, filename):
    """
    Get the data ranges for exo and pol.
    
    Parameters:
    time_from_exo (float): Starting time of exo in ms
    time_to_exo (float): Ending time of exo in ms
    time_from_pol (float): Starting time of pol in ms
    time_to_pol (float): Ending time of pol in ms
    filename(str): filename with absolute path

    Returns:
    dict: Data ranges for exo and pol
    """
    time,force, distance = load_tdms_force_file(filename)

    indtemp_exo = np.where((time <= time_to_exo) & (time >= time_from_exo))
    indtemp_pol = np.where((time <= time_to_pol) & (time >= time_from_pol))

    data_ranges = {
        'time_range_exo': time[indtemp_exo],
        'force_range_exo': force[indtemp_exo],
        'distance_range_exo': distance[indtemp_exo],
        'time_range_pol': time[indtemp_pol],
        'force_range_pol': force[indtemp_pol],
        'distance_range_pol': distance[indtemp_pol],
        'time_range_all':np.append(time[indtemp_exo], time[indtemp_pol]),
        'force_range_all': np.append(force[indtemp_exo], force[indtemp_pol]),
        'distance_range_all' : np.append(distance[indtemp_exo], distance[indtemp_pol]),
    }

    return data_ranges

# tWLC model function
def tWLC(F, Lc=2.85056, Lp=56, C=440, g0=-637, g1=17, S=1500):
    """
    Calculate the end-to-end distance (EED) of dsDNA using the tWLC model.
    parameters for tWLC model: Peter Gross, et al. Nature Physics volume 7, pages731–736(2011)
    
    Parameters:
    F (array-like): Force in pN (1D array)
    Lc (float): Contour length in um (default: 2.85056)
    Lp (float): Persistent length in nm (default: 56)
    C (float): Twist rigidity in pN nm^2 (default: 440)
    g0 (float): Twist-stretch coupling g(F) constant g0 in pN nm (default: -637)
    g1 (float): Twist-stretch coupling g(F) constant g1 in nm (default: 17)
    S (float): Stretching modulus in pN (default: 1500)

    Returns:
    np.ndarray: End-to-end distance (EED) in um (1D array)
    """
    EEDds = np.array([Lc * (1 - 0.5 * (4.1 / (Fext * Lp))**0.5 + C * Fext / (-(g0 + g1 * Fext)**2 + S * C)) for Fext in F])
    return EEDds

# FJC model function
def FJC(F, Lss=4.69504, b=1.5, Sss=800):
    """
    Calculate the end-to-end distance (EED) of ssDNA using the FJC model.
    # parameters for FJC model: Smith, S. B., et al. Science 271, 795–799 (1996).

    Parameters:
    F (array-like): Force in pN (1D array)
    Lss (float): Contour length in um (default: 4.69504)
    b (float): Kuhn length in nm (default: 1.5)
    Sss (float): Stretching modulus in pN (default: 800)

    Returns:
    np.ndarray: End-to-end distance (EED) in um (1D array)
    """
    EEDss = np.array([Lss * (coth(Fext * b / 4.1) - 4.1 / (Fext * b)) * (1 + Fext / Sss) for Fext in F])
    return EEDss

# Plot the Force_distance data
def plot_models_with_data(time_from_exo, time_to_exo, time_from_pol, time_to_pol, filename, bead_size, cycle, Force=np.linspace(0.1, 68, 1000)):
    """
    Plot the tWLC and FJC models together with the experimental data and save the figure.
    
    Parameters:
    distance_range_all (array-like): Distance data (um) from experimental results
    force_range_all (array-like): Force data (pN) from experimental results
    bead_size (float): Bead size in um
    filename (str): Filename of the experimental data file
    cycle (str): Cycle number
    Force (array-like, optional): Force range for tWLC and FJC models (default: np.linspace(0.1, 68, 1000))
    """
    # here you will select and analyze your interesting cycle with corresponding time range; 
    data_ranges = get_data_ranges(time_from_exo, time_to_exo, time_from_pol, time_to_pol, filename)

    force_range_all = data_ranges['force_range_all']
    distance_range_all = data_ranges['distance_range_all']

    # plot the figure
    plt.figure(figsize=(6, 4))
    font = {'family': 'Arial', 'weight': 'normal', 'size': 16}

    plt.xlabel('Distance (um)', fontdict=font)
    plt.ylabel('Force(pN)', fontdict=font)
    plt.plot(tWLC(Force), Force, color='red', marker='o', linestyle='dashed', linewidth=2, markersize=2, label='tWLC Model')
    plt.plot(FJC(Force), Force, color='b', marker='o', linestyle='dashed', linewidth=2, markersize=2, label='FJC Model')

    plt.legend()
    plt.ylim(-5, 72)

    plt.show()
    plt.tight_layout()

    plt.plot(distance_range_all - bead_size, force_range_all, marker='o', linestyle='solid', linewidth=2, markersize=2, label='Experimental Data')
    plt.legend()
    plt.tight_layout()
    plt.show()

    # Save the figure
    plt.savefig(filename.replace('.tdms', '-cycle#') + cycle + '-DataFit2Model' + '.eps', dpi=300)

def calculate_ssDNA_and_junction_position(time_from_exo, time_to_exo, time_from_pol, time_to_pol, filename, bead_size, direction='forward', exo_force=50, pol_force=20, total_length=8393):
    """
    Calculate ssDNA percentage and junction position change over time.
    
    Parameters:
    time_from_exo (int): Start time of the exonuclease range in seconds
    time_to_exo (int): End time of the exonuclease range in seconds
    time_from_pol (int): Start time of the polymerase range in seconds
    time_to_pol (int): End time of the polymerase range in seconds
    filename (str): File name of the experimental data
    bead_size (float): Bead size in um
    direction (str, optional): Direction of the junction position change, 'forward' or 'reverse' (default: 'forward')
    exo_force (float, optional): Force for exonuclease (default: 50)
    pol_force (float, optional): Force for polymerase (default: 20)
    total_length (int, optional): Total length of DNA in base pairs (default: 8393)

    Returns:
    tuple: ssDNA percentages, base pairs, and junction position change over time for both exonuclease and polymerase
    """
    # here you will select and analyze your interesting cycle with corresponding time range; 
    data_ranges = get_data_ranges(time_from_exo, time_to_exo, time_from_pol, time_to_pol, filename)

    # exo time range of ROI
    distance_range_exo = data_ranges['distance_range_exo']

    # pol time range of ROI
    distance_range_pol = data_ranges['distance_range_pol']

    # Calculate junction position
    dsDNA_exo_ref = tWLC(np.array([exo_force]))[0]
    dsDNA_pol_ref = tWLC(np.array([pol_force]))[0]
    ssDNA_exo_ref = FJC(np.array([exo_force]))[0]
    ssDNA_pol_ref = FJC(np.array([pol_force]))[0]

    ssDNA_exo_percentage = (distance_range_exo - bead_size - dsDNA_exo_ref) / (ssDNA_exo_ref - dsDNA_exo_ref)
    ssDNA_pol_percentage = (distance_range_pol - bead_size - dsDNA_pol_ref) / (ssDNA_pol_ref - dsDNA_pol_ref)
    ssDNA_all_percentage = np.append(ssDNA_exo_percentage, ssDNA_pol_percentage)

    basepairs = (1 - ssDNA_all_percentage) * total_length

    if direction == 'forward':
        junction_position_exo = (ssDNA_exo_percentage * ssDNA_exo_ref) * (distance_range_exo - bead_size) / ((ssDNA_exo_percentage * ssDNA_exo_ref) + (1 - ssDNA_exo_percentage) * dsDNA_exo_ref)
        junction_position_pol = (ssDNA_pol_percentage * ssDNA_pol_ref) * (distance_range_pol - bead_size) / ((ssDNA_pol_percentage * ssDNA_pol_ref) + (1 - ssDNA_pol_percentage) * dsDNA_pol_ref)
    else:  # reverse
        junction_position_exo = (distance_range_exo - bead_size) - (ssDNA_exo_percentage * ssDNA_exo_ref) * (distance_range_exo - bead_size) / ((ssDNA_exo_percentage * ssDNA_exo_ref) + (1 - ssDNA_exo_percentage) * dsDNA_exo_ref)
        junction_position_pol = (distance_range_pol - bead_size) - (ssDNA_pol_percentage * ssDNA_pol_ref) * (distance_range_pol - bead_size) / ((ssDNA_pol_percentage * ssDNA_pol_ref) + (1 - ssDNA_pol_percentage) * dsDNA_pol_ref)

    junction_position_all = np.append(junction_position_exo, junction_position_pol)

    return ssDNA_exo_percentage, ssDNA_pol_percentage, ssDNA_all_percentage,basepairs, junction_position_all


def plot_DNA_force_data(time_from_exo, time_to_exo, time_from_pol, time_to_pol, filename, junction_position_all, ssDNA_all_percentage, basepairs,  cycle, bead_size, direction='forward'):
    
    # here you will select and analyze your interesting cycle with corresponding time range; 
    data_ranges = get_data_ranges(time_from_exo, time_to_exo, time_from_pol, time_to_pol, filename)
    # all time range of ROI
    time_range_all = data_ranges['time_range_all']
    distance_range_all = data_ranges['distance_range_all']
    
    font = {'family': 'Arial', 'weight': 'normal', 'size': 16}

    fig, axs = plt.subplots(3, 1, figsize=(6, 12), sharex=True)

    # Plot ssDNA% as a function of time
    axs[0].set_ylabel('ssDNA %', fontdict=font)
    axs[0].scatter(time_range_all/1000, ssDNA_all_percentage * 100, color='black', linestyle='dashed', s=0.5, label='End-to-End Distance')
    axs[0].set_ylim(-5, 90)

    # Plot DNA polymerase trace as a function of time
    axs[1].set_ylabel('Distance(um)', fontdict=font)
    axs[1].scatter(time_range_all/1000, distance_range_all - bead_size, color='black', linestyle='dashed', s=0.5, label='End-to-End Distance')
    axs[1].scatter(time_range_all/1000, junction_position_all, color='green', s=0.5, label='DNA Polymerase Trace')
    
    if direction == 'forward': # default direction is 'forward'
        axs[1].fill_between(np.array(time_range_all/1000), distance_range_all - bead_size, junction_position_all, alpha=0.5)
    elif direction == 'reverse':
        axs[1].fill_between(np.array(time_range_all/1000), np.array(junction_position_all), alpha=0.5)
    else:
        raise ValueError("Invalid direction value. Please use 'forward' or 'reverse'.")

    axs[1].legend()
    axs[1].set_ylim(0, 4.3)
    axs[1].invert_yaxis()

    # Plot basepair changes as a function of time
    axs[2].set_xlabel('Time (s)', fontdict=font)
    axs[2].set_ylabel('Basepairs', fontdict=font)
    axs[2].plot(time_range_all/1000, basepairs, color='red', marker='o', linestyle='dashed', linewidth=2, markersize=2, label='Basepairs')
    axs[2].legend()

    plt.tight_layout()
    plt.savefig(filename.replace('.tdms', '-cycle#') + cycle + '-CombinedPlots'+'.eps', format='eps', dpi=300, bbox_inches='tight')
    plt.show()