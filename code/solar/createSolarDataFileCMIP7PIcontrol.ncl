load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
host   = systemfunc("hostname")

dataPath=getenv("DATA_PATH")

rootpath=dataPath+"solar/CMIP7/"
infile="multiple_input4MIPs_solar_CMIP_SOLARIS-HEPPA-CMIP-4-6_gn.nc"  ; cmip7 (jan 2025)

ncid=addfile(rootpath+infile,"r")
fAtts = getfileatts(ncid)

ssi_in=ncid->ssi
wavelength=ncid->wlen
nwav=dimsizes(wavelength)

time=cd_inv_calendar((/0,9999/),(/1,12/),(/1,31/),(/0,0/),(/0,0/),(/0,0/),"days after 0000-01-01 00:00:00",0)

date=cd_calendar(time,-2)
date!0="time"
date&time=time

datesec = (/0, 0/)
datesec!0="time"
datesec&time=time


ssi=new((/2,nwav/),typeof(ssi_in))
ssi(0,:)=ssi_in*1000.0
ssi(1,:)=ssi_in*1000.0
ssi@units="mW m^-2 nm^-1"
ssi@long_name=ncid->ssi@long_name
ssi@standard_name=ncid->ssi@standard_name
ssi!0="time"
ssi&time=time
ssi!1="wavelength"
ssi&wavelength=wavelength

tsi=new(2,typeof(ncid->tsi))
tsi(0)=ncid->tsi
tsi(1)=ncid->tsi
tsi@units=ncid->tsi@units
tsi@long_name=ncid->tsi@long_name
tsi@standard_name=ncid->tsi@standard_name
tsi!0="time"
tsi&time=time

ssn=new(2,typeof(ncid->ssn))
ssn(0)=ncid->ssn
ssn(1)=ncid->ssn
ssn@units=ncid->ssn@units
ssn@long_name=ncid->ssn@long_name
ssn@comment=ncid->ssn@comment
ssn!0="time"
ssn&time=time

ap=new(2,typeof(ncid->ap))
ap(0)=ncid->ap
ap(1)=ncid->ap
ap@units="nanoTeslas"
ap@long_name=ncid->ap@long_name
ap!0="time"
ap&time=time

kp=new(2,typeof(ncid->kp))
kp(0)=ncid->kp
kp(1)=ncid->kp
kp@long_name=ncid->kp@long_name
kp!0="time"
kp&time=time

f107=new(2,typeof(ncid->f107))
f107(0)=ncid->f107
f107(1)=ncid->f107
f107@units=ncid->f107@units
f107@long_name="10.7 cm solar radio flux (F10.7)"
f107!0="time"
f107&time=time

f107a=f107
f107a@long_name = "81-day centered mean of 10.7 cm solar radio flux (F10.7)"

ds=dimsizes(ncid->iprp)
epp_ion_rates=new((/2,ds(1),ds(2)/),typeof(ncid->iprp))
epp_ion_rates(0,:,:)=ncid->iprp+ncid->iprg+ncid->iprm
epp_ion_rates(1,:,:)=epp_ion_rates(0,:,:)
epp_ion_rates@units=ncid->iprp@units
epp_ion_rates@long_name="Ion pair production rate by solar protons, cosmic rays, and MEE"
epp_ion_rates!0="time"
epp_ion_rates&time=time
epp_ion_rates!1="plev"
epp_ion_rates!2="glat"
epp_ion_rates&plev=ncid->plev
epp_ion_rates&glat=ncid->glat

creation_date = systemfunc("date +%Y%m%d")
outfile="SolarForcingCMIP7piControl_c"+creation_date+".nc"

command="rm "+rootpath+outfile
print((/command/))
dum=systemfunc(command)

ncf=addfile(rootpath+outfile,"c")

; Create an UNLIMITED record dimension in the output netCDF file.  This is critical if 
;  the user plans to ever use NCO to concatenate the file along the time/record dimension.
  filedimdef(ncf,"time",-1,True)
;
; For a nicer looking netCDF, create a "new line" character.
; This is not necessary.
;
  nl = integertochar(10)  ; newline character
;
; Define global attributes.
;
; globalAtt can be of any type. Here logical is used by convention.
;
globalAtt             = True

globalAtt@data_script = nl+\
     "Created by program createSolarDataFileCMIP7PIcontrol.ncl"+nl+\ 
     "SVN path: https://svn.code.sf.net/p/codescripts/code/trunk/ncl/solar"
globalAtt@cesm_contact =  nl+\
      "Mijeong Park, mjeong@ucar.edu"
