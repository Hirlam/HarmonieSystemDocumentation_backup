```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Installation?action=edit"
```


# HARMONIE System Installation


## Introduction

In the following the installation and compilation of system is described. Read more about how to get the system in
[here](../HarmonieSystemDocumentation/General.md)

## Rootpack Installation

Gmkpack is the ALADIN utility to compile ARPEGE/IFS

 - Handle dependencies (includes/modules)
 - Handle exceptions
 - Compile the code
 - Build the binaries

A mainpack installs and builds a complete HARMONIE source (ALADIN/HIRALD/ALARO/AROME models). Generate a set of pre-compiled libraries (rootpack) and modules available for USE. 
Each single user buils their own  local "target" pack, which synchronise local source modifications with the reference libraries.  

[gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=gmkpack)

[gmkpack vs make](../HarmonieSystemDocumentation/Gmkpack_vs_Make.md)


gmkpack is intended to be installed and maintained separately. In HARMONIE it is a part of the system and used in Build_gmkpack, Build_rootpack and Build_pack

Available main packs on cca:/project/hirlam/harmonie/pack could look like:

37h1_harmonEPS_11389.01.XLF130100000009.x 37h1_harmonEPS_11842.01.XLF130100000009.x 37h1_harmonEPS_11899.01.XLF130100000009.x 37h1_main.01.XLF130100000009.x 37h1_main.02.XLF130100000009.x 38h1_alpha.01.XLF130100000009.x 38h1_alpha.02.XLF130100000009.x 38h1_beta.01.XLF130100000009.x 

ie. CYCLE_BRANCH.VERIONS.COMPILER_VERSION.OPTION
For the latest available packs please check on cca.

 * [Supported platforms and compilers](https://hirlam.org/trac/browser/Harmonie/util/gmkpack/arch)
    - IBM power 7, xlf95
    - Intel (g95, gfortran, intel)
    - NEC
    - Cray, ftn

## Configure your system

We assume you have a copy of the repository under PATH_TO_HARMONIE. To start the build, create an experiment directory $HOME/hm_home/trunk and run

```bash
   PATH_TO_HARMONIE/config-sh/Harmonie setup -r PATH_TO_HARMONIE -h YOURHOST
```

The above command creates the following files/directories under
```bash
   config-sh/hm_rev                         # gives the path to the reference installation, similar to hl_rev in synoptic-Hirlam
   config-sh/Main                           # a script to enable start Harmonie, similar to Start in synoptic-Hirlam
   Env_system -> config-sh/config.YOURHOST  # describing your system, similar to Env_system in synoptic-Hirlam
   Env_submit -> config-sh/submit.YOURHOST  # describing your submit commands, comparable to submission.db in synoptic-Hirlam
   ecf/config_exp.h                          # defines your experiment, comparable to Env_expdesc in synoptic-Hirlam
```


In ecf/config_exp.h  you may identify the options sent to gmkpack

```bash
# Definitions about gmkpack, should fit with hm_rev
      BUILD_ROOTPACK=${BUILD_ROOTPACK-yes}    # Build your own ROOTPACK if it doesn't exists (yes|no)
                                              # This may take several hours!
                                              # Make sure you have write permissions in ROOTPACK directory defined in Env_system
      REVISION=38h1                           # Revision ( or cycle ) number, has to be set even for the trunk!
      BRANCH=trunk
      VERSION=01                              # Version of revision/branch to use
      OPTION=x                                # Which gmkpack/arch/SYSTEM.HOST.OPTION file to use
      OTHER_PROGRAMS="soda pgd blend odbtools bator ioassign odbsql blendsur addsurf surfex mandalay prep lfitools sfxtools" # Other things to compile with gmkpack
```

You could run something different than defined in hm_rev, but then there would be a mismatch between your source code and the pre-compiled libraries/modules.


Identify your system in one of the config files in config-sh or write a new config.YOURHOST definition, make sure that some of the important optional settings are defined in this file:
```bash
 COMPCENTRE       # should be something else than ECMWF
 HM_DATA          # where you run your experiments and where you 
 HM_LIB           # where you find the copy of the source code and the compiled libraries
 ROOTPACK         # where you refer/put your rootpack installations
 HARMONIE_CONFIG  # identifies your configuration
 AUXLIBS/EMOSLIB  # Path to your external libraries
```

Compare e.g. with [config.ecgb-cca](https://hirlam.org/trac/browser/Harmonie/config-sh/config.ecgb-cca) or [config.krypton](https://hirlam.org/trac/browser/Harmonie/config-sh/config.krypton).

You also have to identify your system for gmkpack in:

```bash
        util/gmkpack/arch/YOURMACHINE.HARMONIE_CONFIG
```


The source code for utilities not compiled with gmkpack you find under util. There should be five config files created/edited.

```bash
        util/gl/config/config.HARMONIE_CONFIG
        util/gl_grib_api/config/config.HARMONIE_CONFIG
        util/monitor/config/config.HARMONIE_CONFIG
        util/oulan/config.HARMONIE_CONFIG
        util/conrad/config.HARMONIE_CONFIG

```

The makefiles themselves should not have to be edited.

## Submission rules

Next you have to identify your submit file in config-sh or write a new submit.YOURHOST file. This file defines how you submit your jobs in your local batch system. 
The routine get_job is called from [submission.db](https://hirlam.org/trac/browser/Harmonie/scr/submission.db) and should return the appropriate batch header including some environment variables specifying the parallel decomposition. The way the header is constructed could be different on different hosts as long as the appropriate header is returned.

On [ecgb-cca](https://hirlam.org/trac/browser/Harmonie/config-sh/submit.ecgb-cca) three list of jobs are created:
 * backg_list for jobs running as background jobs on ecgb
 * scalar_list single PE jobs on cca
 * par_list for parallel jobs on cca

The scalar_list is the default one, meaning that any unspecified job will be run as a single PE job on HPCE. Default values are defined for each list. Special settings for special jobs can be set like:

```bash
 $job_list{'Prep_ini_surfex'}{'RESOURCES'} = $submit_type.'resources = ConsumableCPUs(1) ConsumableMemory(6000 MB)' ;
```



## Running the installation

Start the compilation of the rootpack :
```bash
      PATH_TO_HARMONIE/config-sh/Harmonie install
```

The suite definition file used for the installation is 
[Install_rootpack.tdf](https://hirlam.org/trac/browser/Harmonie/msms/Install_rootpack.tdf). The installation is just like running an experiment.

Where are things happening

- Build_gmkpack 
- Build_rootpack
 - rsync the sources from HM_REV, HM_CMODS, HM_LIB
 - cleanpack
 - compiles the ODB compiler
 - compiles IFS
 - locks the pack

- Build_pack
 - build everything in the OTHER_PROGRAMS list. This is done inside HM_DATA/gmkpack_build
 - build the utilities (gl/verobs/oulan)

When things goes wrong

 - ics_* can be run stand alone from the ROOTPACK or `$HM_DATA/gmkpack_build` directory
   - Turn off the compilation and linking
   - build the libraries by running the ics_* file by hand
   - BUILD_ROOTPACK=no, put the corrections to the failing code in your experiment
   - rerun Harmonie install


**The main task for the installation is to compile the rootpack. However, the binaries created are never used by any other experiment.**

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


