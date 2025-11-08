Author: Mijeong Park (original codes from Mike Mills)

Date: November, 8, 2025

Purpose:
    This file contains information about processing the CMIP7 solar forcing data.
    Input files are downloaded from the SOLARIS-HEPPA website. Detailed descrition
    of the forcing data can be found in their website (link below)
    https://www.solarisheppa.kit.edu/75.php

    Forcing data: PI control, historical data, future forcing data, SSI sensitivity
                  experiments, auxilliary data for regridding SSI, conversion of
		  		  geomagnetic to geograpic cordinates, and the updated NOy boundary
		  	      condition
    Reference: Funke et al. (2024, doi: 10.5194/gmd-17-1217-2024)

    Metadata file: https://www.solarisheppa.kit.edu/img/CMIP7_metadata_description_4.6.pdf 

Inputs:
    1. Pre-industrial Control (PiControl)
    /glade/campaign/cesm/cesmdata/input4MIPs_raw/input4MIPs/CMIP7/CMIP/SOLARIS-HEPPA/SOLARIS-HEPPA-CMIP-4-6/atmos/fx/Multiple/gn/v20250219/
    multiple_input4MIPs_solar_CMIP_SOLARIS-HEPPA-CMIP-4-6_gn.nc

    2. Historial (1850-2023)
    /glade/campaign/cesm/cesmdata/input4MIPs_raw/input4MIPs/CMIP7/CMIP/SOLARIS-HEPPA/SOLARIS-HEPPA-CMIP-4-6/atmos/day/Multiple/gn/v20250219/multiple_input4MIPs_solar_CMIP_SOLARIS-HEPPA-CMIP-4-6_gn_18500101-20231231.nc

    3. Future Solar Forcing Dataset (2022-2299)
   /glade/campaign/cesm/cesmdata/input4MIPs_raw/input4MIPs/CMIP7/CMIP/SOLARIS-HEPPA/SOLARIS-HEPPA-CMIP-4-6/atmos/day/Multiple/gn/v20251106/multiple_input4MIPs_solar_ScenarioMIP_SOLARIS-HEPPA-ScenarioMIP-4-6-a002_gn_20220101-22991231.nc
    
Outputs:
    1. Pre-industrial Control (PiControl)
    script: createSolarDataFileCMIP7PIcontrol.ncl
    input: multiple_input4MIPs_solar_CMIP_SOLARIS-HEPPA-CMIP-4-6_gn.nc
    output: SolarForcingCMIP7piControl_c20241204.nc

    2. Historical (1850-2023)
    script: createSolarDataFileCMIP7-4.6_18500101-20231231.ncl
    input: multiple_input4MIPs_solar_CMIP_SOLARIS-HEPPA-CMIP-4-6_gn_18500101-20231231.nc
    output: SolarForcingCMIP7-4.6_18491231-20240101_sumEPP_c20250206.nc

    3. Future Solar Forcing (2022-2299)
    script: createSolarDataFileCMIP7-4.6_20220101-22991231.ncl
    input: multiple_input4MIPs_solar_ScenarioMIP_SOLARIS-HEPPA-ScenarioMIP-4-6-a002_gn_20220101-22991231.nc
    output: SolarForcingCMIP7-4.6_20211231-23000101_sumEPP_c20251106.nc

Usage:
    Please follow the steps below.

    1. Go to, https://solarisheppa.geomar.de/solarisheppa/cmip7
    Download, piControl solar forcing file (https://cloud.iaa.es/index.php/s/XaSb85EpGNYqkEw)
    Download, daily resolution reference solar forcing (https://cloud.iaa.es/index.php/s/nJFTPcnFwZ3smTo)
    Download, monthly resolution reference solar forcing (https://cloud.iaa.es/index.php/s/n7cacmRBjk5Gb8f)

    2. Copy input data to /glade/work/username/data/solar/CMIP7

    3. > tcsh
       > module load ncl
       > ncl < code.ncl

Notes:
    Additional modifications to the historical output 
    (SolarForcingCMIP7-4.6_18491231-20240101_sumEPP_c20250206.nc)

    The unit of time has to be corrected from "days since 1985-01-01" to "days since 1985-01-01 00:00:00"
    (see history in global attributes in the file)

    ncatted -a units,time,o,c,days since 1850-01-01 00:00:00 SolarForcingCMIP7-4.6_18491231-20250206_sumEPP_c20250206_old.nc
    SolarForcingCMIP7-4.6_18491231-20240101_sumEPP_c20250206.nc
