# CMIP7_processing
Code and routines to process CMIP7 forcing datasets for use in CESM3 (Community Earth System Model). Code is developed primarily in Python.

## Input forcing datasets
Information about forcing datasets can be found at: 
- Climate Forcings Task Team: https://wcrp-cmip.org/cmip7-task-teams/forcings/ 
- Dataset overview: https://input4mips-cvs.readthedocs.io/en/latest/dataset-overviews/ 

On the UCAR HPC system, they can be found on campaign:
- raw datasets: `/glade/campaign/cesm/cesmdata/input4MIPs_raw`
- cesm-ready data in: `/glade/campaign/cesm/cesmdata/inputdata`

## Methodology
Processing is broken into different components/sources.

- anthropogenic-emissions
- biomass-burning
- co2-isotopes
- greenhouse-gases
- land-use
- nitrogen-deposition
- optical-properties
- ozone
- pop-density
- solar
- ssts
- stratospheric-volcanoes

## Previous Analysis:
CMIP6 processing tools can be found here: https://github.com/lkemmons/cesm-cmip6-emissions
