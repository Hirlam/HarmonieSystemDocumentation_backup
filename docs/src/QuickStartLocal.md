```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/QuickStartLocal?action=edit"
```

# Running Harmonie on your local platform

## Introduction
These "quick start instructions" assumes that someone has already put in place a valid configuration for your local platform, CONFIG=linux.local for example.

The Harmonie system runs through a number of steps to help you complete your experiment. The chain can be summarized like:

 * Configure and start the experiment: This is where you define your domain, choose your settings and specify the period for your experiment.

Once you have done this you can start the system and let it create the basic infrastructure

 * Setup the necessary directories and copy the system files needed (!InitRun, Prepare_cycle)
 * Compile the binaries you need to run your experiment (Build)
 * Create the constant climate files specifying your domain (Climate)

With the basic setup and files in place we can proceed to the integration part where we have three loops taking care of 

  * Prepare boundaries and observations (!MakeCycleInput)
  * Run assimilation and forecasts (Date)
  * Post process and archive the result (Postprocessing)

The three different task are allowed to run ahead/after each other to get a good throughput.

The configuration, the full suite and the relation between different tasks is controlled by the scheduler [mini-SMS](../HarmonieSystemDocumentation.md#Suitemangement). This documentation describes how to get started with your first experiment. The description is general for a single host. (The reference Harmonie system on ECMWF platform assumes a dual-hosts setup with the front-end ecgb used to configure and launch experiments and cca is used for all computations except those for operations related to observation verification and monitoring. 

Following example shows the steps to launch an Harmonie experiment my_exp.

If this is the first time to install HARMONIE on your local platform please take a look at the basic install instructions here: [HarmonieSystemDocumentation/PlatformConfiguration](../HarmonieSystemDocumentation/PlatformConfiguration.md). 

## Configure your experiment

 * Create an experiment directory under $HOME/hm_home and use the master script Harmonie to set up a minimum environment for your experiment.
```bash
   mkdir -p $HOME/hm_home/my_exp
   cd $HOME/hm_home/my_exp
   PATH_TO_HARMONIE/config-sh/Harmonie setup -r PATH_TO_HARMONIE -h YOURHOST
```
 where
  * -r is the path to your downloaded version of HARMONIE
  * -h tells which configuration files to use. At ECMWF config.ecgb is the default one. List PATH_TO_HARMONIE/config-sh/config.* for available HOST configurations
 * This setup command  provides the default setup which currently is AROME physics with CANARI+OI_MAIN surface assimilation and 3DVAR upper air assimilations with 3h cycling on a domain covering Denmark using 2.5km horizontal resolution and 65 levels in the vertical.
 *  Now you can edit the basic configuration file [ecf/config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h) to configure your experiment scenarios. Modify specifications for model domain, physics (AROME, ALARO), data locations, settings for dynamics, physics, domain, coupling host model etc. Read more about the options in [here](../HarmonieSystemDocumentation/ConfigureYourExperiment.md). You can also use some of the predefined configurations by calling Harmonie with the -c option:
```bash
mkdir $HOME/hm_home/my_exp
cd $HOME/hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie setup -r PATH_TO_HARMONIE -h YOURHOST -c CONFIG 
```
 where `CONFIG` is one of the setups defined in [Harmonie_configurations.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_configurations.pm). If you give `-c` with out an argument or a non existing configuration a list of configurations will be printed.
 * In some cases you might have to edit the general system configuration file, Env_system. See here for further information: [HarmonieSystemDocumentation/PlatformConfiguration](../HarmonieSystemDocumentation/PlatformConfiguration.md)
 * The rules for how to submit jobs are defined in Env_submit]. See here for further information: [HarmonieSystemDocumentation/PlatformConfiguration](../HarmonieSystemDocumentation/PlatformConfiguration.md)
 * If you experiment in data assimilation you might also want to change [scr/include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass).

## Start your experiment
Launch the experiment by giving start time, DTG, end time, DTGEND, and forecast length, LL
```bash
cd $HOME/hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie start DTG=YYYYMMDDHH DTGEND=YYYYMMDDHH LL=12
# e.g., PATH_TO_HARMONIE/Harmonie start DTG=2012122400 DTGEND=2012122406 LL=12
```
 If you would like to only run long forecasts at 00/12 UTC and short (3h) at 03/06/09/15/18/21, you specify the longer forecast length as LLMAIN. 
```bash
cd $HOME/hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie start DTG=2012122400 LLMAIN=24
```
 If successful, mini-SMS will identify your experiment name and start building your binaries and run your forecast. If not, you need to examine the mSMS log file $HM_DATA/mSMS.log. $HM_DATA is defined in your Env_system file. At ECMWF `$HM_DATA=$SCRATCH/hm_home/$EXP` where `$EXP` is your experiment name. Read more about where things happen further down.

