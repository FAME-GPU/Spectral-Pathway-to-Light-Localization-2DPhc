# README

## Overview
This repository contains data and code supporting **Figure 4** in the manuscript titled **“Newborn Modes in Indefinite Media: A Spectral Pathway to Light Localization”**, submitted to *Nature Photonics*.

## File Structure
- **`drawFigures.m`** – MATLAB plotting function used to generate **Figures 4b, 4c, 4e, 4f, 4h, 4i, 4k, and 4l** in the manuscript.
- **`F_data_cross_all.mat `** – Contains  the 11th  eigenvectors (field values) of  `gamma =4.0822`  and the finite-element mesh (mesh generation / partitioning), which 3*3 unit cell model and all corss-material varied with `gamma`.
- **`F_data_cross_center.mat `** – Contains  the 2th  eigenvectors (field values) of  `gamma =4.1082`  and the finite-element mesh (mesh generation / partitioning), which 3*3 unit cell model and only center corss-material varied with `gamma`.
- **`F_data_rectangle_all.mat `** – Contains  the 8th  eigenvectors (field values) of  `gamma =4.0736`  and the finite-element mesh (mesh generation / partitioning), which 5*5 unit cell model and all rectangle-material varied with `gamma`.
- **`F_data_rectangle_center.mat `** – Contains  the 3th  eigenvectors (field values) of  `gamma =4.0357`  and the finite-element mesh (mesh generation / partitioning), which 5*5 unit cell model and only center rectangle-material varied with `gamma`.
- **`FRE_cross_all.mat `** – Contains the band-structure data of `gamma = 4.0822` ，which 3*3 unit cell model and all corss-material varied with `gamma`.
- **`FRE_cross_center.mat `** – Contains the band-structure data of `gamma = 4.1082` ，which 3*3 unit cell model and only center corss-material varied with `gamma`.
- **`FRE_rectangle_all.mat `** – Contains the band-structure data of `gamma = 4.0736` ，which 5*5 unit cell model and all rectangle-material varied with `gamma`.
- **`FRE_rectangle_center.mat `** – Contains the band-structure data of `gamma = 4.0357` ，which 5*5 unit cell model and only center rectangle-material varied with `gamma`.

## Usage

1. Open MATLAB and navigate to the folder containing `drawFigures.m`.
2. Run `drawFigures.m` to reproduce 4b, 4c, 4e, 4f, 4h, 4i, 4k, and 4l from the manuscript.