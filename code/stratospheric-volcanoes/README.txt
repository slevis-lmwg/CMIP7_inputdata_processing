This script, authored by Ilaria Quaglia on October 2, 2025, builds upon the original script by Mike Mills, available at: https://svn.code.sf.net/p/codescripts/code/trunk/ncl/emission/SO2elevPinatubo.ncl

The script produces 3D time series of SO2 injections.

The required input variables include: the amount of SO₂ in teragrams (Tg), the eruption’s altitude and depth in kilometers, latitude and longitude in degrees, and the date and time of the eruption (year, month, day, hour, and minute). If the emission duration is not specified, it defaults to a 6-hour period from 12:00 to 18:00 UT.

The injection depth corresponds to either the 1-sigma width of a Gaussian vertical profile centered at the specified emission height, or the total vertical extent for a uniform injection.

Users can select the vertical injection profile type (Gaussian or uniform), define the grid resolution, and generate a climatology.

The script is organized as follows:
1. Modules, function and constants.

2. Create emissions file.
        2.1 Definition Phase.
        Specify the paths for the input and output files, set the horizontal and vertical resolution for the output, and choose the type of vertical injection profile. Optionally, apply scaling factors and define the time period over which the climatology is calculated.

        2.2 Load injection file. 
        Definition of the input variables and thier units. Here, the emission duration is set from 12:00 to 18:00 UT as it was not provided in the input file.
 
        2.3 Plots. 
         Visualization of the input file

        2.4 Load grid.
        The grid file specified during the definition phase is now loaded. Three predefined grid options are available: fv1 (referred to as "1deg" in the script), fv2 ("2deg"), ne30. If a custom grid is required, you can provide the path to a different grid file. In that case, be sure to: Add the custom grid option in the definition phase, Update Section 2.5 (transient output generation), Update Section 2.6 (climatology output generation).

        2.5 Create timeseries of SO2 injection profiles.
        For each eruption, two empty timesteps must be defined: one before and one after the injection period, during which no injection occurs. The injection itself takes place between these two timesteps.
Additionally, the full time series must include an initial and final empty timestep to ensure proper temporal boundaries.
It is crucial to set the global attribute "input_method" to "SERIAL" when defining the output. If this attribute is not explicitly set, it will default to "INTERP_MISSING_MONTHS", which can lead to unintended eruptions being generated in months with missing data.

        2.6 Create climatology
