```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PostPP/Obsmon?action=edit"
```
# OBSMON

In 2014 a new version of the observational monitoring system entered trunk. The first official release containing obsmon was cy38h1.2

The obsmon package consists of two components. The first is a fortran-based code that is run, for all the active observations types (defined in scr/include.ass), at the post-processing stage of an experiment. It generates statistics from the ODB and store data in three SQLite tables (ECMA/CCMA/ECMA_SFC(CANARI)). In addition the SQLite tables are concatenated in tables in the /ts directory at the end of the run.

The second component is written in R using the Shiny web application framework. It allows the interactive visualization of the data contained in the SQLite tables produced by the first component of the package. This can be done either offline or via a server daemon (e.g. shiny.hirlam.org).

For disambiguation, we will hereinafter use the terms "backend" and "frontend" to refer to the first and second components of obsmon, respectively.


## How to turn on backend obsmon?

Obsmon is enabled by default in ecf/config_exp.h  vi OBSMONITOR=obstat

NB1! If you don't have any log-files from the monitoring experiment, you should disable plotlog from the OBSMONITOR= string in ecf/config_exp.h 
NB2! Make sure that the -DODBMONITOR pre-processor flag is active during compilation of util/monitor. This should only be an issue on untested platforms and is by default enabled on ECMWF.


## How to create statistics and SQLite tables offline/stand-alone:

If you are running a normal harmonie experiment with the OBSMONITOR=obstat active, the following step is not relevant.

Two new actions are implemented in the Harmonie script. Instead of start you can write obsmon and instead of prod you can write obsmonprod. This will use the correct definition file and only do post-processing. If you have your ODB files in another experiment you can add the variable OBSMON_EXP_ARCHIVE_ROOT to point to the archive directory in the experiment you are monitoring. This approach is used in the operational MetCoOp runs. If you set OBSMON_EXP=label the runs will be stored in $EXTRARCH/label/. This way you can use the same experiment to monitor all other experiments. The experiements do not need to belong to you as long as you have reading permissions to the experiment. 

```bash
1. as start:
${HM_REV}/config-sh/Harmonie obsmon DTG=YYYYMMDDHH DTGEND=YYYYMMDDHH OBSMON_EXP_ARCHIVE_ROOT=PATH-TO-ARCHIVE-DIRECTORY-TO-MONITOR OBSMON_EXP=MY-LABEL
```


```bash
2. as prod:
${HM_REV}/config-sh/Harmonie obsmonprod DTGEND=YYYYMMDDHH OBSMON_EXP_ARCHIVE_ROOT=PATH-TO-ARCHIVE-DIRECTORY-TO-MONITOR OBSMON_EXP=MY-LABEL
```

If you want to monitor an experiment stored on ECFS, you should specify OBSMON_EXP_ARCHIVE_ROOT with the full address (ectmp:/$USER/..... or ec:/$USER/...) e.g. 
```bash
OBSMON_EXP_ARCHIVE_ROOT=ectmp:/$USER/harmonie/MY-EXP OBSMON_EXP=MY-LABEL
```

You can also monitor other users experiments as long as you have read-access to the data.

## How to visualize the SQLite tables using frontend obsmon:

Download the code from its git repo at hirlam.org:
```bash
git clone https://git.hirlam.org/Obsmon obsmon
```

Instructions on how to install, configure and run the code can be found in the file `docs/obsmon_documentation.pdf` that is shipped with the code.


## How to extend backend obsmon with new observation types

### Step 1: Extract statistics from ODB

In the scripts you must enable monitoring of your observation type. Each observation type is monitored if active in:
```bash
msms/harmonie.tdf
```

The script which calls the obsmon binary, is:
```bash
scr/obsmon_stat
```
This script set the correct namelist based on how you define your observation below. 

After the information is extracted, the different SQLite bases are gathered into one big SQLite file in the script:
```bash
scr/obsmon_link_stat
```

The observation types which the above script is gathering is defined in obtypes in this script:
```bash
util/monitor/scr/monitor.inc
```

Then let us introduce the new observation in the obsmon binary. The source code is in 
```bash
harmonie/util/monitor
```

There are two modules controlling the extraction from ODB:
```bash
mod/module_obstypes.f90
mod/module_obsmon.F90
```

The first routine defines and initializes the observation type you want to monitor. The second calls the intialization defined in the first file. The important steps are to introduce namelist variables and a meaningful definition in the initialization of the observation type.

The real extraction from ODB is done in
```bash
cmastat/odb_extract.f90
```

At the moment there are two different SQL files used, one for conventional and one for satelites. E.g. radar is handled as TEMP/AIRCRAFT.

### Step 2: Visualize the new observation in shiny (frontend obsmon)

The logics of which observation type to display is defined in:
```bash
src/observation_definitions.R
```

In case of a new plot added, the plotting is defined in the files under:
```bash
src/plots
```
