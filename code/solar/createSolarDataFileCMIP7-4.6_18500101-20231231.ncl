;======================================================================================================
; Author: Mike Mills
; Created February 2021
;
; Notes: It turns out I used a preliminary version (3.1) of the CMIP6 solar data, which has a 
; discontinuity producing a 9% jump in SSI at wavelengths longer than 70 microns. A final version (3.2) 
; was issued in 2017 that fixes this issue. The purpose of this script is to create a corrected solar 
; input file for testing climate sensitivity. 
;
; In the source files, TSI for the piControl is identical, 1360.75 W m-2. The increased SSI covers 
; 3e4 nm, with SSI elevated by about 1e-5 mW m-2 nm-1 at most. So an integrated difference of 
; 0.3 mW m-2 = 3e-4 W m-2. The climate impact is negligible.
;
; The updated file created by this script is here:
; /glade/work/mijeong/data/solar/CMIP7/SolarForcingCMIP7-4.6_18491230-20240101_sumEPP_c20250630.nc
;
; I have compared SSI and epp_ion_rates in the CCMI solar file and the updated CMIP6 file for all of 
; the dates that they overlap.
;
; SSI is identical between the 2 files.
;
; epp_ion_rates differs, with the maximum difference being 0.51%.
;
; version 4.6 (Jan 2025) - modified by Mijeong P.
;======================================================================================================

load "$CODE_PATH/ncl/lib/common.ncl"
host   = systemfunc("hostname")

sumEPP = True
;sumEPP = False

dataPath=getenv("DATA_PATH") ; on Cheyenne this is /glade/work/mijeong/data

rootpath=dataPath+"/solar/CMIP7/"
infilename=rootpath+"multiple_input4MIPs_solar_CMIP_SOLARIS-HEPPA-CMIP-4-6_gn_18500101-20231231.nc" ; cmip7 (jan 2025)
tempfile=rootpath+"temp.nc"
FirstDay=rootpath+"FirstDay.nc"
LastDay=rootpath+"LastDay.nc"

print("opening "+infilename)
ncid=addfile(infilename,"r")

;command("cp "+infilename+" "+tempfile)

;command("ncrename -v wlen,wavelength -v wlenbinsize,band_width "+tempfile)

;print("reading "+tempfile)
;ncid=addfile(tempfile,"r")

print("reading wavelength")
wavelength=ncid->wlen
wavelength!0="wavelength"
wavelength@bounds = "wavelength_bnds"

print("reading band_width")
band_width=ncid->wlenbinsize
band_width!0="wavelength"
band_width&wavelength=wavelength

print("reading wavelength_bnds")
wavelength_bnds=ncid->wlen_bnds
wavelength_bnds!0="wavelength"
wavelength_bnds&wavelength=wavelength

print("reading ssi")
ssi=ncid->ssi
print("reading f107")
f107=ncid->f107

print("averaging f107a")
f107a = runave_Wrap (f107, 81, 1)
f107a@long_name = "81-day centered mean of 10.7 cm solar radio flux (F10.7)" ;

time=ssi&time
nTimes=dimsizes(time)
nT1=nTimes-1

date=cd_calendar(time,-2)
date!0="time"
date&time=time

print("scaling ssi from W m^-2 nm^-1 to mW m^-2 nm^-1")
ssi=ssi*1000.0
ssi@units="mW m^-2 nm^-1"
ssi!1="wavelength"
ssi&wavelength=wavelength

datesec = toint((time-toint(time))*3600*24)
datesec!0="time"
datesec&time=time

if (fileexists(tempfile)) then
  command("rm "+tempfile)
end if
print("creating "+tempfile)
ncf=addfile(tempfile,"c")

; Create an UNLIMITED record dimension in the output netCDF file.  This is critical if 
;  the user plans to ever use NCO to concatenate the file along the time/record dimension.
  filedimdef(ncf,"time",-1,True)

; For a nicer looking netCDF, create a "new line" character.
; This is not necessary.
;
nl = integertochar(10)  ; newline character

globalAtt             = True

