```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/VerticalGrid?action=edit"
```


# HARMONIE Vertical Model Level Definitions 

### **HARMONIE vertical coordinate**
HARMONIE model, similar to that of HIRLAM, is constructed for a general pressure based and terrain following vertical coordinate n(p,p,,s,,), where

n(0,P,,s,,) = 0 and n(p,,s,,,p,,s,,) = 1

The formulation corresponds to the ECMWF hybrid system. The model is formulated for a spherical coordinate system (lamda, theta), but in the code two metric coefficients (h,,x,,,h,,y,,) have been introduced. This is done to prepare the model for any orthogonal coordinate system or map projection with axes (x,y). 

To represent the vertical variation of the dependent variables (U, V, T and Q), the atmosphere is divided into "nlev" layers. These layers are defined by the pressures at the interfaces between them (the `half-levels'). From the general expression

p,,k+1/2,, = A,,k+1/2,,(n) + B,,k+1/2,,(n) * p,,s,,(x,y)          for k=0,1,...,nlev

the vertical surfaces for half-levels are defined. Pure pressure surfaces are obtained for B=0 and pure sigma surfaces for A=0. `full-level' pressure associated with each model level (middle of two half layers) is then determined accordingly.
### **Definition of model levels in HARMONIE**
The script [Vertical_levels.pl](https://hirlam.org/trac/browser/Harmonie/scr/Vertical_levels.pl) contains definition of vertical levels that have been used in the HIRLAM community for research and/or operational purposes. Currently the default model setup defines 65-level structure as derived by Per Unden, SMHI. Model level definitions for commonly used vertical structures in HARMONIE are listed below.
 * FourtyLevel: HIRLAM_40 model levels (same as Hirlam 6.2.1, Nov 2003 - HIRLAM 7.0, 2006 )
 * SixtyLevel: HIRLAM-60 model levels (same as Hirlam 7.1, March 2007 - 2012 )
 * [MF_60](../MFSixtyLevel.md): MF-60 model levels (same as Meteo France AROME since 2010 )
 * SixtyfiveLevel: 65 model levels (same as Hirlam 7.4, March 2012 - )
 * other levels: Prague_87, MF_70, 40 (ALADIN-40), ECMWF_60.

Note that *VLEV* is the name of the set of A/B coefficients defining your levels set in ecf/config_exp.h . There are e.g. more than one definition for 60 levels. To print the levels just run 
`scr/Vertical_levels.pl `

Usage:
` scr/Vertical_levels.pl [VLEV PRINT_OPTION] `
where:
 * VLEV: name of your level definition
 * PRINT_OPTION=AHALF: print A coefficients for *VLEV*
 * PRINT_OPTION=BHALF: print B coefficients for *VLEV*
 * PRINT_OPTION=NLEV: print number of levels for *VLEV*
 * PRINT_OPTION=NRFP3S: print NRFP3S namelist values for *VLEV*

For reference, we provide links detailing structure of the ECMWF [62 level](http://www.ecmwf.int/products/data/technical/model_levels/model_def_62.html) (ensemble and seasonal forecast), 
[91 level](https://www.ecmwf.int/en/forecasts/documentation-and-support/91-model-levels) (deterministic forecast) and the [137](https://www.ecmwf.int/en/forecasts/documentation-and-support/137-model-levels)-level deterministic forecast (starting June 25 2013, 38r2)]

When performing HARMONIE experiment, users can select vertical levels by changing VLEV in the script [config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h). If a non-standard level number is to be chosen, the script [Vertical_levels.pl](https://hirlam.org/trac/browser/Harmonie/scr/Vertical_levels.pl) needs to be edited to add layer definition.

### **Define new eta levels**

A brief description and some code on how to create new eta levels can be found [here](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/VerticalGrid/New_eta.tar.gz).

There is also an [interactive tool](https://www.hirlam.org/nwptools/vlevs.html) that can help you in creating a new set of levels.


The method is based on a program by Pierre Bénard, Meteo France, that is described in [this gmapdoc article](http://www.cnrm.meteo.fr/gmapdoc//spip.php?article62).

### **Relevant corresponding data set for different vertical structure**
HARMONIE 3D-VAR and 4DVAR upper air data assimilation needs background error structure function for each given vertical layer structure. It is noted that [the structure function data included in the reference HARMONIE repository](https://hirlam.org/trac/browser/trunk/const/jb_data) is only useful for reference configuration. Users that runs 3DVAR/4DVAR are strongly recommended to derive proper structure function data [following instructions in the HIRLAM wiki](../HarmonieSystemDocumentation/Structurefunctions.md) using own data archive to avoid improper use of structure function.


[HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


