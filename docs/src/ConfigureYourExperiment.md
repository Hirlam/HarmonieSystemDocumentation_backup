```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ConfigureYourExperiment?action=edit"
```

## Experiment configuration

## Introduction

There are several levels on configuration available in HARMONIE. The highest level of configuration is done in [config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h). It includes the environment variables, which are used to control the experimentation. In the following we describe the meaning of the different variables and are described in the order they appear in [config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h).

Host specific paths and environment variables for your system are defined in Env_system. Read more [here](../HarmonieSystemDocumentation/Installation.md).

## Build options
```bash
# **** Build and bin paths ****
# Definitions about Build, should fit with hm_rev
BUILD=${BUILD-yes}                     # Turn on or off the compilation and binary build (yes|no)
```
*BUILD* is a switch for compiling HARMONIE code (__yes__|no).

```bash
BINDIR=${BINDIR-$HM_DATA/bin}                 # Binary directory
```
*BINDIR* is the location of where your HARMONIE binaries will be installed. You can use this to point to binaries outside of your experiment. A few other options for non default configurations exists as well:

```bash
COMPILE_ENKF=${COMPILE_ENKF-"no"}             # Compile LETKF code (yes|no)
COMPILE_DABYFA=${COMPILE_DABYFA-"no"}         # Compile FA/VC code (yes|no)
SURFEX_OFFLINE_BINARIES="no"                  # Switch to compile and use offline SURFEX binaries
```

## General settings
```bash
# **** Misc, defined first because it's used later ****

CNMEXP=HARM                             # Four character experiment identifier
WRK=$HM_DATA/$CYCLEDIR                  # Work directory
```
 * *CNMEXP*: experiment identifier used by MASTERODB
 * *WRK* is the work directory. The suggested path on cca is $SCRATCH/hm_home/${EXP}/$CYCLEDIR