## Continue your experiment
If your experiment have successfully completed and you would like to continue for another period you should write
```bash
cd $HOME/hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie prod DTGEND=YYYYMMDDHH LL=12 
```
By using `prod` you tell the system that you are continuing the experiment and using the first guess from the previous cycle. The start date is take from a file progress.log created in your $HOME/hm_home/my_exp directory. If you would have used `start` the initial data would have been interpolated from the boundaries, a cold start in other words.

## !Start/Restart of mXCdp
To start the graphical window for mSMS on ecgb type
```bash
cd $HOME/hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie mon
```
The graphical window, mXCdp runs independently of the mSMS job and can be closed and restarted again with the same command. With the graphical interface you can control and view logfiles of each task. 

## Making local changes

Very soon you will find that you need to do changes in a script or in the source code. Once you have identified which file to edit you put it into the current $HOME/hm_home/my_exp directory, with exactly the same subdirectory structure as in the reference. e.g, if you want to modify a namelist setting 

```bash
cd $HOME/hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie co nam/harmonie_namelists.pm         # retrieve default namelist harmonie_namelists.pm
vi nam/harmonie_namelists.pm                        # modify the namelist
```

Next time you run your experiment the changed file will be used. You can also make changes in a running experiment. Make the change you wish and rerun the `InitRun` task in the mXCdp window. The !InitRun task copies all files from your local experiment directory to your working directory `$HM_DATA`. Once your `InitRun` task is complete your can rerun the task you are interested in. If you wish to recompile something you will also have to rerun the `Build` tasks. Read more about how to control and rerun tasks in mini-SMS from mXCdp [here](../HarmonieSystemDocumentation/scripts/mXCdp.md).

## Directory structure
On most platforms HARMONIE compiles and produces all its output data under $HM_DATA (defined in ~/hm_home/my_exp/Env_system)

|= Description                            =|= Location                                                                                  =|
| --- | --- |
| Binaries                                 |$BINDIR (set in ecf/config_exp.h ), default is $HM_DATA/bin                                   |
| libraries, object files & source code    |$HM_DATA/lib/src if MAKEUP=yes, $HMDATA/gmkpack_build if MAKEUP=no                           |
| Scripts                                  |$HM_DATA/lib/scr                                                                             |
| config files (Env_system & Env_system    |$HM_DATA/lib linked to files in $HM_DATA/config-sh                                           |
| sms                                      |$HM_DATA/lib/sms                                                                             |
| msms definitions                         |$HM_DATA/lib/msms                                                                            |
| Utilities such as gmkpack, gl & monitor  |$HM_DATA/lib/util                                                                            |
| Climate files                            |$HM_DATA/climate                                                                             |
| Working directory for the current cycle  |$HM_DATA/YYYYMMDD_HH                                                                         |
| Archived files                           |$HM_DATA/archive                                                                             |
| Archived cycle output                    |$HM_DATA/archive/YYYY/MM/DD/HH                                                               |
| Archived log files                       |$HM_DATA/archive/log/HM_TaskFamily_YYYYMMDDHH.html where !TaskFamily=!MakeCycleInput,Date,Postprocessing  |
| Task log files                           |$JOBOUTDIR (set in Env_system) usually $HM_DATA/sms_logfiles                                 |
| Verification data (vfld/vobs/logmonitor) |$HM_DATA/archive/extract                                                                     |
| Verification (monitor) results           |$HM_DATA/archive/extract/WebgraF                                                             |
| "Fail" directory                         |$HM_DATA/YYYYMMDD_HH/Failed_Family_Task (look at ifs.stat, NODE.001_01, fort.4               |

## Archive contents
$HM_DATA/archive/YYYY/MM/DD/HH is used to store "archived" output from HARMONIE cycles. The level of archiving depends on `ARSTRATEGY` in ecf/config_exp.h . The default setting is medium which will keep the following cycle data:
   * Surface analysis: ICMSHANAL+0000
   * Atmospheric analysis result: MXMIN1999+0000
   * Blending between surface/atmospheric analysis and cloud variable from the first guess: ANAB1999+0000
   * ICMSHHARM+NNNN and ICMSHHARM+NNNN.sfx are atmospheric and surfex forecast output files
   * PFHARM* files produced by the inline postprocessing 
   * GRIB files produced by the conversion of FA output files to GRIB if MAKEGRIB=yes in ecf/config_exp.h 
   * ODB databases and feedback information in odb_stuff.tar
 
## Cleanup of old experiments

Once you have complete your experiment you may wish to remove code, scripts and data from the disks. Harmonie provides some simple tools to do this. First check the content of the different disks by

```bash
 Harmonie CleanUp -ALL
```

Once you have convinced yourself that this is OK you can proceed with the removal.

```bash
 Harmonie CleanUp -ALL -go 
```

If you would like to exclude the data stored  HM_DATA ( as defined in Env_system ) you run 

```bash
 Harmonie CleanUp -d
```

to list the directories intended for cleaning. Again, convince yourself that this is OK and proceed with the cleaning by

```bash
 Harmonie CleanUp -d -go
```

**NOTE that these commands may not work properly in all versions. Do not run the removal before you're sure it's OK**


[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


