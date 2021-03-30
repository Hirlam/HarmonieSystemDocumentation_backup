```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Analysis/SurfaceAnalysis?action=edit"
```


# Surface Data Assimilation in HARMONIE

## Surface related variables in ecf/config_exp.h :


Surface model: **SURFACE = "surfex"** / "old_surface"
* **surfex**: SURFEX is used as surface model (default and used in all Harmonie configurations)
  The surface fields are in a separat AROMOUT_.LLLL.lfi file in LFI format. 
* old_surface: surface physics modelled by routines integrated in code
  The surface fields are a part of the atmospheric file (ICMSHXXXX+LLLL) in FA format.


Surface analysis method: **ANASURF = "CANARI_OI_MAIN"** / "CANARI_EKF_SURFEX"
* the horisontal interpolation of screen level parameters is performed by [CANARI](../../HarmonieSystemDocumentation/Analysis/CANARI.md) in both cases
* [CANARI_OI_MAIN](../../HarmonieSystemDocumentation/Analysis/CANARI_OI_MAIN.md) updates soil temperature, water and ice based on 2m analysis increments using coefficients that are derived empirically for ISBA2/3-layers scheme
* [CANARI_EKF_SURFEX](../../HarmonieSystemDocumentation/Analysis/CANARI_EKF_SURFEX.md) (experimental) updates soil parameters using the Extended Kalman Filter method.


**ANASURF_MODE = "before"** / "after"/ "both" - surface analysis performed before/after/both before and after 3DVAR

**ANASURF_INLINE = "yes"** /"no"
* yes: call SODA for updating soil parameters inside CANARI (default and experimental)
* no: soil parameters are updated after CANARI


## Some details

The default surface model is SURFEX and the default surface assimilation scheme is CANARI_OI_MAIN. CANARI_EKF_SURFEX was first implemented in cy37 and will be undergoing tests in experimental and research mode before it can be used in operational setups.

CANARI is used for Optimum Interpolation horizontally to find analysis increments in each grid point based on observations minus first guess. The SURFEX assimilation schemes use two different techniques to propagate this information into the ground. The two ways CANARI is used is separated by two namelist settings needed when running with SURFEX:

* LAEICS=.FALSE.
 No initialization of ground variables are done as they are in the SURFEX file
* LDIRCLSMOD=.TRUE.
 2 metre variables taken directly from input file because they without surfex are diagnosed from 0 metre and lowest model height with the model specific routine achmt.

CANARI was designed before SURFEX was introduced and some of the climate variables that normally exist in the input file for CANARI, do not exist when using SURFEX. This means the task Addsurf is run before CANARI, adding the needed fields from the FA climate file (mMM).

The screen level analyisis (eg. T2m) used in blending/3DVAR/4DVAR is the same as for CANARI in the old_surface case.

### Variables updated in CANARI for old_surface and SURFEX

[Module of namelist variables](https://hirlam.org/trac/browser/Harmonie/src/arpifs/module/qactex.F90)

HARMONIE namelist settings:
```bash
!  * LAET2M  : .T. 2 meter temperature analysis
!  * LAEH2M  : .T. 2 meter humidity analysis
!  * LAESNM  : .T. snow analysis
!  * LAESST  : .F. SST analysis
!  * LECSST  : .T. use ECMWF SST
!  * LAEPDS  : .F. surface pressure analysis
!  * LAEUVT  : .F. wind and temperature analysis
!  * LAEHUM  : .F. humidity analysis
!  * LAEV1M  : .F. 10 meter wind analysis
```

### Blacklisting of surface observation

It is possible, in HARMONIE data assimilation, to blacklist data from specific sites. Following example illustrate blacklisting of one automatic (type 24) **ship** measurement with code name **DBKR** starting from a certain date **March 6, 2012**,

```bash
   cd ~/hm_home/$exp
   Harmonie co LISTE_NOIRE_DIAP  # check out blacklist from the repository, e.g., source:Harmonie/nam/LISTE_NOIRE_DIAP
   (edit then nam/LISTE_NOIRE_DIAP to insert, e.g. at the last line, following

    1 SHIP        24  11 DBKR     03062012

```



[Back to the main page of the HARMONIE System Documentation](../../HarmonieSystemDocumentation.md)