globalAtt@data_script = nl+\
   "Created by program "+get_script_name()+nl+\
   "SVN path: https://svn.code.sf.net/p/codescripts/code/trunk/ncl/solar"
globalAtt@cesm_contact = nl+\
   "Mijeong Park, mijeong@ucar.edu"
globalAtt@creation_date     = nl+\
   systemfunc("date")
globalAtt@data_source_files    = nl+\
  "https://solarisheppa.geomar.de/solarisheppa/cmip7/multiple_input4MIPs_solar_CMIP_SOLARIS-HEPPA-CMIP-4-6_gn_18500101-20231231.nc.gz"
globalAtt@Conventions = nl+\
   "CF-1.6"
globalAtt@license = nl+\
   "Solar forcing data produced by SOLARIS-HEPPA is licensed under a Creative Commons Attribution \'Share Alike\' 4.0 International License (http://creativecommons.org/licenses/by/4.0/)."+nl+\
   "The data producers and data providers make no warranty, either expressed or implied, including but not limited to, warranties of merchantability and fitness for a particular purpose."+nl+\
   "All liabilities arising from the supply of the information (including any liability arising in negligence) are excluded to the fullest extent permitted by law."
globalAtt@variable_id = nl+\
   "multiple"
globalAtt@target_mip = nl+\
   "CMIP"
globalAtt@mip_era = nl+\
   "CMIP7"
globalAtt@grid_label = nl+\
   "gn"
globalAtt@dataset_version_number = nl+\
   "4.6"
globalAtt@dataset_category = nl+\
   "solar"
globalAtt@contact = nl+\
   "bernd@iaa.es"
globalAtt@references = nl+\
   "Funke et al., Geosci. Model Dev., 17, 1217--1227, https://doi.org/10.5194/gmd-17-1217-2024, 2024"
globalAtt@contributor_name = nl+\
   "Bernd Funke, Timo Asikainen, Stefan Bender, Odele Coddington, Thierry Dudok de Wit, Illaria Ermolli, Margit Haberreiter,"+nl+\
   "Doug Kinnison, Judith Lean, Sergey Koldoboskiy, Daniel R. Marsh, Hilde Nesse, Annika Seppaelae, Miriam Sinnhuber, Ilya Usoskin, Max van de Kamp, Pekka T. Verronen"
globalAtt@metadata_url = nl+\
   "see http://solarisheppa.geomar.de/solarisheppa/sites/default/files/data/cmip7/CMIP7_metadata_description_4.6.pdf"
globalAtt@further_info_url = nl+\
   "http://solarisheppa.geomar.de/cmip7"
globalAtt@realm = nl+\
    "atmos"
globalAtt@source_id = nl+\
    "SOLARIS-HEPPA-CMIP-4-6"
globalAtt@source = nl+\
    "SSI, TSI, and F10.7 from ssi_v03r00_preliminary (Odele Coddington et al., pers. comm.); Ap and Kp from ftp.ngdc.noaa.gov until 2014,"+nl+\
    "afterwards from GFZ Potsdam (https://kp.gfz-potsdam.de), P-IPR from SEP-II (Ilya Usoskin et al., pers. comm.), MEE-IPR from FMI APEEP v2024b_cmip7 (Max van de Kamp et al., pers. comm.), GCR-IPR from CRII v2024-02 (Ilya Usoskin et al., pers. comm.)"
globalAtt@frequency = nl+\
    "day"
globalAtt@time_coverage_end = nl+\
    "2023-12-31 00:00:00"
globalAtt@time_coverage_start = nl+\
    "1850-01-01 00:00:00"
globalAtt@comment = nl+\
    "The NASA NOAA LASP (NNL) solar variability models were formerly known as the Naval Research Laboratory (NRL)solar variability models."+nl+\
    "NNL V1 models will become the operational NOAA/NCEI Solar Irradiance Climate Data Record (CDR) V3 in August 2024. The SSI and F10.7 data are taken from the preliminary V03."+nl+\
    "Sub-annual variability has been added for the period before 1874; TSI in this file is the integral over SSI from source data between 0 and 100,000nm"
globalAtt@activity_id = nl+\
    "input4MIPs"
