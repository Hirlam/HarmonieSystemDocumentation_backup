```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PostPP/Fullpos?action=edit"
```
# Postprocessing with FULL-POS

## Introduction

FULL-POS is a powerful postprocessing package, which is part of the 
common ARPEGE/IFS cycle. FULL-POS is documented by 
 * [Yessad (2011)](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article157): This documentation describes the software FULL-POS doing post-processing on different kind of vertical levels. In particular, post-processable variables and organigramme are given. Some aspects of horizontal and vertical interpolators (which may be used in some other applications) are also described.
 * [ykfpos38.pdf](http://www.cnrm.meteo.fr/gmapdoc/IMG/pdf/ykfpos38.pdf): FULL-POS in cycle 38
 * [El Khatib (2002)](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article17): Older documentation with a link to an old FULL-POS website.

FULL-POS is a special configuration (9xx) of the full model for setup and initialization. In other words it is a 0 hour forecast, with extra namelist settings for variables to (post)process and to write out. When generating initial or boundary files we are calling a special configuration of FULL-POS, e927.

## ecf/config_exp.h
The use of FULL-POS is controlled by the POSTP variable in the [source:Harmonie/ecf/config_exp.h] file:
```bash
POSTP="inline"                          # Postprocessing by Fullpos (inline|offline|none).
                                        # See Setup_postp.pl for selection of fields.
                                        # inline: this is run inside of the forecast
                                        # offline: this is run in parallel to the forecast in a separate task
```
"inline" is the default which means FULL-POS postprocessing is called from the forecast model as it runs. If you select "offline" the model is called independently of the running forecast model using the forecast model output files as inputs to be postprocessed. By selecting "none" no FULL-POS postprocessing will be carried out.

Output frequency by FULL-POS is controlled by PWRITUPTIMES, FPOUTINT and FREQ_RESET:
```bash
# Postprocessing times (space separated list)
PWRITUPTIMES="03 06 09 12 15 18 21 24 30 36 42 48 54 60"
FPOUTINT="-1"                           # Regular  interval if > 0. Not used if <= 0.

FREQ_RESET=3                            # Reset frequency of max/min values in hours, controls NRAZTS
```

## FULL-POS

The use of FULL-POS is controlled by the following namelists: NAMFPPHY, NAMFPDY2, NAMFPDYP,
NAMFPDYH, NAMFPDYI, NAMFPDYV, NAMFPDYT and NAMFPDYS. These namelists can be used to make an accurate list of post-
processed fields. It is possible to call FULL-POS when running the model. In such a configuration we can configure HARMONIE to write some parameters with a different frequency than the standard historical files produced. 

However, with "inline" postprocessing, it is possible to get, at each post-processing time step, exactly the fields you wish. In this case, you have to make other namelists file which will contain the selection of the fields you wish to get. First, you have to set in NAMCT0 the variable CNPPATH as the directory where the selection files will be. Under this directory, the name of a selection file must be xxtDDDDHHMM, where DDDDHHMM specifies the date/time of the post-processing time step.

The [Postpp](https://hirlam.org/trac/browser/Harmonie/scr/Postpp) script executes the "offline" FULL-POS postprocessing in HARMONIE system. 


The management of FULL-POS and the creation of selection files is made easier for the user by the 
[Select_postp.pl](https://hirlam.org/trac/browser/Harmonie/scr/Select_postp.pl) perl script. 

## Parameter selection
Some of the more relevant entries in this script:
 * **CFP2DF**: names of the 2D dynamics fields to be post-processed. Names have at maximum 16 characters. By default CFP2DF contains blanks (no 2D dynamical field to post-process).
 * **CFP3DF**: names of the 3D dynamics fields to be post-processed. Names have at maximum 12 characters. By default CFP3DF contains blanks (no 3D dynamical field to post-process).
 * **CFPPHY**: names of the physical fields to be post-processed. Names have at maximum 16 characters. By default CFPPHY contains blanks (no physical field to post-process). 
 * **CFPXFU**:  names of the instantaneous fluxes fields to be post-processed. Names have at maximum 16 characters. By default CFPXFU contains blanks (no instantaneous fluxes field to post-process).
 * **CFPCFU**: names of the cumulated fluxes fields to be post-processed. Names have at maximum 16 characters. By default CFPCFU contains blanks (no cumulated fluxes field to post-process).

You can define the levels you wish to output using the following variable:
 * **NRFP3S**: model levels to postprocess
 * **RFP3H**: height above ground levels to postprocess
 * **RFP3P**: pressure levels to postprocess
 * **RFP3PV**: PV levels to postprocess
 * **RFP3I**: temperature levels to postprocess

## Add new output
This section provides a simple example on how to add a new parameter/vertical level for postprocessing in [Select_postp.pl](https://hirlam.org/trac/browser/Harmonie/scr/Select_postp.pl).

To add new "height above ground" output at 150m to the FULL-POS output, two changes are required:
 * Add the new height, 150., to the RFP3H array
 * Add level array number to the @namfpdyh_lev level selection

```bash
cd $HOME/hm_home/levexp
$PATH_TO_HARMONIE/config-sh/Harmonie co scr/Select_postp.pl
cp scr/Select_postp.pl scr/Select_postp.pl.ori
### edit scr/Select_postp.pl
diff scr/Select_postp.pl scr/Select_postp.pl.ori
83c83
<  RFP3H => ['20.','50.','100.','150.','250.','500.','750.','1000.','1250.','1500.','2000.','2500.','3000.'],
---
>  RFP3H => ['20.','50.','100.','250.','500.','750.','1000.','1250.','1500.','2000.','2500.','3000.'],
132c132
<  @namfpdyh_lev = (1,2,3,4,5,6,7,8,9,10,11,12,13) ;
---
>  @namfpdyh_lev = (1,2,3,4,5,6,7,8,9,10,11,12) ;
```
## Expert users

In the FULL-POS namelist NAMFPC (variables explained in [yomfpc.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/module/yomfpc.F90)), the variables are placed into different categories:

 * LFPCAPEX: if true XFU fields used for CAPE and CIN computation (with NFPCAPE).
 * LFPMOIS: month allowed for climatology usage:
   * .F. => month of the model (forecast).
   * .T. => month of the file.
 * NFPCLI:  usage level for climatology:
   * 0: no climatology
   * 1: orography and land-sea mask of output only
   * 2: all available climatological fields of the current month
   * 3: shifting mean from the climatological fields of the current month to the ones of the closest month
 * NFPCAPE: kind of computation for CAPE and CIN:
   * 1 => from bottom model layer
   * 2 => from the most unstable layer
   * 3 => from mto standard height (2 meters) as recomputed values
   * 4 => from mto standard height (2 meters) out of fluxes (for analysis)
 * CFPFMT:  format of the output files, can take the following values:
   * ’MODEL’ for output in spherical harmonics.
   * ’GAUSS’ for output in grid-point space on Gaussian grid (covering the global sphere).
   * ’LELAM’ for output on a grid of kind ’ALADIN’ (spectral or grid-point coefficients).
   * ’LALON’ for a grid of kind "latitudes * longitudes".
  Default is ’GAUSS’ in ARPEGE/IFS, ’LELAM’ in ALADIN.
 * CFPDOM: names of the subdomains. Names have at maximum 7 characters.
   * If CFPFMT=’GAUSS’ or ’LELAM’ only one output domain is allowed.
   * If CFPFMT=’LALON’ the maximum of output subdomains allowed is 10.
   By default, one output domain is requested, CFPDOM(1)=’000’ and CFPDOM(i)=’’ for i>1.
 * L_READ_MODEL_DATE:  if: .TRUE. read date from the model

The default FA-names for parameters in different categories can be found from [suafn1.F90](https://hirlam.org/trac/browser/Harmonie/src/arp/setup/suafn1.F90#L687).

It's worth mentioning some of the variables postprocessed by FULL-POS
 * True vertical velocity w [VW] (for NH ALADIN only).
 * Potential vorticity P V [PV].
 * Pressure coordinate vertical velocity ω [VV].
 * Eta coordinate vertical velocity η [ETAD].
 * Absolute vorticity ζ + f [ABS].
 * Relative vorticity ζ [VOR].
 * Divergence D [DIV].
 * Satellite equivalents
  * MSAT7 MVIRI channels 1 and 2 ([MSAT7C1] and [MSAT7C2]).
  * MSAT8 MVIRI channels 1 to 8 ([MSAT8C1] to [MSAT8C8]).
  * MSAT9 MVIRI channels 1 to 8 ([MSAT9C1] to [MSAT9C8]).
  * GOES11 IMAGER channels 1 to 4 ([GOES11C1] to [GOES11C4]).
  * GOES12 IMAGER channels 1 to 4 ([GOES12C1] to [GOES12C4]).
  * MTSAT1 IMAGER channels 1 to 4 ([MTSAT1C1] to [MTSAT1C4]).

## Problems
Problems may be encountered with FULL-POS when running on large domains. Here are some things to look out for:
 * Increase the MBX_SIZE if you run out of MPI buffer space. 
 * Increase number of cores if you run out of memory.
 * Make sure NFPROMA and NFPROMA_DEP are small and equal to NPROMA.
 * Set NSTRIN=NSTROUT=NPROC in nampar0 if one of the above mentioned doesn't help.
 
[Back to the main page of the HARMONIE System Documentation](../../HarmonieSystemDocumentation.md)
----