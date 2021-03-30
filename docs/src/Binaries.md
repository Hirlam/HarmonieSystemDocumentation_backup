```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Binaries?action=edit"
```


# HARMONIE binaries

 An installation of HARMONIE produces the following binaries:

 * ACADFA1D : Tool to generate initial and boundary data for MUSC
 * ADDPERT : Create initial perturbations
 * ADDSURF : Allows you to mix different files and add different fields
 * [ALTO](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=PINUTS) : Also known as PINUTS. Contains several diagnostic tools.
 * BATOR : Generate ODB from observations in various formats
 * bl95.x : Blacklist compiler, help program to generate object files from the blacklist
 * BLEND : Mixes to files
 * BLENDSUR : Mixes to files
 * cluster : Cluster ensemble members
 * CONVERT_ECOCLIMAP_PARAM : Generate binary files from ECOCLIMAP ascii files
 * dcagen : ODB handling tool
 * domain_prop : Helper program to return various model domain properties
 * FESTAT : Background error covariance calculations.
 * [fldextr](../HarmonieSystemDocumentation/PostPP/Extract4verification.md) : Extracts data for verification from model history files. Reads FA from HARMONIE and GRIB from ECMWF/HIRLAM.
 * [gl](../HarmonieSystemDocumentation/PostPP/gl.md) : Converts/interpolates between different file formats and projections. Used for boundary interpolation.
 * IOASSIGN/ioassign : ODB IO setup
 * LSMIX : Scale dependent mixing of two model states.
 * jbconv : Interpolates/extrapolates background error statistics files. For technical experimentation
 * lfitools : FA/LFI file manipulation tool
 * [MASTERODB](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykarpbasics43.pdf) : The main binary for the forecast model, surface assimilation, climate generation, 3DVAR, fullpos and much more.
 * MTEN : Computation of moist tendencies
 * [obsextr](../HarmonieSystemDocumentation/PostPP/Extract4verification.md) : Extract data for verification from BUFR files. 
 * obsmon : Extract data for observation monitoring
 * odb98.x : ODB manipulation program
 * [OFFLINE](http://www.cnrm.meteo.fr/surfex/) : The SURFEX offline model. Also called SURFEX
 * oulan : Converts observations in BUFR to OBSOUL format used by BATOR
 * PERTCMA : Perturbation of observations in ODB
 * PERTSFC : Surface perturbation scheme
 * [PGD](http://www.cnrm.meteo.fr/surfex/) : Generates physiography files for SURFEX.
 * PREGPSSOL : Processing of GNSS data
 * [PREP](http://www.cnrm.meteo.fr/surfex/) : Generate SURFEX initial files. Interpolates/translates between two SURFEX domains.
 * SFXTOOLS : Converts SURFEX output between FA and LFI format.
 * shuffle : Manipulation of ODB. Also called ODBTOOLS
 * !ShuffleBufr : Split bufr data according to observation type, used in the observation preprocessing.
 * [SODA](http://www.cnrm.meteo.fr/surfex/) : Surfex offline data assimilation
 * SPG : Stochastic pattern generator, https://github.com/gayfulin/SPG
 * [SURFEX](http://www.cnrm.meteo.fr/surfex/) : The SURFEX offline model. Also called OFFLINE
 * tot_energy : Calculates the total energy of a model state. Is used for boundary perturbation scaling.
 * [xtool](../HarmonieSystemDocumentation/PostPP/gl.md#xtool) : Compares two FA/LFI/GRIB files.

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----



