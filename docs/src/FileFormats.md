```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/FileFormats?action=edit"
```


## File formats in HARMONIE

## Introduction

 The HARMONIE system reads and writes a number of different formats. 

## FA files

 Default internal format input/output for HARMONIE for gridpoint, spectral and SURFEX data. GRIB is used as a way to pack data, but the grib record cannot be used as such.

 * The header contains information about model domain, projection, spectral truncation, extension zone, boundary zone, vertical levels. 
 * Only one date/time per file.
 * FA routines are found under ifsaux/fa
 * List or convert a file with [gl](../HarmonieSystemDocumentation/PostPP/gl.md)
 * Other listing tool [PINUTS](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=PINUTS)

 [Read more](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=FA+)


## GRIB/GRIB2

 All FA files may be converted to GRIB after the forecast run. For the conversion between FA names and GRIB parameters check [this table](../HarmonieSystemDocumentation/Forecast/Outputlist/43h2.md).

 * List or convert a GRIB file with [gl](../HarmonieSystemDocumentation/PostPP/gl.md)

## NETCDF

 In climate mode all FA files may converted to NETCDF after the forecast run. For the conversion between FA names and NETCDF parameters check [this table](https://hirlam.org/trac/browser/Harmonie/util/gl/inc/nc_tab.h).

 * For the manipulation and listing of NETCDF files we refer to standard NETCDF tools.
 * NETCDF is also used as output data from some SURFEX tools.

## BUFR and ODB

 BUFR is the archiving/exchange format for observations. Observation Database is used for efficient handling of observations on IFS. ODB used for both input data and feedback information.

 Read more about observations in HARMONIE [here](../HarmonieSystemDocumentation/UseofObservation.md).

## DDH (LFA files )

 Diagnostics by Horizontal Domains allows you to accumulate fluxes from different packages over different areas/points. 
 
 * LFA files ( Autodocumented File Software )
 * [gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article44&var_recherche=LFA&var_lang=en)
 * under util/ddh

## Misc
 
 * vfld/vobs files in a simple ASCII format used by the [verification](../HarmonieSystemDocumentation/PostPP/Verification.md).
 * Obsmon files are stored in sqlite format.

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


