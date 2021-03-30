```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/DigitialFilterInitialization?action=edit"
```
# Harmonie system Documentation
## Digital Filter Initialization
== Introduction
Digital Filter Initialization (DFI) is documented by Météo France here: [http://www.cnrm.meteo.fr/gmapdoc//spip.php?article158&lang=en](http://www.cnrm.meteo.fr/gmapdoc//spip.php?article158&lang=en). This wiki page is based on the "Version cycle 40t1" document available on the gmapdoc web page. By default HARMONIE does not use DFI. 

## DFI

The use (or not) of DFI is controlled by the variable DFI in [ecf/config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h). By default it is set to "none". 

 * "idfi", incremental DFI
 * "fdfi", full DFI 
 * "__none__" - no initialization (default)

[scr/Dfi](https://hirlam.org/trac/browser/Harmonie/scr/Dfi) is the script which calls the model in order to carry out DFI.

## References
 * YESSAD K. (METEO-FRANCE/CNRM/GMAP/ALGO) July 7, 2015: [DIGITAL FILTERING INITIALISATION IN THE CYCLE 42 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykdfi42.pdf)
 * YESSAD K. (METEO-FRANCE/CNRM/GMAP/ALGO) March 17, 2015: [DIGITAL FILTERING INITIALISATION IN THE CYCLE 41T1 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykdfi41t1.pdf)
 * YESSAD K. (METEO-FRANCE/CNRM/GMAP/ALGO) August 6, 2014: [DIGITAL FILTERING INITIALISATION IN THE CYCLE 41 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykdfi41.pdf)
 * YESSAD K. (METEO-FRANCE/CNRM/GMAP/ALGO) March 12, 2014: [DIGITAL FILTERING INITIALISATION IN THE CYCLE 40T1 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykdfi40t1.pdf)
 * YESSAD K. (METEO-FRANCE/CNRM/GMAP/ALGO) July 3, 2013: [DIGITAL FILTERING INITIALISATION IN THE CYCLE 40 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykdfi40.pdf)


[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