globalAtt@institution = nl+\
    "APARC SOLARIS-HEPPA"
globalAtt@institution_id = nl+\
    "SOLARIS-HEPPA"
globalAtt@title = nl+\
    "CMIP7 solar forcing historic (1850-2023)"

fileattdef( ncf, globalAtt )

print("writing band_width")
ncf->band_width=band_width

print("writing wavelength_bnds")
ncf->wavelength_bnds=wavelength_bnds

print("writing glat_bnds")
ncf->glat_bnds=ncid->glat_bnds

print("writing date")
ncf->date=date
print("writing datesec")
ncf->datesec=datesec

print("writing tsi")
ncf->tsi=ncid->tsi

print("writing ssn")
ncf->ssn=ncid->ssn
print("writing scph")
ncf->scph=ncid->scph
print("writing scnum")
ncf->scnum=ncid->scnum
print("writing ap")
ncf->ap=ncid->ap
ncf->ap@units="nanoTeslas"
print("writing kp")
ncf->kp=ncid->kp
print("writing f107")
ncf->f107=f107
print("writing f107a")
ncf->f107a=f107a

print("writing time_bnds")
ncf->time_bnds=ncid->time_bnds

if (sumEPP) then
  ; Sum ion production rates
  print("summing epp_ion_rates")
  epp_ion_rates=ncid->iprp                ; Ion pair production rate by solar protons
  epp_ion_rates=epp_ion_rates+ncid->iprg  ; Ion pair production rate by cosmic rays
  epp_ion_rates=epp_ion_rates+ncid->iprm  ; Ion pair production rate by MEE
  epp_ion_rates@long_name="Ion pair production rate by solar protons, cosmic rays, and MEE"
  print("writing epp_ion_rates")
  ncf->epp_ion_rates=epp_ion_rates
else
  print("copying iprp, Ion pair production rate by solar protons")
  ncf->iprp=ncid->iprp 
  print("copying iprg, Ion pair production rate by cosmic rays")
  ncf->iprg=ncid->iprg 
  print("copying iprm, Ion pair production rate by MEE")
  ncf->iprm=ncid->iprm 
end if

print("writing ssi")
ncf->ssi=ssi

print("closing file "+tempfile)

delete(ncid)
delete(ncf)

; Add time for day previous to January 1, 1850
command("ncks -O -d time,0,0 "+tempfile+" "+FirstDay)
command("ncap2 -O -s 'time=time-1.0' "+FirstDay+" "+FirstDay)
command("ncap2 -O -s 'time_bnds=time_bnds-1.0' "+FirstDay+" "+FirstDay)
print("opening "+FirstDay)
ncid=addfile(FirstDay,"w")
print("reading date")
FirstDate=ncid->date
delete(time)
time=FirstDate&time
FirstDate=(/cd_calendar(time,-2)/)
print("saving FirstDate")
ncid->date=FirstDate
print("closing "+FirstDay)
delete([/ncid,time/])

; Add time for day following to December 31, 2299
command("ncks -O -d time,"+nT1+","+nT1+" "+tempfile+" "+LastDay)
command("ncap2 -O -s 'time=time+1.0' "+LastDay+" "+LastDay)
command("ncap2 -O -s 'time_bnds=time_bnds+1.0' "+LastDay+" "+LastDay)
print("opening "+LastDay)
ncid=addfile(LastDay,"w")
print("reading date")
LastDate=ncid->date
time=LastDate&time
LastDate=(/cd_calendar(time,-2)/)
print("saving LastDate")
ncid->date=LastDate
print("closing "+LastDay)
delete(ncid)

outFile=rootpath+"SolarForcingCMIP7-4.6_"+FirstDate+"-"+LastDate
if (sumEPP) then
  outFile=outFile+"_sumEPP"
else
  outFile=outFile+"_EPPsources"
end if
outFile=outFile+"_c"+creation_date+".nc"

command("ncrcat "+FirstDay+" "+tempfile+" "+LastDay+" "+outFile)
;command("rm "+tempfile)
;command("rm "+FirstDay)
;command("rm "+LastDay)

exit
