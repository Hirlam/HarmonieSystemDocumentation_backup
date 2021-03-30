```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/BoundaryFilePreparation?action=edit"
```

## Preparation of initial and boundary files

## Introduction

HARMONIE can be coupled with external models as IFS, ARPEGE, HIRLAM. Internally it is possible to nest the different ALADIN/ALARO/AROME with some restrictions. In the following we describe the host initial and boundary files are generated depending on different configurations. Boundary file preparation basically includes two parts: forecast file fetching and boundary file generation.

*The ECFLOW tasks for initial and boundary preparation*

## Boundary strategies

There are a number of ways to chose which forecast lengths you use as boundaries. The strategy is determined by BDSTRATEGY in ecf/config_exp.h  and there are a number of strategies implemented.

 * available            : Search for available files in BDDIR adn try to keep forecast consistency. This is ment to be used operationally since it will at least keep your run going, but with old boundaries, if no new boundaries are available.
* simulate_operational : Mimic the behaviour of the operational runs using ECMWF 6h old boundaries.
* same_forecast        : Use all boundaries from the same forecast, start from analysis
* analysis_only        : Use only analyses as boundaries. Note that BDINT cannot be shorter than the frequency of the analyses.
* latest               : Use the latest possible boundary with the shortest forecast length
* RCR_operational      : Mimic the behaviour of the RCR runs, ie
  * 12h old boundaries at 00 and 12 and
  * 06h old boundaries at 06 and 18
* jb_ensemble          : Same as same_forecast but used for JB-statistics generation. With this you should export JB_ENS_MEMBER=some_number
* eps_ec               : ECMWF EPS members (on reduced Gaussian grid). It is only meaningful with ENSMSEL non-empty, i.e., ENSSIZE > 0