## Archive settings (ECMWF)
Since $SCRATCH is cleaned regularly on cca and ecgb some files are transferred to ECFS for a more permanent storage by the scripts [Archive_host1](https://hirlam.org/trac/browser/Harmonie/scr/Archive_host1) and [Archive_ecgb](https://hirlam.org/trac/browser/Harmonie/scr/Archive_ecgb). 
```bash
# **** Paths to archive ****
# We need to define ARCHIVE early since it might be used further down

ARCHIVE_ROOT=$HM_DATA/archive           # Archive root directory
ECFSLOC=ectmp                           # Archiving site at ECMWF-ECFS: "ec" or ECFS-TMP "ectmp"
ECFSGROUP=hirald                        # Group in which to chgrp the ECMWF archive, "default" or "hirald"
EXTRARCH=$ARCHIVE_ROOT/extract          # Archive for fld/obs-extractions
```
 * *ARCHIVE_ROOT* is the path to forecast file archive. **Note that at ECMWF this directory is not a permanent storage**
 * *EXTRARCH* is the path to field extraction archive. **Note that at ECMWF this directory is not a permanent storage**
 * *ECFSLOC* Archiving site at ECMWF-ECFS  (__ectmp__|ec) **Note that files archived on ectmp will be lost after 90 days.** If you wish your files to stay longer you should set ECFSLOC=ec. 
 * *ECFSGROUP* Group in which to chgrp the ECMWF archive, (__hirald__|default)

## Running Mode
```bash
# **** Running mode ****
RUNNING_MODE=research                   # Research or operational mode (research|operational)
                                        # operational implies that the suite will continue even if e.g.
                                        # observations are missing or assimilation fails

SIMULATION_TYPE=nwp                     # Type of simulation (nwp|climate)
```
 * *RUNNING_MODE* can be __research__ or operational. Operational is more forgiving in the error handling and e.g. the assimilation will be skipped if Bator doesn't find any observations. Exceptions handled by the operational mode are written to `$HM_DATA/severe_warnings.txt`
 * *SIMULATION_TYPE* Switch between __nwp__ and climate type of simulation. The climate simulations are still in an experimental stage. [See HARMONIE-Climate for cy43h2 for more information](../HarmonieClimate/HCLIM43.md)

## Model domain settings
Horizontal domain settings. Further information is available here: [HarmonieSystemDocumentation/ModelDomain](../HarmonieSystemDocumentation/ModelDomain.md)
```bash
# **** Model geometry ****
DOMAIN=DKCOEXP                          # See definitions in scr/Harmonie_domains.pm
TOPO_SOURCE=gmted2010                   # Input source for orography. Available are (gmted2010|gtopo30)
GRID_TYPE=LINEAR                        # Type of grid (LINEAR|QUADRATIC|CUBIC)
```
 * *DOMAIN* defines your domain according to the settings in [scr/Harmonie_domains.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_domains.pm) (__DKCOEXP__). The spectral truncation for your domain is determined from NLON and NLAT by [scr/Harmonie_domains.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_domains.pm). Further information on model domains are available in [HarmonieSystemDocumentation/ModelDomain](../HarmonieSystemDocumentation/ModelDomain.md)
 * *TOPO_SOURCE*: Defines input source for model orography (__gmted2010__|gtopo30). Further information available here: [hi-res topography](../HarmonieSystemDocumentation/How_to_use_hires_topography.md)
 * *GRID_TYPE*: This variable is used to define the spectral truncation used (__LINEAR__|QUADRATIC|CUBIC). GRID_TYPE is used in [scr/Climate](https://hirlam.org/trac/browser/Harmonie/scr/Cliamte) and [scr/Forecast](https://hirlam.org/trac/browser/Harmonie/scr/Forecast)

## Vertical levels
Set the number vertical levels to use. Further information is available here: [HarmonieSystemDocumentation/VerticalGrid](../HarmonieSystemDocumentation/VerticalGrid.md)
```bash
VLEV=65                                 # Vertical level definition name
                                        # HIRLAM_60, MF_60,HIRLAM_40, or
                                        # BOUNDARIES = same number of levs as on boundary file.
                                        # See the other choices from scr/Vertical_levels.pl
```

 * *VLEV* is the name of the vertical levels defined in [Vertical_levels.pl](https://hirlam.org/trac/browser/Harmonie/scr/Vertical_levels.pl) (__65__). Further information is available here: [Vertical Grid](../HarmonieSystemDocumentation/VerticalGrid.md). If you intend to run upper air assimilation you must select the same domain and level definition for which you have derived structure functions. Read more here: [Structure Functions](../HarmonieSystemDocumentation/Structurefunctions.md)

## Forecast model
Higher level forecast model settings.
```bash
# **** High level forecast options ****
NAMELIST_BASE="harmonie"                # Input for namelist generation (harmonie|alaro1)
                                        #   harmonie : The default HARMONIE namelist base nam/harmonie_namelists.pm
                                        #   alaro1   : For ALARO-1 baseline with only a few configurations available
                                        #              nam/alaro1_namelists.pm
DYNAMICS="nh"                           # Hydrostatic or non-hydrostatic dynamics (h|nh)
VERT_DISC=vfd                           # Discretization in the vertical (vfd,vfe)
                                        # Note that vfe does not yet work in non-hydrostatic mode
PHYSICS="arome"                         # Main model physics flag (arome|alaro)
SURFACE="surfex"                        # Surface flag (old_surface|surfex)
DFI="none"                              # Digital filter initialization (idfi|fdfi|none)
                                        # idfi : Incremental dfi
                                        # fdfi : Full dfi
                                        # none : No initialization (AROME case)
LSPBDC=no                               # Spectral boundary contions option off(no) | on(yes)
LGRADSP=yes                             # Apply Wedi/Hortal vorticity dealiasing
LUNBC=yes                               # Apply upper nested boundary condition
```
 * *NAMELIST_BASE*: Two different namelist sets are available (__harmonie__|alaro).
 * *DYNAMICS*: Hydrostatic or non-hydrostatic dynamics (h|__nh__)
 * *VERT_DISC*: Vertical discretization (__vfd__,vfe)
 * *PHYSICS*: HARMONIE uses either AROME or ALARO for its forecast model physics (__arome__|alaro)
 * *SURFACE*: Surface physics flag to use either the SURFEX or the ALADIN surface scheme(__surfex__|old_surface)
 * *DFI*: Digital filter initialization switch (idfi|fdfi|__none__). idfi - incremental dfi, fdfi - full dfi, none - no initialization. See [Digital filter](../HarmonieSystemDocumentation/ConfigureYourExperiment.md#Digitalfilter) for more information
 * *LSPBDC*: Specify whether the boundary conditions are spectral or not (yes|__no__)
 * *LGRADSP*: Switch to apply vorticity dealiasing (__yes__|no)
 * *LUNBC*: Switch to apply upper boundary conditions (__yes__|no)

## Physics
Physics options.
```bash
# Highlighted physics switches
CISBA="3-L"                             # Type of ISBA scheme in SURFEX. Options: "3-L" and "2-L".
CROUGH="NONE"                           # SSO scheme used in SURFEX "NONE"|"'Z01D'"|"'BE04'"
SURFEX_SEA_ICE="none"                   # Treatment of sea ice in surfex (none|sice)
MASS_FLUX_SCHEME=edmfm                  # Version of EDMF scheme (edkf|edmfm)
                                        # Only applicable if PHYSICS=arome
                                        # edkf is the AROME-MF version
                                        # edmfm is the KNMI implementation of Eddy Diffusivity Mass Flux scheme for Meso-scale
HARATU="yes"                            # Switch for HARATU turbulence scheme (no|yes)
ALARO_VERSION=0                         # Alaro version (1|0)
```
 * *CISBA*: If *SURFACE* is set to surfex this selects the type of ISBA scheme to use in SURFEX. (__3-L__|2-L). [See surfex_namelists.pm for more info.](../HarmonieSystemDocumentation/Namelists.md#surfex_namelists.pm)
 * *CROUGH*: If *SURFACE* is set to surfex this selects the sub-grid scale orography scheme used in SURFEX. (__NONE__|Z01D|BE04). [See surfex_namelists.pm for more info.](../HarmonieSystemDocumentation/Namelists.md#surfex_namelists.pm)
 * *SURFEX_SEA_ICE*: Treatment of sea ice in surfex (none|sice). [See surfex_namelists.pm for more info.](../HarmonieSystemDocumentation/Namelists.md#surfex_namelists.pm)
 * *MASS_FLUX_SCHEME*: If *PHYSICS* is set to arome choose the mass flux scheme to be used by AROME; edkf to use the AROME-MF scheme or edmfm to use the KNMI developed scheme
 * *HARATU*: Switch to use the *HARATU* turbulence scheme
 * *ALARO_VERSION*: If *PHYSICS* is set to alaro select version of ALARO to use (__0__|1)


## Assimilation
Data assimilation settings. More assimilation related settings, in particular what observations to assimilate, can be found in [include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass)
```bash
# **** Assimilation ****
ANAATMO=3DVAR                           # Atmospheric analysis (3DVAR|4DVAR|blending|none)
ANASURF=CANARI_OI_MAIN                  # Surface analysis (CANARI|CANARI_OI_MAIN|CANARI_EKF_SURFEX|none)
                                        # CANARI            : Old style CANARI
                                        # CANARI_OI_MAIN    : CANARI + SURFEX OI
                                        # CANARI_EKF_SURFEX : CANARI + SURFEX EKF ( experimental )
                                        # none              : No surface assimilation
ANASURF_MODE="before"                   # When ANASURF should be done
                                        # before            : Before ANAATMO
                                        # after             : After ANAATMO
                                        # both              : Before and after ANAATMO (Only for ANAATMO=4DVAR)
INCV="1,1,1,1"                          # Active EKF control variables. 1=WG2 2=WG1 3=TG2 4=TG1
INCO="1,1,0"                            # Active EKF observation types (Element 1=T2m, element 2=RH2m and element 3=Soil moisture) 

MAKEODB2=no                             # Conversion of ODB-1 to ODB-2 using odb_migrator

SST=BOUNDARY                            # Which SST fields to be used in surface analysis
                                        # BOUNDARY          : SST interpolated from the boundary file. ECMWF boundaries utilize a special method.
                                        #                     HIRLAM and HARMONIE boundaries applies T0M which should be SST over sea.
LSMIXBC=no                              # Spectral mixing of LBC0 file before assimilation
[ "$ANAATMO" = 3DVAR] && LSMIXBC=yes
JB_INTERPOL=no                          # Interpolation of structure functions from a pre-defined domain to your domain

```
 * *ANAATMO*: Atmospheric analysis (__3DVAR__|4DVAR|blending|none)
 * *ANASURF*: Surface analysis (CANARI|__CANARI_OI_MAIN__|CANARI_EKF_SURFEX|none). [See surfex_namelists.pm for more info.](../HarmonieSystemDocumentation/Namelists.md#surfex_namelists.pm)
 * *ANASURF_MODE*:When the surface should be called (__before__|after|both)
 * *INCV*: Active EKF control variables. 1=WG2 2=WG1 3=TG2 4=TG1 (0|1)
 * *INCO*: Active EKF observation types (Element 1=T2m, element 2=RH2m and element 3=Soil moisture) (0|1)
 * *MAKEODB2*: Option to convert ODB-1 databases to ODB-2 files for DA monitoring
 * *SST*: which sea surface temperature field to use in the surface analysis
 * *LSMIXBC* Spectral mixing of LBC0 file before assimilation (__no__|yes)
 * *JB_INTERPOL* Interpolation of structure functions from a pre-defined domain to your domain (__no__|yes). Note that this has to be used with some caution.

## Observations
```bash
# **** Observations ****
OBDIR=$HM_DATA/observations             # Observation file directory
RADARDIR=$HM_DATA/radardata             # Radar observation file directory
SINGLEOBS=no                            # Run single obs experiment with observation created by scr/Create_single_obs (no|yes)

USE_MSG=no                              # Use MSG data for adjustment of inital profiles, EXPERIMENTAL! (no|yes)
MSG_PATH=$SCRATCH/CLOUDS/               # Location of input MSG FA file, expected name is MSGcloudYYYYMMDDHH
```
 * *OBDIR*: Defines the directory that your (BUFR) observation files (obYYYYMMDDHH) are to read from
 * *RADARDIR*: Defines the directory that your (OPERA HDF5) radar observation files are to be read from. BALTRAD OPERA HDF5, MF BUFR and LOCAL files are treated in [scr/Prepradar](https://hirlam.org/trac/browser/Harmonie/scr/Prepradar)
 * *SINGLEOBS* Run single obs experiment with synthetic observation created by [source:Harmonie/scr/Create_single_obs scr/Create_single_obs) (__no__|yes)
 * *USE_MSG*: Use MSG data for adjustment of inital profiles, EXPERIMENTAL! (__no__|yes)
 * *MSG_PATH*:  Location of input MSG FA file, expected name is MSGcloudYYYYMMDDHH. Note that the pre-processing software to generate input files is not yet included in HARMONIE

## 4DVAR settings
4DVAR settings (experimental)
```bash
# **** 4DVAR ****
NOUTERLOOP=1                            # 4DVAR outer loops, need to be 1 at present
ILRES=2,2                               # Resolution (in parts of full) of outer loops
TSTEP4D=360,360                         # Timestep length (seconds) of outer loops TL+AD
TL_TEST=yes                             # Only active for playfile tlad_tests
AD_TEST=yes                             # Only active for playfile tlad_tests
```
 * *NOUTERLOOP*: Number of outer loops, need to be 1 at present
 * *ILRES*:  Resolution (in parts of full) of outer loops
 * *TSTEP4D*: Timestep length (seconds) of outer loops TL+AD
 * *TL_TEST*: Only active for playfile tlad_tests (__yes__|no)
 * *AD_TEST*: Only active for playfile tlad_tests (__yes__|no)

## Digital filter settings
Digital filter initialization settings if DFI is not equal to "none"
```bash
# **** DFI setting ****
TAUS=5400                               # cut-off frequency in second
TSPAN=5400                              # 7200s or 5400s
```
 * *TAUS* cut-off frequency in seconds 
 * *TSPAN* length of DFI run in seconds



## Boundaries and initial conditions
Settings for generation of lateral boundaries conditions for HARMONIE. Further information is available here: [HarmonieSystemDocumentation/BoundaryFilePreparation](../HarmonieSystemDocumentation/BoundaryFilePreparation.md)
```bash
# **** Lateral boundary conditions ****
HOST_MODEL="ifs"                        # Host model (ifs|hir|ald|ala|aro)
                                        # ifs : ecmwf data
                                        # hir : hirlam data
                                        # ald : Output from aladin physics
                                        # ala : Output from alaro physics
                                        # aro : Output from arome physics

HOST_SURFEX="no"                        # yes if the host model is run with SURFEX
SURFEX_INPUT_FORMAT=lfi                 # Input format for host model run with surfex (lfi|fa)

NBDMAX=12                               # Number of parallel interpolation tasks
BDLIB=ECMWF                             # Boundary experiment, set:
                                        # ECMWF to use MARS data
                                        # RCRa  to use RCRa data from ECFS
                                        # Other HARMONIE/HIRLAM experiment

BDDIR=$HM_DATA/${BDLIB}/archive/@YYYY@/@MM@/@DD@/@HH@   # Boundary file directory,
                                                        # For more information, read in scr/Boundary_strategy.pl
INT_BDFILE=$WRK/ELSCF${CNMEXP}ALBC@NNN@                 # Interpolated boundary file name and location

BDSTRATEGY=simulate_operational # Which boundary strategy to follow
                                # as defined in scr/Boundary_strategy.pl
                                #
                                # available            : Search for available files in BDDIR, try to keep forecast consistency
                                #                        This is ment to be used operationally
                                # simulate_operational : Mimic the behaviour of the operational runs using ECMWF LBC,
                                #                        i.e. 6 hour old boundaries
                                # same_forecast        : Use all boundaries from the same forecast, start from analysis
                                # analysis_only        : Use only analysises as boundaries
                                # era                  : As for analysis_only but using ERA interim data
                                # latest               : Use the latest possible boundary with the shortest forecast length
                                # RCR_operational      : Mimic the behaviour of the RCR runs, ie
                                #                        12h old boundaries at 00 and 12 and
                                #                        06h old boundaries at 06 and 18
                                # enda                 : use ECMWF ENDA data for running ensemble data assimilation
                                #                        or generation of background statistic.
                                #                        Note that only LL up to 9h is supported
                                #                        with this you should set your ENSMSEL members
                                # eps_ec               : ECMWF EPS members (on reduced gaussian grid)
                                #                      : Only meaningful with ENSMSEL non-empty, i.e., ENSSIZE > 0

BDINT=1                         # Boundary interval in hours

SURFEX_PREP="yes"                # Use offline surfex prep facility (Alt. gl + Fullpos + prep )
```
 * *HOST_MODEL* defines the host model that provides the lateral boundaries conditions for your experiment
   * hir for HIRLAM.
   * ald for ALADIN 
   * ala for ALARO
   * aro for AROME
   * ifs for ECMWF-IFS. 
 * *HOST_SURFEX* Set to yes if host model runs with SURFEX. (__no__|yes)
 * *SURFEX_INPUT_FORMAT* Input format for host model run with surfex (__lfi__|fa)

 * *BDLIB* is the experiment to be used as boundaries. Possible values, __ECMWF__ for IFS from MARS (default), __RCRa__ for HIRLAM-RCR from ECFS or other __HARMONIE experiment__. 
 * *BDDIR* is the boundary file directory. The possible date information in the path must be given by using UPPER CASE letters (@YYYY@=year,@MM@=month,@DD@=day,@HH@=hour,@FFF@=forecast length).  
 * *BDSTRATEGY* Which boundary strategy to follow i.e. How to find the right boundaries with the right age and location. [Read more](../HarmonieSystemDocumentation/BoundaryFilePreparation.md#Boundarystrategies)
 * *BDINT* is boundary interval in hours.
 * *BDCLIM* is the path to climate files corresponding the boundary files, when nesting HARMONIE to HARMONIE.
 * *INT_BDFILE* is the name and location of the interpolated boundary files. These files are removed every cycle, but if you wish to save them you can specify a more permanent location here. By setting INT_BDFILE=$ARCHIVE the interpolated files will be stored in your archive directory.
 * *NBDMAX* Number of parallel boundary interpolation tasks in mSMS. The current default value is 12.
 * *SURFEX_PREP* Use SURFEX tool PREP instead of gl+FULLPOS to prepare SURFEX initial conditions. This is now the default. The gl+FULLPOS version is still working but will not be maintained in the future (no|__yes__)

Read more about the boundary file preparation [here](../HarmonieSystemDocumentation/BoundaryFilePreparation.md).

## Ensemble mode settings

```bash
# *** Ensemble mode general settings. ***
# *** For member specific settings use msms/harmonie.pm ***
ENSMSEL=                                # Ensemble member selection, comma separated list, and/or range(s):
                                        # m1,m2,m3-m4,m5-m6:step    mb-me == mb-me:1 == mb,mb+1,mb+2,...,me
                                        # 0=control. ENSMFIRST, ENSMLAST, ENSSIZE derived automatically from ENSMSEL.
ENSINIPERT=                             # Ensemble perturbation method (bnd). Not yet implemented: etkf, hmsv.
ENSCTL=                                 # Which member is my control member? Needed for ENSINIPERT=bnd. See harmonie.pm.
ENSBDMBR=                               # Which host member is used for my boundaries? Use harmonie.pm to set.
ENSMFAIL=0                              # Failure tolerance for all members.
ENSMDAFAIL=0                            # Failure tolerance for members doing own DA. Not implemented.
SLAFK=1.0                               # best set in harmonie.pm
SLAFLAG=0                               # --- " ---
SLAFDIFF=0                              # --- " ---

# *** This part is for EDA with observations perturbation
PERTATMO=none                           # ECMAIN  : In-line observation perturbation using the default IFS way.
                            			# CCMA    : Perturbation of the active observations only (CCMA content)
	                            		#           before the Minimization, using the PERTCMA executable.
                            			# none    : no perturbation of upper-air observations

PERTSURF=none                           # ECMA    : perturb also the surface observation before Canari (recommended
                            			#         : for EDA to have full perturbation of the initial state).
                                        # model   : perturb surface fields in grid-point space (recursive filter)
			                            # none    : no perturbation for surface observations.

FESTAT=no                               # Extract differences and do Jb calculations (no|yes)

```

 * *ENSMSEL*  Ensemble member selection, comma separated list, and/or range(s):
    # m1,m2,m3-m4,m5-m6:step    mb-me == mb-me:1 == mb,mb+1,mb+2,...,me
    # 0=control. ENSMFIRST, ENSMLAST, ENSSIZE derived automatically from ENSMSEL.
 * *ENSINIPERT* Ensemble perturbation method (bnd). Not yet implemented: etkf, hmsv, slaf.
 * *ENSMFAIL* Failure tolerance for all members. Not yet implemented.
 * *ENSMDAFAIL* Failure tolerance for members doing own DA. Not yet implemented.
 * *ENSCTL* Which member is my control member? Needed for ENSINIPERT=bnd. See harmonie.pm.
 * *ENSBDMBR* Which host member is used for my boundaries? Use harmonie.pm to set.
 * *SLAFK* Perturbation coefficients for SLAF, experimental
 * *SLAFLAG* Time lag for boundaries in SLAG, experimental

 For member dependent settings see [msms/harmonie.pm](https://hirlam.org/trac/browser/Harmonie/msms/harmonie.pm).

 * *PERTATMO* Observation perturbation with three options 
   * ECMA: In-line observation perturbation using the default IFS way.
   * CCMA    : Perturbation of the active observations only (CCMA content) before the Minimization, using the PERTCMA executable.
   * none    : no perturbation of upper-air observations

  * *PERTSURF* Perturbation of surface observations before Canari (recommended for EDA to have full perturbation of the initial state) (__no__|yes).


 * *FESTAT* Extract differences and do Jb calculations (__no__|yes). Read more about the procedure [here](../HarmonieSystemDocumentation/Structurefunctions_ensys.md).


## Climate file settings
Climate file generation settings. Further information is available here: [HarmonieSystemDocumentation/ClimateGeneration](../HarmonieSystemDocumentation/ClimateGeneration.md)
```bash
# **** Climate files ****
CREATE_CLIMATE=${CREATE_CLIMATE-yes}    # Run climate generation (yes|no)
CLIMDIR=$HM_DATA/climate                # Climate files directory
BDCLIM=$HM_DATA/${BDLIB}/climate        # Boundary climate files (ald2ald,ald2aro)
                                        # This should point to intermediate aladin 
                                        # climate file in case of hir2aro,ifs2aro processes.

# Physiography input for SURFEX
ECOCLIMAP_VERSION=2.2                   # Version of ECOCLIMAP for surfex (1,2)
                                        # Available versions are 1.1-1.5,2.0-2.2
SOIL_TEXTURE_VERSION=FAO                # Soil texture input data FAO|HWSD_v2
```
 * *CREATE_CLIMATE*: Run climate generation (__yes__|no). If you already have a full set of climate files generated in CLIMDIR you can set this flag to no for a faster run.
 * *CLIMDIR*: path to the generated climate files for your specific domain. The input data for the climate generation is defined by HM_CLDATA defined in Env_system -> config-sh/config.YOURHOST
 * *BDCLIM*: path to intermediate climate files
 * *ECOCLIMAP_VERSION* is the version of ECOCLIMAP to be used with SURFEX. Available versions are 1.1-1.5,2.0,2.1,__2.2__. [See surfex_namelists.pm for more info.](../HarmonieSystemDocumentation/Namelists.md#surfex_namelists.pm)
 * *SOIL_TEXTURE_VERSION* Soil texture input data (__FAO__|HWSD_v2). [See surfex_namelists.pm for more info.](../HarmonieSystemDocumentation/Namelists.md#surfex_namelists.pm)

## Archiving settings
```bash
# **** Archiving settings ****
ARCHIVE_ECMWF=yes                       # Archive to $ECFSLOC at ECMWF (yes|no)
# Archiving selection syntax, settings done below
#
# [fc|an|pp]_[fa|gr|nc] : Output from
#  an : All steps from upper air and surface analysis
#  fc : Forecast model state files from upper air and surfex
#  pp : Output from FULLPOS and SURFEX_LSELECT=yes (ICMSHSELE+NNNN.sfx)
# in any of the formats if applicable
#  fa : FA files
#  gr : GRIB[1|2] files
#  nc : NetCDF files
# sqlite|odb|VARBC|bdstrategy : odb and sqlite files stored in odb_stuff.tar
# fldver|ddh|vobs|vfld : fldver/ddh/vobs/vfld files
# climate : Climate files from PGD and E923
# Some macros
# odb_stuff=odb:VARBC:bdstrategy:sqlite
# verif=vobs:vfld
# fg : Required files to run the next cycle
```

## Forecast output
```bash
# **** Cycles to run, and their forecast length ****

TFLAG="h"                               # Time flag for model output. (h|min)
                                        # h   = hour based output
                                        # min = minute based output


# The unit of HWRITUPTIMES, FULLFATIMES, ..., SFXFWFTIMES should be:
#   - hours   if TFLAG="h"
#   - minutes if TFLAG="min"

# Writeup times of # history,surfex and fullpos files
# Comma separated list, and/or range(s) like:
# t1,t2,t3-t4,t5-t6:step    tb-te == tb-te:1 == tb,tb+1,tb+2,...,te

if [ -z "$ENSMSEL"] ; then
  # Standard deterministic run
  HH_LIST="00-21:3"                       # Which cycles to run, replaces FCINT
  LL_LIST="12,3"                          # Forecast lengths for the cycles [h], replaces LL, LLMAIN
                                          # The LL_LIST list is wrapped around if necessary, to fit HH_LIST
  HWRITUPTIMES="00-21:3,24-60:6"          # History file output times
  FULLFAFTIMES=$HWRITUPTIMES              # History FA file IO server gather times
  PWRITUPTIMES="00-60:3"                  # Postprocessing times
  PFFULLWFTIMES=-1                        # Postprocessing FA file IO server gathering times
  VERITIMES="00-60:1"                     # Verification output times, may change PWRITUPTIMES
  SFXSELTIMES=$HWRITUPTIMES               # Surfex select file output times
                                          # Only meaningful if SURFEX_LSELECT=yes
  SFXSWFTIMES=-1                          # SURFEX select FA file IO server gathering times
  SWRITUPTIMES="00-06:3"                  # Surfex model state output times
  SFXWFTIMES=$SWRITUPTIMES                # SURFEX history FA file IO server gathering times
  if [ "$SIMULATION_TYPE" == climate]; then  #Specific settings for climate simulations
    HWRITUPTIMES="00-760:6"                 # History file output times
    FULLFAFTIMES="00-760:24"                # History FA file IO server gather times
    PWRITUPTIMES=$HWRITUPTIMES              # Postprocessing times
    VERITIMES=$HWRITUPTIMES                 # Verification output times, may change PWRITUPTIMES
    SFXSELTIMES=$HWRITUPTIMES               # Surfex select file output times - Only meaningful if SURFEX_LSELECT=yes
    SWRITUPTIMES="00-760:12"                # Surfex model state output times
    SFXWFTIMES=$SWRITUPTIMES                # SURFEX history FA file IO server gathering times
  fi

  ARSTRATEGY="climate:fg:verif:odb_stuff: \
              [an|fc]_fa:pp_grb"          # Files to archive on ECFS, see above for syntax

else
  # EPS settings
  HH_LIST="00-21:3"                       # Which cycles to run, replaces FCINT
  LL_LIST="36,3,3,3"                      # Forecast lengths for the cycles [h], replaces LL, LLMAIN
  HWRITUPTIMES="00-06:3"                  # History file output times
  FULLFAFTIMES=$HWRITUPTIMES              # History FA file IO server gather times
  PWRITUPTIMES="00-48:1"                  # Postprocessing times
  PFFULLWFTIMES=-1                        # Postprocessing FA file IO server gathering times
  VERITIMES="00-60:3"                     # Verification output times, may change PWRITUPTIMES
  SFXSELTIMES=$HWRITUPTIMES               # Surfex select file output times
                                          # Only meaningful if SURFEX_LSELECT=yes
  SFXSWFTIMES=-1                          # SURFEX select FA file IO server gathering times
  SWRITUPTIMES="00-06:3"                  # Surfex model state output times
  SFXWFTIMES=$SWRITUPTIMES                # SURFEX history FA file IO server gathering times

  ARSTRATEGY="climate:fg:verif:odb_stuff: \
              an_fa:pp_grb"               # Files to archive on ECFS, see above for syntax

fi

```

The writeup times of model output can be defined as a space separated list or as a fixed frequency for model history files, surfex files and postprocessed files respectively. The unit of the steps of WRITUPTIMES, SWRITUPTIMES, PWRITUPTIMES and OUTINT should be in hours or minutes depending on the **TFLAG** Regular output interval can be switched on by setting OUTINT>0. Consequently, OUTINT will override the WRITUPTIMES lists!

 * *TFLAG*: Time flag for model output. Hourly or minute-based output (__h__|min)
 * *HWRITUPTIMES*:  Output list for history files. Default is "00-21:3,24-60:6" which will output files every 3 hours for 00-21 and every 6 hours for 24-60.
 * *VERITIMES*:  Output list for verification files. Default is "00-60:1" which will produce file every 1 hour for 00-60
 * *SWRITUPTIMES*  Output list for surfex files. Default is "00-06:3" which output a  SURFEX file every 3 hours for 00-06.
 * *PWRITUPTIMES*  Output list for fullpos (post-processed) files. Default is "00-21:3,24-60:6" which will output files every 3 hours for 00-21 and every 6 hours for 24-60.



```bash
SURFEX_LSELECT="yes"                    # Only write selected fields in surfex outpute files. (yes|no)
                                        # Check nam/surfex_selected_output.pm for details.
                                        # Not tested with lfi files.
INT_SINI_FILE=$WRK/SURFXINI.fa          # Surfex initial file name and location

# **** Postprocessing/output ****
IO_SERVER=yes                           # Use IO server (yes|no). Set the number of cores to be used
                                        # in your Env_submit
IO_SERVER_BD=yes                        # Use IO server for reading of boundary data
POSTP="inline"                          # Postprocessing by Fullpos (inline|offline|none).
                                        # See Setup_postp.pl for selection of fields.
                                        # inline: this is run inside of the forecast
                                        # offline: this is run in parallel to the forecast in a separate task

FREQ_RESET_TEMP=3                       # Reset frequency of max/min temperature values in hours, controls NRAZTS
FREQ_RESET_GUST=1                       # Reset frequency of max/min gust values in hours, controls NXGSTPERIOD
                                        # Set to -1 to get the same frequency _AND_ reset behaviour as for min/max temperature
                                        # See yomxfu.F90 for further information.

```

 * *SURFEX_LSELECT*: Switch to write a selection of fields in SURFEX output files (__yes__|no). [See surfex_selected_output.pm for more info.](../HarmonieSystemDocumentation/Namelists.md#surfex_selected_output.pm)

 * *INT_SINI_FILE*: name and location of the initial SURFEX file
 * *ARCHIVE_ECMWF*: archive files to ECFSLOC at ECMWF (__yes__|no)
 * *IO_SERVER*: Use IO server (yes|__no__). If set to "yes" changes may be required in Env_submit -> config-sh/submit.YOURHOUST
 * *POSTP*: Postprocessing by Fullpos (__inline__|offline|none).
 * *FREQ_RESET_[TEMP|GUST]*: Reset frequency of max/min values in hours, controls NRAZTS. Default is every 3/1 hours


```bash
# **** GRIB ****
CONVERTFA=yes                           # Conversion of FA file to GRIB/nc (yes|no)
ARCHIVE_FORMAT=GRIB1                    # Format of archive files (GRIB1|GRIB2|nc). nc format yet only available in climate mode
NCNAMES=nwp                             # Nameing of NetCDF files follows (climate|nwp) convention.
RCR_POSTP=no                            # Produce a subset of fields from the history file for RCR monitoring
                                        # Only applicable if ARCHIVE_FORMAT=GRIB
MAKEGRIB_LISTENERS=1                    # Number of parallel listeners for Makegrib
                                        # Only applicable if ARCHIVE_FORMAT=GRIB

```

More options on fullpos postprocessing can be found in [browser:trunk/harmonie/scr/Select_posp.pl Select_postp.pl]

 * *CONVERTFA*: Conversion of FA files to GRIB or NetCDF (__yes__|no)
 * *ARCHIVE_FORMAT*: Format of archive files (__GRIB1__|nc). NetCDF format yet only available in climate mode
 * *RCR_POSTP* Produce a subset of fields from the history file for RCR monitoring (yes|__no__). This is only applicable if ARCHIVE_FORMAT=GRIB1|GRIB2
 * *MAKEGRIB_LISTENERS*: Number of parallel listeners for Makegrib. Only applicable if ARCHIVE_FORMAT=GRIB1|GRIB2

More options on file conversion can be found in [browser:trunk/harmonie/scr/Makegrib scr/Makegrib]


## Verification and monitoring


```bash
# **** Verification extraction ****
OBSEXTR=yes                             # Extract observations from BUFR (yes|no)
FLDEXTR=yes                             # Extract model data for verification from model files (yes|no)
FLDEXTR_TASKS=1                         # Number of parallel tasks for field extraction
VFLDEXP=$EXP                            # Experiment name on vfld files
```


 * *OBSEXTR*: Extract observations for verification from BUFR (__yes__|no)
 * *FLDEXTR* Extract model data for verification from model files (__yes__|no)
 * *FLDEXTR_TASKS*: Number of parallel tasks for field extraction
 * *VFLDEXP*:

Read more about the verification package [here](../HarmonieSystemDocumentation/PostPP/Verification.md)

 === Field verification ===

```bash
# *** Field verification ***
FLDVER=no                               # Main switch for field verification (yes|no)
FLDVER_HOURS="06 12 18 24 30 36 42 48"  # Hours for field verification

```

 * *FLDVER* Main switch for field verification (yes|__no__). The field verification extracts some selected variables for calculation of bias, rmse, stdv and averages on the model grid.
 * *FLDVER_HOURS* Hours for field verification

 More options on field verification can be found in [browser:trunk/harmonie/scr/Fldver Fldver] and [browser:trunk/harmonie/scr/AccuFldver AccuFldver]

 === Observation monitoring and general diagnostics ===

```bash
# *** Observation monitoring ***
OBSMONITOR=obstat                       # Create Observation statistics plots
                                        # Format: OBSMONITOR=Option1:Option2:...:OptionN
                                        # obstat: Daily usage maps and departures
                                        # no: Nothing at all
                                        #
                                        # obstat is # only active if ANAATMO != none
OBSMON_SYNC=no                          # Sync obsmn sqlite tables to ecgate (yes|no)
```

 *OBSMONITOR* Selection for observation statistics plots
    * obstat Observations usage. Read more [here](../HarmonieSystemDocumentation/PostPP/Obsmon.md).
    * no No monitoring

 **Note that this is only active if ANAATMO != none**

 === Field monitoring ( experimental ) ===

Make various charts for daily monitoring

```bash
#  *** Monitoring maps for hirlam.org. ***
#      Note that at ECMWF this is run on ecgb (grads is only there)
#      In  this version You must check out manually contrib/mapbin to the 
#      directory referred as MAPBIN 
FIELDMONITOR=no
MAPBIN=$HM_DATA/lib/util/mapbin

```

 * *FIELDMONITOR* Main switch (__no__|yes)
 * *MAPBIN* Path to plotting settings. Read more in [source:Harmonie/scr/Monitoring_maps]

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


