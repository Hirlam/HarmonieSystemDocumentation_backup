```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Harmonie-mSMS?action=edit"
```

# Running Harmonie at ECMWF

## Introduction

The Harmonie system runs through a number of steps to help you complete your experiment. The chain can be summarized like:

 * Configure and start the experiment. This is where you define your domain, choose your settings and specify the period for your experiment.

Once you have done this you can start the system and let it create the basic infrastructure

 * Setup the necessary directories and copy the system files needed.
 * Compile the binaries you need to run your experiment.
 * Create the constant climate files specifying your domain

With the basic setup and files in place we can proceed to the integration part where we have three loops taking care of 

  * Prepare boundaries and observations
  * Run assimilation and forecasts
  * Post process and archive the result

The three different task are allowed to run ahead/after each other to get a good throughput.

The configuration, the full suite and the relation between different tasks is controlled by the scheduler [ECFLOW](../HarmonieSystemDocumentation/ECFLOW.md) which has a graphical interface ecflow_ui. This documentation describes how to get started with your first experiment. The description follows the setup at ECMWF, but your local system setup would be very similar but most likely simpler. The reference Harmonie system on ECMWF platform assumes a dual-hosts setup using ECFLOW. By default, Harmonie uses the front-end ecgb to configure and launch experiments, whereas cca is used for all computations except those for operations related to observation verification and monitoring.

Following example shows the steps to launch an Harmonie experiment my_exp from ecgb.

If this is the first time to install HARMONIE on your local platform please take a look at the basic install instructions here: [HarmonieSystemDocumentation/PlatformConfiguration](../HarmonieSystemDocumentation/PlatformConfiguration.md).

## Before you start ...
### hirald group
New Harmonie users will require membership of the hirald user group at ECMWF. Please contact the HIRLAM System Manager, Daniel Santos, to make this request on your behalf.
### SHELL settings
The C shell, is no longer supported by ECMWF.  Check your shell on ecgate with:
```bash
echo $SHELL
```
To change your shell use the changesh command:
```bash
changesh
```

## Configure your experiment

 * Create an experiment directory under $HOME/hm_home and use the master script Harmonie to set up a minimum environment for your experiment.
```bash
   mkdir -p $HOME/hm_home/my_exp
   cd $HOME/hm_home/my_exp
   ~hlam/harmonie_release/git/tags/release-43h2.1/config-sh/Harmonie setup -r ~hlam/harmonie_release/git/tags/release-43h2.1 -h ecgb-cca
```
 where
  * -r tells which version to use. There are several old versions kept on ecgb. Check the directories under `~hlam/harmonie_release` to see the available versions. 
  * -h tells which configuration files to use. At ECMWF `config.ecgb-cca` is the default one.
 * This would give you the default setup which currently is AROME physics with CANARI+OI_MAIN surface assimilation and 3DVAR upper air assimilations with 3h cycling on a domain covering Denmark using 2.5km horizontal resolution and 65 levels in the vertical.
 *  Now you can edit the basic configuration file [ecf/config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h) to configure your experiment scenarios. Modify specifications for domain, data locations, settings for dynamics, physics, coupling host model etc. Read more about the options in [here](../HarmonieSystemDocumentation/ConfigureYourExperiment.md). You can also use some of the predefined configurations by calling Harmonie with the `-c` option:
