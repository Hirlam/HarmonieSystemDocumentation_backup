```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PostPP/Diagnostics?action=edit"
```
# Diagnostics

## Xtool

[xtool](../../HarmonieSystemDocumentation/PostPP/gl.md#xtool)



## SAL

[SAL](../../HarmonieSystemDocumentation/PostPP/gl.md#SAL)


## DDH

Diagnostics par Domaines Horizontaux (Diagnostics by Horizontal Domains) is a tool to create budgets of different processes in the model. Please read on in the gmap documentation: http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=DDH

## EZDIAG

From Lisa: Note, this is for printing out full 3D fields from the model physics to the FA-file. 

 1. In the routine that you would like to print out your fields add args:

```bash
     & PDIAG, KNDIAG,&
```

  and declare them

```bash
INTEGER(KIND=JPIM),INTENT(IN) :: KNDIAG
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PDIAG(KLON,KLEV,KNDIAG)
```

  Put values in the array if its dimension allows it, e.g.

```bash
IF (KNDIAG.GE.1) THEN
    PDIAG(KIDIA:KFDIA,KTDIA:KLEV,1)= YOURVAL(KIDIA:KFDIA,KTDIA:KLEV)
ENDIF
```

  or anything you wish. Note that the variable YOURVAL is now stored in NGFL_EZDIAG=1.

  You can store this way up to 25 diagnostic 3D fields in the historic files.

  If you want to store 2D fields, you can put them at different levels in the same 3D array.

 2. Remake the interfaces if running AROME (not needed if running ALARO), before recompiling.

 3. In the NAMGFL namelist:

```bash
! ADDITIONAL FIELDS FOR DIAGNOSTIC
   NGFL_EZDIAG=1,          ! <=25
   YEZDIAG_NL(1)%CNAME='YOURVAL',
   YEZDIAG_NL(1)%LADV=.F.,
```

  If you add more fields (e.g. you set NGFL_EZDIAG=4), I think you will also need to set the grib parameter, e.g.
  (the default is 999, that you can leave for the first one).

```bash
   YEZDIAG_NL(2)%IGRBCODE=998,
   YEZDIAG_NL(3)%IGRBCODE=997,
   YEZDIAG_NL(4)%IGRBCODE=996,
```

  Note that the two first places are already defined in harmonie_namelist.pm.

 4. In order to have your variable converted from FA to grib, add the new variable in util/gl/inc/trans_tab.h
