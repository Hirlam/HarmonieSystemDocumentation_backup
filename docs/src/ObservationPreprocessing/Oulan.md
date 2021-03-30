```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ObservationPreprocessing/Oulan?action=edit"
```
# OBSOUL creation: Oulan

## General Description
The pre-processing step creates ODB (Observational Data Base) from various observation data files possibly in different formats.
 * Software: The programs used for pre-processing (Shufflebufr, oulan and BATOR) are not part of the IFS code. oulan is software developed at Météo France to extract observations from their local database (BDM). The output of oulan (OBSOUL) is one of the inputs of BATOR. BATOR is also software developed at Météo France to generate the ODB (Observational !DataBase) database for the ARPEGE/ALADIN/HARMONIE analysis system. ODB is a tailor made database software developed at ECMWF to manage very large observational data volumes assimilated in the IFS 4DVAR system, and to enable flexible post-processing of this data [(Sami Saarinen, 2006)](http://old.ecmwf.int/services/odb/odb_overview.pdf). We use oulan to generate an OBSOUL file from different BUFR files (note you can easily change the oulan program to handle data in different format than BUFR. For example in OPLACE data processing some files are in netCDF format). OBSOUL file is an ASCII formatted file, the content of which is similar to that of the CMA (Central Memory Array, packing format actually in use in the HIRLAM data assimilation system). Our version of ouland is placed under “util” directory in the repository. HARMONIE BATOR originates from the MF export-pack. The figure bellow describes the mechanism of the observation pre-processing in HARMONIE DA. To sum it up, !ShuffleBufr splits different observations into BUFR files, then oulan creates the OBSOUL file, and BATOR creates the ODB file using satellite BUFR/GRIB/BIN files and the OBSOUL one.
 * Compilation: oulan, Shufflebufr are compiled using gmakpack or makeup.
 * Scripts: Oulan
 * Input/output
   * oulan  input: BUFR files; output: the OBSOUL file in ASCII format
## !ShuffleBufr
!ShuffleBufr splits different observations into separate BUFR files according the IFS observation type/sub-type definition. Some of them (essentially those of conventional observations) are then fed to OULAN; the others go directly into BATOR.
```bash
    PROGRAM SHUFFLEBUFR
    Split and shuffle BUFR file into  specific BUFR files for OULAN
  
    Usage: SHUFFLEBUFR -i <bufr_file> [-s1|-s2|-s3]  [-a] [-r]
  
           -s1 : Synop ship will be extracted in <synop>
           -s2 : Synop ship will be extracted in <buoy>
           -s3 : Synop ship will be extracted in <ship>
  
           Nota Bene: If -s1,-s2 or -s3 are not specified
                      synop_ship will not be extracted
  
           -a  : Extracts ATOVS in files amsua and amsub
  
           -r  : Extracts also record messages (synop)
```

The splitting is done with the following command ($BUFRFILE is a file containing all observations) in the Oulan script:
```bash
      $BINDIR/ShuffleBufr -i ${BUFRFILE} -s3 -a 
```
## oulan
oulan reads (primarily conventional observation) BUFR data and converts them into ASCII format OBSOUL files. Note, **we can make observation selection** in oulan. More details about how to do data selection can be found [here (Randriamampianina, ALADIN/HIRLAM Workshop 2005)](http://owww.met.hu/pages/seminars/ALADIN2005/28_Bp_workshop1n_n_RogerR.ppt)
  1. namelist description: 

| **NADIRS**          |                                                                |
| --- | --- |
|ALANZA=90.,            |If LZONEA is true then only extract observations south of 90N   |
|ALASZA=0.,             |If LZONEA is true then only extract observations north of 0     |
|ALOEZA=-180.,          |If LZONEA is true then only extract observations west of 180W   |
|ALOOZA=180.,           |If LZONEA is true then only extract observations west of 180E   |
|LNEWSYNOPBUFR=.FALSE., |Process new format BUFR SYNOP **experimental**                |
|LNEWSHIPBUFR=.FALSE.,  |Process new format BUFR SHIP **experimental**                 |
|LNEWBUOYBUFR=.FALSE.,  |Process new format BUFR BUOY **experimental**                 |
|LNEWTEMPBUFR=.FALSE.,  |Process new format BUFR TEMP **experimental**                 |
|LACAR=.TRUE.,          |Process ACARS BUFR data                                         |
|LAIREP=.TRUE.,         |Process AIREP BUFR data                                         |
|LAMDAR=.TRUE.,         |Process AMDAR BUFR data                                         |
|LBUOY=.TRUE.,          |Process BUOY BUFR data                                          | 
|LEUROPROFIL=.FALSE.,   |Process European Profiler BUFR data                             | 
|LPILOT=.TRUE.,         |Process PILOT BUFR data                                         |  
|LRH2Q=.FALSE.,         |Extract 2m RH from SYNOP, BUOY and TEMP BUFR data               |
|LSHIP=.TRUE.,          |Process SHIP BUFR data                                          |
|LSYNOP=.TRUE.,         |Process SYNOP BUFR data                                         |
|LTEMP=.TRUE.,          |Process TEMP BUFR data                                          |
|LTEMPDROP=.TRUE.,      |Process DROPTEMP BUFR data                                      |
|LTEMPSHIP=.TRUE.,      |Process TEMPSHIP BUFR data                                      |
|LTOVSAMSUA=.FALSE.,    |Process AMSUA data                                              |
|LTOVSAMSUB=.FALSE.,    |Process AMSUB data                                              |
|LTOVSHIRS=.FALSE.,     |Process HIRS data                                               |
|LZONEA=.TRUE.,         |Switch to extract data in defined lat-lon domain (N,S,E,W)      | 
|NDATE=DDATE,           |OBSOUL Date                                                     |
|NDIFFM1=30,            |Define analysis window (T-NDIFFM1)                              |
|NDIFFM2=300,           |Define analysis window (T-NDIFFM2)                              |
|NDIFFP1=30,            |Define analysis window (T+NDIFFP1)                              |
|NDIFFP2=259,           |Define analysis window (T+NDIFFP2)                              |
|NINIT=0,               |flag used by oulan to prevent writing if problem is found       | 
|NRESO=HHOUR,           |OBSOUL Hour                                                     |
| **NANBOB**          |Namelist to define number of observations to be extracted       |
|NBACAR=750000,         |Number of ACAR obs                                              |
|NBAIREP=750000,        |Number of AIREP obs                                             |
|NBAMDAR=750000,        |Number of AMDAR obs                                             |
|NBBUOY=  4000,         |Number of BUOY obs                                              |  
|NBEUROPROFIL= 15000,   |Number of European profiler obs                                 | 
|NBPILOT=  2000,        |Number of PILOT obs                                             |  
|NBSHIP= 30000,         |Number of SHIP obs                                              | 
|NBSYNOP= 60000,        |Number of SYNOP obs                                             |  
|NBTEMP=  2000,         |Number of Land TEMP obs (since r14078)                          | 
|NBTEMPDROP=  1000,     |Number of DROPTEMP obs (since r14078)                           |
|NBTEMPSHIP=  1000,     |Number of Ship TEMP obs (since r14078)                          |
|NBTOVSAMSUA= 80000,    |Number of AMSUA obs                                             |
|NBTOVSAMSUB= 80000,    |Number of AMSUB obs                                             |
|NBTOVSHIRS=  8000,     |Number of HIRS obs                                              |

  1. make a namelist
```bash
  NAMELIST=$WRK/$WDIR/namelist_oulan
  Get_namelist oulan $NAMELIST
  sed -e "s/DDATE/$SDATE/" \
      -e "s/HHOUR/$SHOUR/"
      -e "s/SALOOZA/$OULWEST/"  \
      -e "s/SALANZA/$OULNORTH/"  \
      -e "s/SALOEZA/$OULEAST/"  \
      -e "s/SALASZA/$OULSOUTH/" \
      -e "s/SLNEWSYNOPBUFR/$SLNEWSYNOPBUFR/" \
      -e "s/SLNEWSHIPBUFR/$SLNEWSHIPBUFR/" \
      -e "s/SLNEWBUOYBUFR/$SLNEWBUOYBUFR/" \
      -e "s/SLNEWTEMPBUFR/$SLNEWTEMPBUFR/" \
      ${NAMELIST} >NAMELIST
```
  1. run oulan
```bash
    $BINDIR/oulan 
```
  1. process GNSS data. If $GNSS_OBS is set to 1 then GNSS observations are added to the OBSOUL file and whitelisting is carried out using PREGPSSOL
### New BUFR templates
**Valid for HARMONIE 40h1 and later**

The use of new format (GTS WMO) BUFR is controlled in [scr/include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass) by LNEWSYNOPBUFR, LNEWSHIPBUFR, LNEWBUOYBUFR, LNEWTEMPBUFR (set to 0 or 1). These environment variables control namelist settings in the Oulan script. GTS and ECMWF BUFR were used to guide the code changes so Oulan assumes either "flavour" of BUFR. Local changes may be required if your locally produced BUFR, in particular section 1 data sub-type settings, do not follow WMO and/or ECMWF practices.

The ECMWF wiki contains updates regarding the quality of the new BUFR HR observations. See the following ECMWF wiki pages for furher information:
 * [https://software.ecmwf.int/wiki/display/TCBUF/TAC+To+BUFR+Migration](https://software.ecmwf.int/wiki/display/TCBUF/TAC+To+BUFR+Migration)
 * [https://software.ecmwf.int/wiki/display/TCBUF/Statistics+of+High+resolution+BUFR+TEMP](https://software.ecmwf.int/wiki/display/TCBUF/Statistics+of+High+resolution+BUFR+TEMP)