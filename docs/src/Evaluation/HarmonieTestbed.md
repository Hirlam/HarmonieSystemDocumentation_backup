```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Evaluation/HarmonieTestbed?action=edit"
```
# The HARMONIE testbed

The HARMONIE testbed provides a facility to run a number of well defined test cases using the existing script environment in HARMONIE. The ALADIN testbed,
[mitraillette](../../HarmonieSystemDocumentation/Evaluation/Mitraillette.md) runs test on the hart of the model, the dynamical core. The HARMONIE testbed tests the full script system as it is supposed to be used.

## Defining the configurations

### General

The testbed is a suite that launches and follows new experiments one at a time in a controlled environment. The testbed experiment takes care of compilation and also hosts the climate files generated by the tested configurations. Source and scripts changes shall be done in the testbed experiment and will be synchronized to the child experiment using the hm_CMODS option in HARMONIE. 

A number of basic configurations have been defined in [Harmonie_configurations.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_configurations.pm) as the deviation from the default setup in 
[config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h), [include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass) and [harmonie.pm](https://hirlam.org/trac/browser/Harmonie/suites/harmonie.pm). These configurations are controlled by the script 
[Harmonie_testbed.pl](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_testbed.pl). The script also contains a number of extra configurations tested from time to time. With the current settings, a test of AROME without 3DVAR would look like.

```bash

    # AROME no 3D-VAR but default blending of upper air from boundaries
    'AROME' => {
      'description' => 'Standard AROME settings without upper air DA',
      'PHYSICS'     => 'arome',
      'SURFACE'     => 'surfex',
      'DYNAMICS'    => 'nh',
      'ANAATMO'     => 'blending',
      'ANASURF'     => 'none',
      'DFI'         => 'none',
      'HOST_MODEL'  => 'ifs',
      'DOMAIN'      => 'DKCOEXP',
      'VLEV'        => '65',
      'BDINT'       => '3',
    },

```

The resulting output, in this case from AROME_BD_ARO running at ECMWF would look like:

```bash

 Using the configuration AROME_BD_ARO


 Input /gpfs/scratch/ms/spsehlam/hlam/test_harmonie/ecgb_c2a_testbed_trunk_mkp_12413/ecf/config_exp.h  
 Output ecf/config_exp.h  

 Change BUILD=${BUILD-yes}                     to BUILD=no 
 Change       BUILD_ROOTPACK=no to BUILD_ROOTPACK=no 
 Change BINDIR=${BINDIR-$HM_DATA/bin}                 to BINDIR=$HM_COMDAT/ecgb_c2a_testbed_trunk_mkp_12413/bin 
 Change DOMAIN=DKCOEXP                          to DOMAIN=TEST_8 
 Change VLEV=65                                 to VLEV=HIRLAM_60 
 Change LL=${LL-06}                             to LL=6 
 Change DYNAMICS="nh"                           to DYNAMICS=nh 
 Change PHYSICS="arome"                         to PHYSICS=arome 
 Change SURFACE="surfex"                        to SURFACE=surfex 
 Change DFI="none"                              to DFI=none 
 Change ANAATMO=3DVAR                           to ANAATMO=none 
 Change ANASURF=CANARI_OI_MAIN                  to ANASURF=none 
 Change OBDIR=$HM_DATA/observations             to OBDIR=$HM_DATA/../ecgb_c2a_testbed_trunk_mkp_12413/observations/ 
 Change HOST_MODEL="ifs"                        to HOST_MODEL=aro 
 Change HOST_SURFEX="no"                        to HOST_SURFEX=yes 
 Change SURFEX_INPUT_FORMAT=lfi                 to SURFEX_INPUT_FORMAT=fa 
 Change BDLIB=ECMWF                             to BDLIB=AROME 
 Change BDDIR=$HM_DATA/${BDLIB}/archive/@YYYY@/@MM@/@DD@/@HH@   to BDDIR=$HM_DATA/../ecgb_c2a_testbed_trunk_mkp_12413/archive_AROME/@YYYY@/@MM@/@DD@/@HH@/ 
 Change INT_BDFILE=$WRK/ELSCF${CNMEXP}ALBC@NNN@                 to INT_BDFILE=$ARCHIVE_ROOT/$YY/$MM/$DD/$HH/ELSCF${CNMEXP}ALBC@NNN@ 
 Change BDSTRATEGY=simulate_operational to BDSTRATEGY=same_forecast 
 Change BDINT=1                         to BDINT=3 
 Change SURFEX_PREP="no"                to SURFEX_PREP=yes 
 Change CLIMDIR=$HM_DATA/climate                to CLIMDIR=$HM_DATA/../ecgb_c2a_testbed_trunk_mkp_12413/climate/$DOMAIN/$PHYSICS 
 Change BDCLIM=$HM_DATA/${BDLIB}/climate        to BDCLIM=$HM_DATA/../ecgb_c2a_testbed_trunk_mkp_12413/climate/TEST_11/arome/ 
 Change INT_SINI_FILE=$WRK/SURFXINI.$SURFEX_OUTPUT_FORMAT       to INT_SINI_FILE=$ARCHIVE_ROOT/$YY/$MM/$DD/$HH/SURFXINI.$SURFEX_OUTPUT_FORMAT 
 Change ARCHIVE_ECMWF=yes                       to ARCHIVE_ECMWF=no 
 Change POSTP="inline"                          to POSTP=inline 
 Change MAKEGRIB=no                             to MAKEGRIB=yes 
 Add new settings JBDIR=$HM_REV/testbed_data/jb_data 
 Add new settings LARGE_EC_BD=no 
 Add new settings PLAYFILE=harmonie 
 Add new settings config=AROME 


 Input /gpfs/scratch/ms/spsehlam/hlam/test_harmonie/ecgb_c2a_testbed_trunk_mkp_12413/Env_submit 
 Output Env_submit 

 Change $nprocx=16; to $nprocx=2 
 Change $nprocy=16; to $nprocy=2 
 Change $nprocx=8; to $nprocx=2 
 Change $nprocy=16; to $nprocy=2 

```

As seen from the example above the script also changes the submission rules. These rules can be defined, per host, at the end of the script. Other host specific settings may also be defined to allow local changes of the test environment. In Harmonie_testbed.pl we find e.g. changes for ecgate:

```bash

 'ecgate' => {
   'BINDIR'     => '$HM_COMDAT/'.$EXP.'/bin',
   'BDDIR'      => '$HM_DATA/../'.$EXP.'/$BDLIB/$DOMAIN',
   'OBDIR'      => '$HM_DATA/../'.$EXP.'/observations/$DOMAIN',
   'LARGE_EC_BD' => 'no',
   'CLIMDIR'    => '$HM_DATA/../'.$EXP.'/climate/$DOMAIN/$PHYSICS',
  },

```

The host dependent settings will be imposed on all configurations. If a setting in any configuration is in conflict with the host settings the configuration settings will be used.

### Define changes in harmonie.pm

The changes to msms/harmonie.pm are controlled with a special syntax, like in the AROME_JB configuration.

```bash
   # AROME Structure function derivation
   'AROME_JB' => {
     'description' => 'Derive structure functions for AROME 3DVAR',
      ...
      'harmonie.pm' => ['ENSBDMBR','ENSCTL','SLAFLAG'],
        'ENSBDMBR'    => '[1,2,3,4]',
        'ENSCTL'      => '["001","002","003","004"]',
        'SLAFLAG'     => '[0]',
    },

```

The harmonie.pm key determines which keyword to find and replace. The list guarantees that the same keywords are not changed in e.g. ecf/config_exp.h .

## Testbed members

|=Name                 =|=DOMAIN       =|=DTGs                  =|=Dependencies =|=Description                                 =|=Active in =|
| --- | --- | --- | --- | --- | --- |
|AROME                  |TEST_11        |!2017093018-!2017100100 |None           |AROME with 2-D decomposition                  |CY43        |
|AROME_1D               |TEST_11        |!2017093018-!2017100100 |None           |AROME with 1-D decomposition                  |CY43        |
|AROME_2D               |TEST_11        |!2017093018-!2017100100 |None           |AROME with 2-D decomposition                  |            |
|AROME_3DVAR            |IRELAND150     |!2017093018-!2017100100 |None           |AROME_3DVAR                                   |CY43        |
|AROME_3DVAR_MARSOBS    |IRELAND150     |!2017093018-!2017100100 |None           |AROME_3DVAR including non-conventional observations from MARS |CY43        |
|AROME_3DVAR_2P         |TEST_11        |!2017093018-!2017100100 |None           |AROME_3DVAR with two patches                  |            |
|AROME_4DVAR            |SCANDINAVIA    |!2017093021-!2017100100 |None           |AROME_4DVAR                                   |            |
|AROME_BD_ALA           |TEST_8         |!2017093018-!2017100100 |ALARO          |AROME with ALARO LBCs                         |            |
|AROME_BD_ALA_ARO       |TEST_2.5       |!2017093018-!2017100100 |AROME_BD_ALA   |AROME with AROME LBCs                         |            |
|AROME_BD_ARO           |TEST_8         |!2017093018-!2017100100 |AROME          |AROME with AROME LBCs, no IO-server           |CY43        |
|AROME_BD_ARO_IO_SERV   |TEST_8         |!2017093018-!2017100100 |AROME          |AROME with AROME LBCs, with IO-server         |CY43        |
|AROME_BD_ARO_2P        |TEST_8         |!2017093018-!2017100100 |AROME          |AROME two patches with AROME LBCs             |            |
|AROME_CLIMSIM          |TEST_11        |!2012053100-!2012060200 |None           |AROME climate simulation, netcdf output       |CY43        |
|AROME_EKF              |TEST_11        |!2017093018-!2017100100 |None           |AROME with CANARI_EKF_SURFEX                  |            |
|AROME_EPS_COMP         |TEST_11        |!2017093018-!2017100100 |HarmonEPS      |AROME_3DVAR comparison of EPS control         |CY43        |
|AROME_MUSC             |TEST_11        |!2017093018-!2017100100 |AROME          |AROME MUSC                                    |CY43        |
|AROME_NONE             |TEST_11        |!2017093018-!2017100100 |None           |AROME no SFC/UA DA                            |            |
|AROME_NONE_2D          |TEST_11        |!2017093018-!2017100100 |None           |AROME no SFC/UA DA                            |            |
|AROME_NONE_BD_ALA_NONE |TEST_8         |!2017093018-!2017100100 |ALARO_NONE     |AROME no SFC/UA DA with ALARO LBCs            |            |
|AROME_NONE_BD_ARO_NONE |TEST_8         |!2017093018-!2017100100 |AROME_NONE     |AROME no SFC/UA DA with AROME LBCs            |            |
|ARONE_JB               |TEST_11        |!2017093018-!2017100100 |None           |Generation of JB statistics                   |CY43        |
|HarmonEPS              |TEST_11        |!2017093018-!2017100100 |AROME_EPS_COMP |HarmonEPS                                     |CY43        |
|HarmonEPS_IFSENSBD     |TEST_11        |!2019111021-!2019111103 |AROME_EPS_COMP |HarmonEPS with IFSENS boundaries              |CY43        |
|ALARO1_3DVAR_OLD       |TEST_11        |!2017093018-!2017100100 |None           |ALARO1 with 3DVAR and old_surface             |            |
|ALARO_1D               |TEST_11        |!2017093018-!2017100100 |None           |ALARO with 1-D decomposition                  |            |
|ALARO_2D               |TEST_11        |!2017093018-!2017100100 |None           |ALARO with 2-D decomposition                  |            |
|ALARO_3DVAR_OLD        |TEST_11        |!2017093018-!2017100100 |None           |ALARO_3DVAR with old_surface                  |            |
|ALARO_EKF              |TEST_11        |!2017093018-!2017100100 |None           |ALARO with CANARI_EKF_SURFEX                  |            |
|ALARO_EPS_COMP         |TEST_11        |!2017093018-!2017100100 | ???           |ALARO EPS?                                    |            |
|ALARO_MF_60            |TEST_11        |!2017093018-!2017100100 |None           |ALARO with VLEV=MF_60                         |            |
|ALARO_MUSC             |TEST_11        |!2017093018-!2017100100 |ALARO          |ALARO MUSC                                    |            |
|ALARO_NH_1D            |TEST_11        |!2017093018-!2017100100 |None           |ALARO with NH dynamics and 1-D decomposition  |            |
|ALARO_NH_2D            |TEST_11        |!2017093018-!2017100100 |None           |ALARO with NH dynamics and 2-D decomposition  |            |
|ALARO_NONE             |TEST_11        |!2017093018-!2017100100 |None           |ALARO with no SFC/UA DA                       |            |
|ALARO_OLD              |TEST_11        |!2017093018-!2017100100 |None           |ALARO with old_surface                        |            |
|ALARO_OLD_MUSC         |TEST_11        |!2017093018-!2017100100 |ALARO          |ALARO MUSC with old_surface                   |            |

## Testbed domains


## The playfile

The playfile used for the testbed is 
[testbed.tdf](https://hirlam.org/trac/browser/Harmonie/msms/testbed.tdf). Here each configuration is defined with a trigger, a task to create and one to follow the child experiments. 
Configurations inluded are listed in the TESTBED_LIST environment variable in ecf/config_exp.h 

```bash
 TESTBED_LIST="ALADIN ALADIN_3DVAR AROME"
```

If the child experiment fails the Follow_exp task will also fail. When the child experiment problem has been corrected and the task restarted, the follow task should be restarted. When, finally, the child experiment is finished the test family will be completed and next test case will be triggered. We may choose to let the testbed launch a new experiment if the current child experiment fails. This is done by setting in ecf/config_exp.h  

```bash
 TESTBED_CONT_ON_FAILURE=1
```


## Input data

The standard testbed configuration is run over several. The domain and resolution is chosen to be computationally cheap and not to give meteorologically interesting and meaningful results. Input data for running the testbed is ECMWF boundaries, observations, background error statistics and climate files. The latest data may be found  on cca:/scratch/ms/spsehlam/hlam/hm_home/some_recent_testbed_experiment/testbed_data and the data included is the following:

 * ECMWF boundaries for the tested periods
 * Observations
 * Background errors
 * Climate files
 * Forcing data for nested experiments
 
Download the data to your machine and put it on the default location `$HM_REV/testbed_data` or define your location in [Harmonie_testbed.pl](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_testbed.pl). If you wish to test the climate generation you simple redefine the location of the climate files or remove the existing ones in the climate directory of the testbed. The testbed data typically includes the following:

## Starting the testbed

The testbed experiment is setup as any normal experiment with

```bash
Harmonie setup -r REVISION -h HOST
```

The testbed is launched by

```bash
Harmonie testbed 
```

Before you start the testbed you should define your reference experiment. The reference experiment is picked automatically as an experiment with the same name but with lower revision number. The reference experiment can also be defined by the by setting REFEXP in ecf/config_exp.h  as the full path to another testbed experiment:

```bash

export REFEXP=/scratch/ms/spsehlam/hlam/hm_home/test_37h12

```


## Evaluation of the result

At the end of each testbed run the results are compared to a reference experiment using the script [Testbed_comp](https://hirlam.org/trac/browser/Harmonie/scr/Testbed_copmp)[scource:scr/Testbed_comp Testbed_comp]. The script uses xtool to check the numerical difference for the following output:

 * ECMWF input data
 * climate files
 * Interpolated boundary files
 * Output forecast files in FA format
 * Output forecast files in GRIB format
 * vfld/vobs files

In addition the internal consistency is checked by comparing runs with 

 * 1D vs 2D decomposition
 * EPS control vs a deterministic run
 * Run with and without IO-server

The choice of internal consistency tests reflects the history of problems and inconsistencies encountered.

```bash

HARMONIE testbed results from ecgb-vecf
Sat Nov 16 20:41:27 GMT 2019

Configuration: cca.gnu

Compare experiment ecgb_cca_testbed_develop_gnu_6147 and ecgb_cca_testbed_develop_gnu_6146

Check:ecmwf_bd
  Output grib file summary (differ/missing/total) 0/0/37
   comparison took 164 seconds
 Configuration ecmwf_bd is equal

Check:climate
  Output internal file summary (differ/missing/total) 0/0/52
   comparison took 34 seconds
 Configuration climate is equal

Check:AROME_3DVAR
  Output internal file summary (differ/missing/total) 0/0/36
   comparison took 79 seconds
  Output grib file summary (differ/missing/total) 0/0/96
   comparison took 91 seconds
  vfld/vobs file summary (differ/missing/total) 0/0/36
   comparison took 4 seconds
 Configuration AROME_3DVAR is equal

 ...

Compare AROME_BD_ARO and AROME_BD_ARO_IO_SERV
 No differences found
   comparison took 423 seconds

Testbed comparison complete

[ Status: OK]

 For more details please check /scratch/ms/spsehlam/hlam/hm_home/ecgb_cca_testbed_develop_gnu_6147/testbed_comp_6147.log_details

```

All the logs from any testbed experiment are posted to the testbed mailing list [https://hirlam.org/pipermail/testbed]. The test returns three different status signals

 * OK means that all configurations reproduces the result of your reference experiment.
 * OK, BUT NO COMPARISON means that the suit run through but that there was nothing to compare with
 * FAILED means that the internal comparisons failed
 * DIFFER means that one more configurations differ from your reference experiment
 * FAILED and DIFFER is a combination of the last two

 In addition to the summary information detailed information can be found in the archive about the art of the difference.

## When to use the testbed

It is recommended to use the testbed when adding new options or make other changes in the configurations. If your new option is not activated the result compared with the reference experiment should be the same, if not you have to start debugging. When changing things for one configuration it's easy to break other ones. In such cases the testbed is a very good tool make sure you haven't destroyed anything.

----

Last modified 