globalAtt@creation_date = nl+\
      systemfunc("date")
globalAtt@data_source_files  = nl+\
      "http://solarisheppa.geomar.de/solarisheppa/sites/default/files/data/cmip7/isolarforcing-picontrol-fx_input4MIPs_solar_CMIP_SOLARIS-HEPPA-4-1_gn_18500101-18730128.nc.zip"
globalAtt@creation_date = nl+\
     "2024-06-06T18:56:15Z"
globalAtt@Conventions =  nl+\
     "CF-1.6"
globalAtt@license = nl+\
     "Solar forcing data produced by SOLARIS-HEPPA is licensed under a Creative Commons Attribution \'Share Alike\' 4.0 International License (http://creativecommons.org/licenses/by/4.0/). "+nl+\
     "The data producers and data providers make no warranty, either expressed or implied, including but not limited to, warranties of merchantability and fitness for a particular purpose. "+nl+\
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
globalAtt@references    = nl+\
     "Funke et al., Geosci. Model Dev., 17, 1217--1227, https://doi.org/10.5194/gmd-17-1217-2024, 2024"
globalAtt@contributor_name =  nl+\
     "Bernd Funke, Timo Asikainen, Stefan Bender, Odele Coddington, Thierry Dudok de Wit, Illaria Ermolli, Margit Haberreiter, Doug Kinnison, "+nl+\
     "Judith Lean, Sergey Koldoboskiy, Daniel R. Marsh, Hilde Nesse, Annika Seppaelae, Miriam Sinnhuber, Ilya Usoskin, Max van de Kamp, Pekka T. Verronen"
globalAtt@metadata_url =  nl+\
     "see http://solarisheppa.geomar.de/solarisheppa/sites/default/files/data/cmip7/CMIP7_metadata_description_4.6.pdf"
globalAtt@further_info_url = nl+\
     "http://solarisheppa.geomar.de/cmip7" 
globalAtt@realm =  nl+\
     "atmos"
globalAtt@source_id =  nl+\
     "SOLARIS-HEPPA-CMIP-4-6"
globalAtt@source = nl+\
     "SSI, TSI, and F10.7 from ssi_v03r00_preliminary (Odele Coddington et al., pers. comm.); Ap and Kp from ftp.ngdc.noaa.gov until 2014, afterwards from GFZ Potsdam (https://kp.gfz-potsdam.de), P-IPR from SEP-II (Ilya Usoskin et al., pers. comm.), MEE-IPR from FMI APEEP v2024b_cmip7 (Max van de Kamp et al., pers. comm.), GCR-IPR from CRII v2024-02 (Ilya Usoskin et al., pers. comm.)"
globalAtt@frequency =  nl+\
     "fx"
globalAtt@time_coverage_end = nl+\
     "2023-12-31"
globalAtt@time_coverage_start = nl+\
     "1850-01-01"
globalAtt@comment    = nl+\
     "The NASA NOAA LASP (NNL) solar variability models were formerly known as the Naval Research Laboratory (NRL)solar variability models."+nl+\
     "NNL V1 models will become the operational NOAA/NCEI Solar Irradiance Climate Data Record (CDR) V3 in August 2024."+nl+\
     "The SSI and F10.7 data are taken from the preliminary V03. Sub-annual variability has been added for the period before 1874;"+nl+\ 
     "TSI in this file is the integral over SSI from source data between 0 and 100,000nm"
globalAtt@activity_id = nl+\
    "input4MIPs"
globalAtt@institution = nl+\
    "APARC SOLARIS-HEPPA"
globalAtt@institution_id = nl+\
   "SOLARIS-HEPPA"
globalAtt@title = nl+\
   "CMIP7 solar forcing for PI control (fixed forcing derived from period 1850-01-01 to 1873-01-28)"

fileattdef( ncf, globalAtt )
   
ncf->band_width=ncid->wlenbinsize
print("writing tsi")
ncf->tsi=tsi
print("writing date")
ncf->date=date
print("writing datesec")
ncf->datesec=datesec
print("writing wavelength_bnds")
ncf->wavelength_bnds=ncid->wlen_bnds
print("writing ssn")
ncf->ssn=ssn
print("writing ap")
ncf->ap=ap
print("writing kp")
ncf->kp=kp
print("writing f107")
ncf->f107=f107
print("writing f107a")
ncf->f107a=f107a
print("writing epp_ion_rates")
ncf->epp_ion_rates=epp_ion_rates
print("writing ssi")
ncf->ssi=ssi

print("closing file "+outfile)

delete(ncf)
delete(ncid)
