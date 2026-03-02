# README

## Overview
This repository contains data and code supporting **Figure 3** in the manuscript titled **“Newborn Modes in Indefinite Media: A Spectral Pathway to Light Localization”**, submitted to *Nature Photonics*.

## File Structure
- **`drawFigures.m`** – MATLAB plotting function used to generate **Figures 3b, 3c, and 3d** in the manuscript.
- **`eigenvalues.mat `** – Contains the band-structure data of `gamma = 0.94242` .
- **`eigenvalue_vector.mat `** – Contains, for selected Bloch wave vector k(19), the 100 eigenvalues and corresponding eigenvectors (field values).
- **`mesh.mat `** – Contains the finite-element mesh (mesh generation / partitioning).
- **`parameters.mat `** – Contains program parameters (simulation and numerical settings).
- **`result_for_radius.mat `** – Contains, for selected Bloch wave vector k(19), the 6th eigenvalue and corresponding eigenvector (field values), for different enlarged material radius from `1.01` to `1.5`(in steps of `0.01`).


## Usage

1. Open MATLAB and navigate to the folder containing `drawFigures.m`.
2. Run `drawFigures.m` to reproduce 3b, 3c, and 3d from the manuscript.