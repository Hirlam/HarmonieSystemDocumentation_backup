```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/TheHarmonieScript?action=edit"
```


## The Harmonie main script

The Harmonie script is the main user interface to the harmonie system. It is used to setup, start, check and control your experiment and environment. Below follows the most useful commands. There are other commands inherited from the HIRLAM environment that may or may not work. For a full list check
[Start](https://hirlam.org/trac/browser/Harmonie/scr/Start),
[Actions](https://hirlam.org/trac/browser/Harmonie/scr/Actions),
[Actions.pl](https://hirlam.org/trac/browser/Harmonie/scr/Actions.pl).

 * ` Harmonie setup [ -r REVISION] [ -h HOST] [ -d DOMAIN] [ -c CONFIGURATION] [ -l LEVELS] ` where:
  * REVISION is the path to the version of harmonie you are working with.
  * HOST is the name of the host you are working on. There should exist corresponding config-sh/config.HOST. 
  * CONFIGURATION is one of the predefined configurations in scr/Harmonie_testbed.pl. It a fast way to setup your favourite configuration.
  * DOMAIN is one of the predefined domains in ecf/config_exp.h 
  * LEVELS is one of the predefined level definitions in scr/Vertical_levels.pl

 * ` Harmonie start DTG=YYYYMMDDHH [ DTGEND=YYYYMMDDHH] [ optional environment variables] ` launches a cold start run.
   * DTG is the initial time of your experiment
   * Several other optional variables can be given like
     * PLAYFILE=FILENAME use a different ecflow suite definition file. Default is harmonie.tdf
     * BUILD=yes|no to turn on and off compilation
     * CREATE_CLIMATE=yes|no to turn on and off generation of climate files
     * Any environment variable that you would like to send to the system.

 * ` Harmonie prod ` will continue from the DTG given in your progress.log file. The rest of the arguments is as for `Harmonie start`. This should be used to continue and experiment. It is assumed that a first guess file is available and the run will fail if this is not found.    

 * ` Harmonie mon ` will restart your ecflow_ui window and try to connect to an existing ecflow server.

 * ` Harmonie co [FILE|PATH/FILE] ` will copy the request file from the version chosen in your setup ( as pointed out in the config-sh/hm_rev file ) to your local directory. If the PATH is not given a search will be done. If the name matches several files you will be given a list to choose from.

 * ` Harmonie install ` will build your libraries and binaries but not start any experiment

 * ` Harmonie testbed ` will launch the [Harmonie testbed](../HarmonieSystemDocumentation/Evaluation/HarmonieTestbed.md)

 * ` Harmonie diff [--xxdiff] ` will look for differences between the revision in config-sh/hm_rev and HM_LIB.

 * ` Harmonie CleanUp -ALL -go ` will clean the following directories: HM_DATA,HM_LIB,HM_EXP. Instructions from [Actions.pl](https://hirlam.org/trac/browser/Harmonie/scr/Actions.pl):

```bash
# args: if -go: remove, (default is to list but not remove the matching files)
#       if -k*: do not do the long term archive HM_EXP - so keep it
#       if -d*: combination of -k and -ALL (-d* means: disks)
#       if -ALL: treat all files and also (if -go) remove the directories
#       a pattern is usually a string without meta-characters. To this
#       a * is appended (so e.g. ob will affect all files ob*); this can
#       be inhibited by appending ~ (so ob~! translates to ob).
#       Also, files in all subdirectories P*_* will be affected
#       where P is the pattern [0-9][0-9], This resembles
#       a `CYCLEDIR'. So ob will result in 'ob* P*_*/ob*'.
#       The pattern P*_* will be prepended to every / in the pattern,
#       unless the / is preceded by ~ (which will be removed).
#       Hence, to remove e.g. all analyses from 1995, use 1995/an,
#       which translates to 1995[0-9][0-9]*_*/an*
#       (to be precise: use: CleanUp("REMOVE:1995/an", "-go");
```

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