All the strategies are defined in [Boundary_strategy.pl](https://hirlam.org/trac/browser/Harmonie/scr/Boundary_strategy.pl). The script generates a file bdstrategy in your working directory that could look like:

```bash
 Boundary strategy

       DTG: 2011090618
        LL: 36
     BDINT: 3
   BDCYCLE: 6
  STRATEGY: simulate_operational
     BDDIR: /cca/tmp/ms/se/snh/hm_home/alaro_37h1_trunk/ECMWF/archive/@YYYY@/@MM@/@DD@/@HH@
HOST_MODEL: ifs
INT_BDFILE: /cca/tmp/ms/se/snh/hm_home/alaro_37h1_trunk/20110906_18/ELSCFHARMALBC@NNN@

# The output bdstrategy file has the format of 
# NNN|YYYYMMDDHH INT_BDFILE BDFILE BDFILE_REQUEST_METHOD 
# where 
# NNN        is the input hour
# YYYYMMDDHH is the valid hour for this boundary
# INT_BDFILE is the final boundary file
# BDFILE                is the input boundary file
# BDFILE_REQUEST_METHOD is the method to the request BDFILE from e.g. MARS, ECFS or via scp

SURFEX_INI| /cca/tmp/ms/se/snh/hm_home/alaro_37h1_trunk/20110906_18/SURFXINI.lfi 
000|2011090618 /cca/tmp/ms/se/snh/hm_home/alaro_37h1_trunk/20110906_18/ELSCFHARMALBC000 /cca/tmp/ms/se/snh/hm_home/alaro_37h1_trunk/ECMWF/archive/2011/09/06/12/fc20110906_12+006 MARS_umbrella -d 20110906 -h 12 -l 6 -t
003|2011090621 /cca/tmp/ms/se/snh/hm_home/alaro_37h1_trunk/20110906_18/ELSCFHARMALBC001 /cca/tmp/ms/se/snh/hm_home/alaro_37h1_trunk/ECMWF/archive/2011/09/06/12/fc20110906_12+009 MARS_umbrella -d 20110906 -h 12 -l 9 -t
...
```

Meaning that the if the boundary file is not found under BDDIR the command `MARS_umbrella -d YYYYMMDD -h HH -l LLL -t BDDIR` will be executed. A local interpretation could be to search for external data if your file is not on BDDIR. Like the example from SMHI:

```bash
 Boundary strategy

       DTG: 2011090112
        LL: 24
     BDINT: 3
   BDCYCLE: 06
  STRATEGY: latest
     BDDIR: /nobackup/smhid9/sm_esbol/hm_home/ice_36h1_4/g05a/archive/@YYYY@/@MM@/@DD@/@HH@
HOST_MODEL: hir
INT_BDFILE: /nobackup/smhid9/sm_esbol/hm_home/ice_36h1_4/20110901_12/ELSCFHARMALBC@NNN@
 EXT_BDDIR: smhi_file:/data/arkiv/field/f_archive/hirlam/G05_60lev/@YYYY@@MM@/G05_@YYYY@@MM@@DD@@HH@00+@LLL@H00M
EXT_ACCESS: scp

# The output bdstrategy file has the format of 
# NNN|YYYYMMDDHH INT_BDFILE BDFILE BDFILE_REQUEST_METHOD 
# where 
# NNN        is the input hour
# YYYYMMDDHH is the valid hour for this boundary
# INT_BDFILE is the final boundary file
# BDFILE                is the input boundary file
# BDFILE_REQUEST_METHOD is the method to the request BDFILE from e.g. MARS, ECFS or via scp

# hh_offset is 0 ; DTG is  
SURFEX_INI| /nobackup/smhid9/sm_esbol/hm_home/ice_36h1_4/20110901_12/SURFXINI.lfi 
000|2011090112 /nobackup/smhid9/sm_esbol/hm_home/ice_36h1_4/20110901_12/ELSCFHARMALBC000 /nobackup/smhid9/sm_esbol/hm_home/ice_36h1_4/g05a/archive/2011/09/01/12/fc20110901_12+000 scp smhi:/data/arkiv/field/f_archive/hirlam/G05_60lev/201109/G05_201109011200+000H00M 
003|2011090115 /nobackup/smhid9/sm_esbol/hm_home/ice_36h1_4/20110901_12/ELSCFHARMALBC001 /nobackup/smhid9/sm_esbol/hm_home/ice_36h1_4/g05a/archive/2011/09/01/12/fc20110901_12+003 scp smhi:/data/arkiv/field/f_archive/hirlam/G05_60lev/201109/G05_201109011200+003H00M 
```

In this example an scp from smhi will be executed if the expected file is not in BDDIR. There are a few environment variables that one can play with in sms/confi_exp.h that deals with the initial and boundary files

 * HOST_MODEL : Tells the origin of your boundary data
        * ifs : ecmwf data
        * hir : hirlam data
        * ald : Output from aladin physics, this also covers arpege data after fullpos processing.
        * ala : Output from alaro physics
        * aro : Output from arome physics
 * BDINT : Interval of boundaries in hours
 * BDLIB : Name of the forcing experiment. Set
     * ECMWF to use MARS data
     * RCRa  to use RCRa data from ECFS
     * Other HARMONIE/HIRLAM experiment
 * BDDIR : The path to the boundary file. In the default location ` BDDIR=$HM_DATA/${BDLIB}/archive/@YYYY@/@MM@/@DD@/@HH@ ` the file retrieved from e.g. MARS will be stored in a separate directory. On could also consider to configure this so that all the retrieved files are located in your working directory ` $WRK `. Locally this points to the directory where you have all your common boundary HIRLAM or ECMWF files.
 * INT_BDFILE : is the full path of the interpolated boundary files. The default setting is to let the boundary file be removed by directing it to `$WRK`.
 * INT_SINI_FILE : The full path of the initial surfex file. 
 
There are a few optional environment variables that could be used that are not visible in config_exp.h 

 * EXT_BDDIR : External location of boundary data. If not set rules are depending on HOST_MODEL
 * EXT_ACCESS : Method for accessing external data. If not set rules are depending on HOST_MODEL
 * BDCYCLE : Assimilation cycle interval of forcing data, default is 6h.

More about this can be bounds in the Boundary_strategy.pl script.


The bdstrategy file is parsed by the script ExtractBD. 

 * [ExtractBD](https://hirlam.org/trac/browser/Harmonie/scr/ExtractBD) Checks if data are on *BDDIR* otherwise copy from EXT_BDDIR. 
   The operation performed can be different depending on HOST and HOST_MODEL. IFS data at ECMWF are extracted from MARS, RCR data are copied from ECFS.
   * Input parameters: Forecast hour
   * Executables: none.

In case data should be retrieved from MARS there is also a stage step. When calling MARS with the stage command we ask MARS to make sure data are on disk. In HARMONIE we ask for all data for one day of r forecasts ( normally four cycles ) at the time.  

## Initial and Boundary file generation

To be able to start the model we need the variables defining the model state.

 * T,U,V,PS in spectral space
 * Q in gridpoint or spectral space

 Optional:

 * Q,,l,,, Q,,i,,, Q,,r,,, Q,,g,,,  Q,,s,,, Q,,h,,
 * TKE

For the surface we need the different state variables for the different tiles. The scheme selected determines the variables.
 
Boundary files (coupling files) for HARMONIE are prepared in two different ways depending on the 
nesting procedure defined by *HOST_MODEL*.

### Using gl

If you use data from HIRLAM or ECMWF gl_grib_api will be called to generate boundaries. The generation can be summarized in the following steps:

 * Setup geometry and what kind of fields to read depending on HOST_MODEL
 * Read the necessary climate data from a climate file
 * Translate and interpolate the surface variables horizontally if the file is to be used as an initial file. All interpolation respects land sea mask properties. The soil water is not interpolated directly but interpolated using the Soil Wetness Index to preserve the properties of the soil between different models. The treatment of the surface fields is only done for the initial file.
 * Horizontal interpolation of upper air fields as well as restaggering of winds.
 * Vertical interpolation using the same method (etaeta) as in HIRLAM
   * Conserve boundary layer structure
   * Conserve integrated quantities
 * Output to an FA file ( partly in spectral space )

 gl_grib_api is called by the script [gl_bd](https://hirlam.org/trac/browser/Harmonie/scr/gl_bd) where we make different choices depending on **PHYSICS** and **HOST_MODEL**

 When starting a forecast there are options to whether e.g. cloud properties and TKE should be read from the initial/boundary file through *NREQIN* and *NCOUPLING*. At the moment these fields are read from the initial file but not coupled to. gl reads them if they are available in the input files and sets them to zero otherwise. For a Non-Hydrostatic run the non-hydrostatic pressure departure and the vertical divergence are demanded as an initial field. The pressure departure is by definition zero if you start from a non-hydrostatic mode and since the error done when disregarding the vertical divergence is small it is also set to zero in gl. There are also a choice in the forecast model to run with Q in gridpoint or in spectral space.

It's possible to use an input file without e.g. the uppermost levels. By setting `LDEMAND_ALL_LEVELS=.FALSE. ` the missing levels will be ignored. This is used at some institutes to reduce the amount of data transferred for the operational runs. 

### Using fullpos

If you use data generated by HARMONIE you will use fullpos to generate boundaries and initial conditions. Here we will describe how it's implemented in HARMONIE but there are also good documentation on the gmapdoc site.

* [fullpos](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=fullpos)

In HARMONIE it is done by the script [E927](https://hirlam.org/trac/browser/Harmonie/scr/E927). It contains the following steps:

 * Fetcht climate files. Fullpos needs a climate file and the geometry definition for both the input and output domains. 
 * Set different moist variables in the namelists depending if your run AROME or ALADIN/ALARO.
 * Check if input data has Q in gridpoint or spectral space.
 * Demand NH variables if we run NH.
 * Determine the number of levels in the input file and extract the correct levels from the definition in [source:Harmonie/scr/Vertical_level.pl]

 * Run fullpos

 E927 is also called from 4DVAR when the resolution is changed between the inner and outer loops.

### Generation of initial data for SURFEX

 For SURFEX we have to fill the different tiles with correct information from the input data. This is called the PREP step in the SURFEX context. [Prep_ini_surfex](https://hirlam.org/trac/browser/Harmonie/scr/Prep_ini_surfex) creates an initial SURFEX file from an FA file if you run with SURFACE=surfex. 

 [Read more about SURFEX](http://www.cnrm.meteo.fr/surfex/)

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


