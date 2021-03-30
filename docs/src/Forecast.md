```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Forecast?action=edit"
```
# Harmonie system Documentation
## Forecast
== Introduction

## Forecast

[Forecast](https://hirlam.org/trac/browser/Harmonie/scr/Forecast) is the script, which initiates actual 
forecast run (ALADIN/AROME/ALARO depending on *FLAG* and *PHFLAG*).

 * Input parameters: none.
 * Data: Boundary files (**ELSCF***-files). Initial file (**fc_start**). If data assimilation is used, **fc_start** is the analysis file. In case of dynamical adaptation, **fc_start** is the first boundary file. In case of AROME, Surfex initial file (**SURFXINI.lfi**) is also needed ([Prep_ini_surfex](https://hirlam.org/trac/browser/Harmonie/scr/Prep_ini_surfex)). 
 * Namelists: namelist templates nam/namelist_fcst${FLAG}_default are fetched based on *FLAG* and *PHFLAG*. The templates are completed in [Forecast](https://hirlam.org/trac/browser/Harmonie/scr/Forecast) based on the choices of *NPROCX*, *NPROCY* (see [submit.ecgb](https://hirlam.org/trac/browser/Harmonie/config-sh/submit.ecgb)), *TFLAG*, *OUTINT*, *BDINT* and *REDUCELFI*. In case of AROME also the namelists to control SURFEX-scheme  ([TEST.des](https://hirlam.org/trac/browser/Harmonie/nam/TEST.des) and [EXSEG1.nam](https://hirlam.org/trac/browser/Harmonie/nam/EXSEG1.nam)) are needed.
 * Executables: as defined by *MODEL*.
 * Output: Forecast files (spectral files **ICMSHALAD+***). In case of AROME, Surfex files containing the surface data (**AROMOUT_*.lfi**). 

### Forecast namelists

The current switches in the HARMONIE system (in [config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h)) provide only very limited possibility to control the different aspects of the model. If the user wants to have more detailed control on the specific schemes etc., one has to modify the variety of the namelists options.

In general, the different namelist options are documented in the source code modules (e.g. src/arp/module/*.F90). Below is listed information on some of the choices.   

__NH-dynamics/advection/time stepping__:

 * A detailed overview of the such options has been given by [Vivoda (2008)](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article189). 
 
__Upper air physics switches__

 * Switches related to different schemes of ALADIN/ALARO physics, [yomphy.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomphy.F90).
 * Switches related to physics schemes in AROME [yomarphy.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomarphy.F90).
 * Switches to tune different aspects of physics, [yomphy0.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomphy0.F90), [yomphy1.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomphy1.F90), [yomphy2.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomphy2.F90) and [yomphy3.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomphy3.F90)
 * Switches related to HIRLAM physics, [yhloption.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yhloption.F90) and [suhloption.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/setup/suhloption.F90).

__Initialization switch__

 * Initialization is controlled by namelist *NAMINI/NEINI*, [yomini.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomini.F90).

__Horizontal diffusion switches__

 * Horizontal diffusion is controlled by namelist *NAMDYN/RDAMP**, [yomdyn.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomdyn.F90#L55). Larger the coefficient, less diffusion.

__MPP switches__

 * The number of processors in HARMONIE are given in [submit.HOST](https://hirlam.org/trac/browser/Harmonie/config-sh/submit.ecgb). These values are transfered in to [yomct0.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomct0.F90#L276) and [yommp.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yommp.F90).

__Surface SURFEX switches__

 * The SURFEX scheme is controlled through namelist settings in [surfex_namelists.pm](https://hirlam.org/trac/browser/Harmonie/nam/surfex_namelists.pm). [The different options are described here](../HarmonieSystemDocumentation/Namelists.md#surfex_namelists.pm).


## Archiving

Archiving has a two layer structure. Firstly, all the needed analysis forecast and field extract files  
are stored in *ARCHIVE* directory by [Archive_fc](https://hirlam.org/trac/browser/Harmonie/scr/Archive_fc). This is the 
place where the postprocessing step expects to find the files. 

At ECMWF all the requested files are stored to ECFS into directory *ECFSLOC* by the script [Archive_ECMWF](https://hirlam.org/trac/browser/Harmonie/scr/Archive_ECMWF)


[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


