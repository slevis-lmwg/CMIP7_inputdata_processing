# Landuse Datasets for CTSM

There are two parts to the landuse datasets for CMIP7.

The first part is creation of "raw" PFT datasets from which the surface datasets and landuse.timeseries files will be created. This
is:

`` shell
cd LandUseDataPrepTools
# Follow the instructions in the README files (README.md, README.configure and README.process) there
# Start with README.md
# Second go through steps in README.configure
# Third go through the process chain from README.process
```

The second part is to use those datasets to create the surface and landuse.timeseries files using `mksurfdata_esmf` which is a tool
under a CTSM checkout. Here it is checked out as a submodule in the subdirectory `ctsm5.4_for_mksurfdat`. To use it do the
following:

`` shell
cd ctsm5.4_for_mksurfdat/tools/mksurfdata_esmf
# Follow the instructions in the README.md file there
```


