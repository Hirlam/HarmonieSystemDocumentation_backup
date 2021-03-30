```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/RadarData?action=edit"
```
# Assimilation of Radar Data
This documentation outlines how to retrieve, process and assimilate HDF5 radar data

## HARMONIE compilation
HIRLAM have made code changes to BATOR to allow the direct reading of HDF5 radar data and conversion to ODB suitable for use in the HARMONIE data assimilation system. If you wish to use these changes you must compile HARMONIE with support for HDF5. This requires the addition of *-DUSE_HDF5* to the FDEFS in your makeup config file as well has adding hdf5 to EXTMODS. [source:tags/harmonie-38h1.2/util/makeup/config.cca.gnu](https://hirlam.org/trac/browser/tags/harmonie-38h1.2/util/makeup/config.cca.gnu) is an example of a makeup config file 

## Format
 The BATOR code assumes the HDF5 radar data being read uses the OPERA Data Information Model (ODIM). See [http://www.eumetnet.eu/sites/default/files/OPERA2014_O4_ODIM_H5-v2.2.pdf](http://www.eumetnet.eu/sites/default/files/OPERA2014_O4_ODIM_H5-v2.2.pdf) for further information.

## Data retreival
Local HDF5 ODIM radar data can be used or, alternatively, can be retrieved from a BALTRAD ftp site.

## Data processing
The HARMONIE script system requires that the OPERA HDF5 data files be stored in RADARDIR (defined in ecf/config_exp.h ) and have a file name using the format: ${HDFID}_qcvol_${DATE}T${HH}00.h5 where: 
 * HDFID is a 5 digit OPERA radar identifier
 * DATE is the date
 * HH is the hour

## Common pitfalls
 * Forgetting to add -DUSE_HDF5 correctly to your config file
 * Incorrect RADARDIR
 * Incorrect file names
 * Incorrect format entered in refdata - BATOR is quite strict about how it reads the information in refdata:
```bash
02918zh  HDF5     radarv           20100808 03 
```

## Further reading
Martin Ridal's radar data assimilation presentation: [https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemTraining2014/Programme/MR_radarobservations.pdf](https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemTraining2014/Programme/MR_radarobservations.pdf)