```bash
   ~hlam/Harmonie setup -r PATH_TO_HARMONIE -h YOURHOST -c CONFIG -d DOMAIN
```
 where `CONFIG` is one of the setups defined in [Harmonie_configurations.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_configurations.pm). If you give `-c` with out an argument or a non existing configuration a list of configurations will be printed.
 * In some cases you might have to edit the general system configuration file, [Env_system](https://hirlam.org/trac/browser/Harmonie/config-sh/config.ecgb). See here for further information: [HarmonieSystemDocumentation/PlatformConfiguration](../HarmonieSystemDocumentation/PlatformConfiguration.md)
 * The rules for how to submit jobs on ecgb/cca are defined in  [Env_submit](https://hirlam.org/trac/browser/Harmonie/config-sh/submit.ecgb-cca). See here for further information: [HarmonieSystemDocumentation/PlatformConfiguration](../HarmonieSystemDocumentation/PlatformConfiguration.md)
 * If you experiment in data assimilation you might also want to change settings in [scr/include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass).

## Start your experiment
Launch the experiment by giving start time, `DTG`, end time, `DTGEND`
```bash
      ~hlam/Harmonie start DTG=YYYYMMDDHH DTGEND=YYYYMMDDHH
                                    # e.g., ~hlam/Harmonie start DTG=2012122400 DTGEND=2012122406
```

 If successful, Harmonie will identify your experiment name and start building your binaries and run your forecast. If not, you need to examine the ECFLOW log file `$HM_DATA/ECF.log`. `$HM_DATA` is defined in your `Env_system` file. At ECMWF `$HM_DATA=$SCRATCH/hm_home/$EXP` where `$EXP` is your experiment name. Read more about where things happen further down.

## Continue your experiment
If your experiment have successfully completed and you would like to continue for another period you should write
```bash
      ~hlam/Harmonie prod DTGEND=YYYYMMDDHH
```
By using `prod` you tell the system that you are continuing the experiment and using the first guess from the previous cycle. The start date is take from a file progress.log created in your `$HOME/hm_home/my_exp` directory. If you would have used `start` the initial data would have been interpolated from the boundaries, a cold start in other words.

## !Start/Restart of ecflow_ui

 To start the graphical window for ECFLOW on ecgb type

```bash
      ~hlam/Harmonie mon
```

 The graphical window runs independently of the experiment and can be closed and restarted again with the same command. With the graphical interface you can control and view logfiles of each task. 

## Making local changes

Very soon you will find that you need to do changes in a script or in the source code. Once you have identified which file to edit you put it into the current `$HOME/hm_home/my_exp` directory, with exactly the same subdirectory structure as in the reference. e.g, if you want to modify a namelist setting 

```bash
   ~hlam/Harmonie co nam/harmonie_namelists.pm         # retrieve default namelist harmonie_namelists.pm
   vi nam/harmonie_namelists.pm                        # modify the namelist
```

Next time you run your experiment the changed file will be used. You can also make changes in a running experiment. Make the change you wish and rerun the `InitRun` task from the viewer. The !InitRun task copies all files from your local experiment directory to your working directory `$HM_DATA`. Once your `InitRun` task is complete your can rerun the task you are interested in. If you wish to recompile something you will also have to rerun the `Build` tasks.

## Directory structure
### ecgb
On ecgb, you can follow the progress of the runs on `$SCRATCH/hm_home/my_exp`
   * Working directory for the current cycle under `YYYYMMDD_HH`
   * Archived files under are in `$SCRATCH/hm_home/my_exp/archive`
       * A `YYYY/MM/DD/HH` structure for per cycle data is used
       * All logfiles under `archive/log`   
   * On ecgb log files per task are found under `/cca/perm/ms/$COUNTRY/$USER/HARMONIE/my_exp`. All logfiles are also gathered in html files named like e.g. `HM_Date_YYYYMMDDHH.html` which are archived in `$SCRATCH/hm_home/my_exp/archive/log` on ecgb.
   * Verification data available on the permanent disk `/hpc/perm/$GROUP/$USER/HARMONIE/archive/$EXP/archive/extract`     
### cca
More complete results and the main data are available on `cca:$SCRATCH/hm_home/my_exp`. Under these directories you will find:
   * All binaries under `bin`
   * IFS libraries, object files and source code under `lib/src` if you build with makeup
   * Scripts, config files, ecf and suite definitions under `lib/`
   * Utilities such as `makeup`, `gl_grib_api` or `oulan` under `lib/util`
   * Climate files under `climate`
   * Working directory for the current cycle under `YYYYMMDD_HH`
     * If an experiment fails it is useful to check the IFS log file, `NODE.001_01`, in the working directory of the current cycle ( `$HM_DATA/YYYYMMDD_HH` ). The failed job will be in a directory called something like Failed_this_job.
   * Archived files under `archive`
       * A `YYYY/MM/DD/HH` structure for per cycle data
        * `ICMSHHARM+NNNN` and `ICMSHHARM+NNNN.sfx` are atmospheric and surfex forecast output files
   * Verification input data under `extract`. This is also stored on the permanent disk `/perm/$GROUP/$USER/HARMONIE/archive/$EXP/archive/extract`
### ECFS
   * Since the disks on `cca`/`ecgb` are cleaned regularly we need to store data permanently on ECFS, the EC file system, as well. There are two options for ECFS, `ectmp` and `ec`. The latter is a permanent storage and first one is cleaned after 90 days. Which one you use is defined by the ECFSLOC variable. To view your data type e.g.
```bash
 els ectmp:/$USER/harmonie/my_exp
```
   * The level of archiving depends on `ARSTRATEGY` in `ecf/config_exp.h` . The default setting will give you one `YYYY/MM/DD/HH` structure per cycle data containing:
       * Surface analysis, `ICMSHANAL+0000[.sfx]`
       * Atmospheric analysis result `MXMIN1999+0000`
       * Blending between surface/atmospheric analysis and cloud variable from the first guess `LSMIXBCout`
       * `ICMSHHARM+NNNN` and `ICMSHHARM+NNNN.sfx` are atmospheric and surfex forecast model state files
       * `PFHARM*` files produced by the inline postprocessing
       * `ICMSHSELE+NNNN.sfx` are surfex files with selected output
       * GRIB files for fullpos and surfex select files
       * Logfiles in a tar file `logfiles.tar`
       * Observation database and feedback information in `odb_stuff.tar`.
       * Extracted files for obsmon in `sqlite.tar`
   * Climate files are stored in the `climate` directory
   * One directory each for  `vfld` and `vobs` data respectively for verification data
 
## Cleanup of old experiments

Once you have complete your experiment you may wish to remove code, scripts and data from the disks. Harmonie provides some simple tools to do this. First check the content of the different disks by

```bash
 Harmonie CleanUp -ALL
```

Once you have convinced yourself that this is OK you can proceed with the removal.

```bash
 Harmonie CleanUp -ALL -go 
```

If you would like to exclude the data stored on e.g ECFS ( at ECMWF ) or in more general terms stored under `HM_EXP` ( as defined in `Env_system` ) you run 

```bash
 Harmonie CleanUp -d
```

to list the directories intended for cleaning. Again, convince yourself that this is OK and proceed with the cleaning by

```bash
 Harmonie CleanUp -d -go
```

**NOTE that these commands may not work properly in all versions. Do not run the removal before you're sure it's OK**

You can always remove the data from ECFS directly by running e.g.

```bash
 erm -R ec:/YOUR_USER/harmonie/EXPERIMENT_NAME 
 or
 erm -R ectmp:/YOUR_USER/harmonie/EXPERIMENT_NAME 
```

 * For more information about cleaning with Harmonie read [here](../HarmonieSystemDocumentation/TheHarmonieScript.md)
 * For more information about the ECFS commands read [here](https://confluence.ecmwf.int/display/UDOC/ecfs.1)

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


