```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ObservationHowto/GNSS?action=edit"
```

# GNSS ZTD observations

## Introduction
The NRT GNSS delay data contain information about the amount of water vapour above the GNSS sites. 
E-GVAP European program’s aim is to provide its EUMETNET members with European GNSS delay and water vapour estimates for operational meteorology in near real-time. Currently, the E-GVAP network consists of more than 1500 GNSS sites.
* E-GVAP Programme here: [http://egvap.dmi.dk]
## GNSS ZTD data
Raw data from GNSS sites are collected by a number of GNSS analysis centers, which process the data to estimate the Zenith Total Delays (ZTD) and other parameters. The ZTDs are then forwarded to a data server, for distribution to meteorological institutes. The observations are currently distributed from Met Office, in two different formats: BUFR that are distributed via GTS to the meteorological centers or in ASCII format, that may be download via ftp.
## Preprocessing the GNSS ZTD data
The preprocessing of these data should be local, depending if you want to have them in BUFR or ASCII format.  ASCII option needs a local script to get the files from Metoffice server and transform them from COST format (EGVAP) into OBSOUL format. (In this case there is an optional script inside scr directory in Harmonie called GNSStoOBSOUL that could transforms ascii into OBSOUL format).

Apart of the preprocessing, a White List of sites to be assimilated in your domain is needed. It will contain the values of:
```bash
   statid lat lon alt dts bias sd obserr
```
where statid is the name of the site (NNNNPPPP: NNNN=site PPPP=Procesing centre) , dts is the frequency in minutes between obs, and sd the standard deviation of that station  and obserr the observation error. You are supposed to have calculated these values before launching the experiment.

## Harmonie changes to assimilate GNSS ZTD data
scr/
* Bator and Fetch_assim_data have the white list path.
* Oulan : has the white list and gnss observation files paths and cat this one to the rest of conventional observation file.   
* include.ass: 
This script has two options about gnss bias correction: static bias correction (LSTATIC_BIAS) or variational bias correction (LVARBC_GNSS). 
For the first case, a fix bias value from each site is read from the White List and then substracted from the corresponding observation value. For the second case, VarBC, it is also  needed to set in this script the  cold start option.
```bash
 export GNSS_OBS=1            #GNSS
 export LSTATIC_BIAS=F        #Swich for bias correction or not,(T|F)
 export LVARBC_GNSS=T         #Swich for GNSS varbc
 export VARBC_COLD_START=yes  #yes/no
```

nam/
 Here it should be the White list, called list.gpssol.201512 for example 
/src/arpifs/obs_preproc/
* redgps.F90 : This routine is where the horizontal thinning is done (Cy40) , so the thinning distance  could be selected here.
/src/blacklist/
* mf_blacklist.b: here is posible to blacklist the gnss observations so to calculate the varbc coefficients. It can be done tuning to experimental the *apdss* variable.

