# README

## Overview
This repository contains data and code supporting **Figure 2** in the manuscript titled **“Newborn Modes in Indefinite Media: A Spectral Pathway to Light Localization”**, submitted to *Nature Photonics*.

## File Structure
- **`drawFigures.m`** – MATLAB plotting function used to generate **Figures 2b, 2c, 2d, and 2e** in the manuscript.
- **`eig_for_band_structure.mat `** – Contains the band-structure data for different values of `gamma` ranging from `12.001` to `12.500`(in steps of `0.001`).
- **`eig_sort_dense.mat `** – Contains band data on a denser `gamma` near the bifurcation where imaginary eigenvalues merge into (or drop into) the real-eigenvalu branch.
- **`eigenvalue_vector.mat `** – Contains, for each Bloch wave vector k, the 20 eigenvalues and corresponding eigenvectors (field values).
- **`mesh.mat `** – Contains the finite-element mesh (mesh generation / partitioning).
- **`parameters.mat `** – Contains program parameters (simulation and numerical settings).

## Usage

1. Open MATLAB and navigate to the folder containing `drawFigures.m`.
2. Run `drawFigures.m` to reproduce 2b, 2c, 2d, and 2e from the manuscript.