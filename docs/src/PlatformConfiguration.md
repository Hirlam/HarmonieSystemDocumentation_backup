```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PlatformConfiguration?action=edit"
```

## Platform Configuration
## Overview
This wiki page outlines the configuration files required by HARMONIE for successful compilation and running of the system.

## Basic requirements
All experiments require a valid host to "setup" an experiment using the Harmonie script. Recall from the [quick start](../HarmonieSystemDocumentation/QuickStartLocal.md) instructions that in order to setup a new experiment on your platform, called YOURHOST, using HARMONIE downloaded to PATH_TO_HARMONIE one must issue the following command:
```bash
cd hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie setup -r PATH_TO_HARMONIE -h YOURHOST
```
hm_home/my_exp contains:
```bash
Env_submit -> config-sh/submit.YOURHOST           ## YOURHOST platform specific settings
Env_system -> config-sh/config.YOURHOST           ## YOURHOST task submission settings
./config-sh/hm_rev                                ## contains PATH_TO_HARMONIE
./config-sh/Main                                  ## The script used to run HARMONIE
./config-sh/submit.YOURHOST                       ## YOURHOST platform specific settings
./config-sh/config.YOURHOST                       ## YOURHOST task submission settings
./suites/harmonie.pm                              ## perl module to define ensemble settings
./ecf/config_exp.h                                ## your experiment definition (scientific type options)
./scr/include.ass                                 ## assimilation specific settings
```
But, what if your host configuration is not available in the HARMONIE system? Host specific configuration files in PATH_TO_HARMONIE/config-sh must be available for your host and configuration files for the compilation of the code must be available. This documentation attempts to describe what is required.
## Host config files
### Env_system -> config-sh/config.YOURHOST
The config.YOURHOST file defines host specific variables such as some input directory locations. If your YOURHOST is not already included in HARMONIE it may be work looking at config.* files in [config-sh](https://hirlam.org/trac/browser/Harmonie/config-sh) to see what other people have done. The table below outlines variables set in config-sh/config-sh.YOURHOST and what the variables do:

|= Variable name        =|= Description                                                                                                                      =|
| --- | --- |
|COMPCENTRE              |controls special ECMWF solutions (such as MARS) where required. Set to LOCAL if you are unsure                                      |
|HARMONIE_CONFIG         |defines the config file used by Makeup compilation                                                                                  |
|MAKEUP_BUILD_DIR        |location of where Makeup compiles the HARMONIE code                                                                                 |
|MAKE_OWN_PRECOMPILED    |yes=>install pre-compiled code in $PRECOMPILED                                                                                      |
|PRECOMPILED             |location of (optional) pre-compiled HARMONIE code                                                                                   |
|E923_DATA_PATH          |location of input data for E923, climate generation                                                                                 |
|PGD_DATA_PATH           |location of input data for PGD, surfex climate generation                                                                           |
|ECOSG_DATA_PATH         |location of input data for ECOCLIMAP2G                                                                                              |
|GMTED2010_DATA_PATH     |location of HRES DEM                                                                                                                |
|SOILGRID_DATA_PATH      |location of SOILGRID data                                                                                                           |
|HM_SAT_CONST            |location of constants for satellite assimilation                                                                                    |
|RTTOV_COEFDIR           |location of RTTOV coefficients                                                                                                      |
|HM_DATA                 |location of top working directory for the experiment                                                                                |
|HM_LIB                  |location of src/scripts and compiled code                                                                                           |
|TASK_LIMIT              |Maximum number of jobs submitted by ECFLOW                                                                                          |
|RSYNC_EXCLUDE           |used to exclude .git* sub-directories from copy of source code for compilation                                                      |
|DR_HOOK_IGNORE_SIGNALS  |environment variable used by Dr Hook to ignore certain "signals"                                                                    |
|HOST0                   |define primary host name                                                                                                            |
|HOSTN                   |define other host name(s)                                                                                                           |
|HOST_INSTALL            |0=> install on HOST0, 0:...:N => install on HOST0,...,HOSTN                                                                         |
|MAKE                    |make command may need to be explicity defined. Set to make for most platforms                                                       |
|MKDIR                   |mkdir command (default: mkdir -p)                                                                                                   |
|JOBOUTDIR               |where ECFLOW writes its log files                                                                                                   |
|ECCODES_DEFINITION_PATH |location of local ecCodes definition files                                                                                          |
|BUFR_TABLES             |location of local BUFR tables                                                                                                       |


### Env_submit -> config-sh/submit.YOURHOST
The Env_submit file uses perl to tell the HARMONIE scheduler how to execute programs - which programs should be run on multiple processors and define batch submissions if required.

|= perl                =|= description                                                                                                                       |
| --- | --- |
|%backg_job             |defines variables for jobs run in the background on HOST0                                                                           |
|%scalar_job            |defines variables for single processor batch jobs                                                                                   |
|%par_job               |defines variables for multi-processor batch jobs                                                                                    |
|@backg_list            |list of tasks to be submitted as a background job                                                                                   |
|@scalar_list           |list of tasks to be submitted as a scalar job                                                                                       |
|@par_list              |list of tasks to be submitted as parallel job                                                                                       |
|default                |"wildcard" task name to defined default type of job for unlisted tasks                                                              |

### Host summary

|= YOURHOST            =|= Host type                   =|= batch     =|= Contact            =|
| --- | --- | --- | --- |
|KNMI-Altix             |KNMI SGI HPC                   |none         |                      |
|LinuxPC                |General Linux PC no MPI        |none         |                      |
|LinuxPC-MPI            |General Linux PC with MPI      |none         |                      |
|LinuxPC-MPI-ubuntu     |Ubuntu Linux PC with MPI       |none         |                      |
|METIE.LinuxPC          |METIE CentOS 6 PC with MPI     |none         |Eoin Whelan           |
|METIE.LinuxRH7gnu      |METIE Redhat 7 server with MPI |none         |Eoin Whelan           |
|METIE.fionn            |METIE SGI HPC                  |PBS          |Eoin Whelan           |
|SMHI.Linda4            |SMHI ???                       |             |                      |
|SMHI.LinuxPC           |SMHI PC                        |             |                      |
|bi                     |                               |             |                      |
|crayx1                 |                               |             |                      |
|crayxt5m               |                               |             |                      |
|ecgb                   |                               |             |                      |
|ecgb-cca               |ECMWF HPC with MPI dual host   |slurm/PBS    |                      |
|fmisms                 |                               |             |                      |
|jumbo                  |                               |             |                      |
|xt5intel               |                               |             |                      |
|xtpathscale            |                               |             |                      |

## Compilation config files
### Makeup
config files required for compilation of code using Makeup ...

More information on Makeup is available here: [Build with Makeup](../HarmonieSystemDocumentation/Build_with_makeup.md)
### Obsmon
For config files required for compilation of obsmon check [here](https://hirlam.org/trac/browser/Harmonie/util/obsmon/config)

----


