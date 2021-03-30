```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PostPP/FileConversions?action=edit"
```
# File conversions - this page under construction

# FA --> GRIB

The default HARMONIE output is in FA format. HIRLAM/HARMONIE users are more used to dealing with data encoded according to GRIB, a WMO code for the representation of gridded data. Users have the option to convert HARMONIE FA format files to GRIB1 (short for GRIB edition 1), GRIB2 (short for GRIB edition 2) or NETCDF. Note that the NETCDF conversion is still experimental. References about different WMO GRIB editions (1, 2 and 3) can be found [[#GRIBeds | here]].

## ecf/config_exp.h

The option to convert model output can be selected in the [source:Harmonie/ecf/config_exp.h] experiment configuration file:
```bash

# **** GRIB ****
CONVERTFA=yes                    # Conversion of FA file to grib/nc (yes|no)
ARCHIVE_FORMAT=GRIB1|2           # Format of archive files (GRIB1|GRIB2|nc). Currently nc format is only available in climate mode
```

## Details
From the perspective of harmonie suite, the conversion FA to GRIB is carried out in the following tasks:
* [Makegrib_an](https://hirlam.org/trac/browser/Harmonie/ecf/Makegrib_an.ecf) - for fields produced in the analysis. This task is part of the !/Expe/Date/Hour/Cycle/PostAnalysis family.
* [Listen2file](https://hirlam.org/trac/browser/Harmonie/ecf/Listen2file.ecf) - for fields produced in the forecast. This task is part of the !/Expe/Date/Hour/Cycle/Forecast family, possibly through a set of intermediate families Process-i (depending on the values of variables MULTITASK and MAKEGRIB_LISTENERS as set in the [source:Harmonie/ecf/config_exp.h] experiment configuration file).

If ARCHIVE_FORMAT is set to *GRIB1* or *GRIB2*, the [Makegrib](https://hirlam.org/trac/browser/Harmonie/scr/Makegrib) bash script will be run from the tasks mentioned above (possibly through intermediate scripts). Finally, from the [Makegrib](https://hirlam.org/trac/browser/Harmonie/scr/Makegrib) script the [gl](../../HarmonieSystemDocumentation/PostPP/gl.md) tool will be called to convert HARMONIE output from FA to GRIB. Notice that if a more verbose job output is needed, e.g. for debugging, variable PRINTLEV can be set, at the beginning of Makegrib, to something else than 0.

Conversion of FA/lfi files to GRIB by gl:
```bash
    gl [-c] [-p] FILE [ -o OUTPUT_FILE] [ -n NAMELIST_FILE]

    gl -c FA/LFI-FILE -- converts the full field (including extension zone)
    gl -p FAFILE      -- excludes the extension zone ( "p" as in physical domain only) 
```

By default, **Makegrib** removes the biperiodic zone from FA files and creates GRIB files. HARMONIE data is produced on a Lambert projection. GRIB data can be interpolated onto different projections using gl. Further information is available in the [gl documentation](../../HarmonieSystemDocumentation/PostPP/gl.md).

Forecast output is converted from FA to GRIB in [Makegrib](https://hirlam.org/trac/browser/Harmonie/scr/Makegrib) using the following command:
```bash
  $MPPGL $BINDIR/gl -p $1 -o $2 -n namelist_makegrib${MG} || exit
```
where 
 * $1 is the input HARMONIE FA-file (ICSMH${HARM}+${ffff}, $HARM is the 4-char experiment identifier, $ffff is the forecast step)
 * $2 is the output HARMONIE GRIB file (fc${DATE}${HH}+${FFF}grib)
 * namelist_makegrib${MG} is 
```bash
&naminterp
 outkey%yy=$YY,
 outkey%mm=$MM,
 outkey%dd=$DD,
 outkey%hh=$HH,
 outkey%mn=00,
 outkey%ff=$FF,
 time_unit=$time_unit
 pppkey(1:3)%ppp =   1, 61,184
 pppkey(1:3)%ttt = 103,105,105,
 pppkey(1:3)%lll =   0,  0,  0,
 pppkey(1:3)%tri =   0,  4,  4,
 skipsurfex = .TRUE.,
 fstart(15) = $fstart,
 fstart(16) = $fstart,
 fstart(162) = $fstart,
 fstart(163) = $fstart,
/
```
In the namelist:
 * $YY/$MM/$DD/$HH  is the forecast initial time
 * $time_unit is the units of time to be used min/h
 * pppkey: selection of requested post-processed products (See: [Postprocessing with gl](../../HarmonieSystemDocumentation/PostPP/gl.md) for more details)
 * $fstart is the start hour for time-range products such as maximum temperature.

## WMO GRIB editions and references
[=#GRIBeds] Currently (Aug 2019) there are several editions of GRIB in use or in experimental phase.

* GRIB edition 2 is currently the main GRIB edition. See [WMO FM 92–XIV GRIB](https://library.wmo.int/doc_num.php?explnum_id=5831) for details of the format.

* GRIB edition 1 is nowadays considered a legacy code. However it is still used, not only for legacy gridded data, but also to encode currently generated data. See [WMO FM 92-XI GRIB](http://www.wmo.int/pages/prog/www/WMOCodes/WMO306_vI2/PrevEDITIONS/GRIB1/WMO306_vI2_GRIB1_en.pdf) for details of the format.

* There is an experimental WMO GRIB edition 3. See [WMO FM 92-16 GRIB](http://www.wmo.int/pages/prog/www/WMOCodes/WMO306_vI2/FM92-16-GRIB/FM-92-16_GRIB-edition-3_CBS-16.pdf) for details of the format.

[Back to the main page of the HARMONIE System Documentation](../../HarmonieSystemDocumentation.md)

----


