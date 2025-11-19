# Population Density Dataset

popden.ncl script generates 1850-2100 or 1850-2016 file based on existing
templates.

To reduce the 1850-2100 file to a 1850-2025 file to match the length of the
raw data, one can use the nco command:
`ncks -O -d time,0,175 clmforc.Li_2025_CMIP7_hdm_0.5x0.5_simyr1850-2100_c251013.nc clmforc.Li_2025_CMIP7_hdm_0.5x0.5_simyr1850-2025_c251013.nc`

Final datasets are here:

`/glade/campaign/cesm/cesmdata/inputdata/lnd/clm2/firedata`

```
clmforc.Li_2017_HYDEv3.2_CMIP6_hdm_0.5x0.5_AVHRR_simyr1850-2016_c180202.nc
clmforc.Li_2025_CMIP7_hdm_0.5x0.5_simyr1850-2025_c251013.nc
```

Discussion on github is here:

[CMIP7 Repo](https://github.com/NCAR/CMIP7_inputdata_processing/discussions/5)
