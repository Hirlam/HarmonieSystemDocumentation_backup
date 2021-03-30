```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ObservationPreprocessing/Bator?action=edit"
```
# ODB creation: Bator
## General Description
The pre-processing step creates ODB (Observational Data Base) from various observation data files possibly in different formats.
 * Software: The programs used for pre-processing (!ShuffleBufr, oulan and BATOR) are not part of the IFS code. oulan is software developed at Météo France to extract (conventional) observations from their local database (BDM). The ASCII output from oulan, the OBSOUL file, is one of the inputs of BATOR. By default, oulan is no longer part of the observation processing chain. BATOR is also developed at Météo France to generate the ODB (Observational !DataBase) database for the ARPEGE/ALADIN/HARMONIE analysis system. ODB is a tailor made database software developed at ECMWF to manage very large observational data volumes assimilated in the IFS 4DVAR system, and to enable flexible post-processing of this data [(Sami Saarinen, 2006)](http://old.ecmwf.int/services/odb/odb_overview.pdf). HARMONIE's BATOR originates from the MF export-pack. The figure below describes the mechanism of the observation pre-processing in HARMONIE DA. To sum it up, !ShuffleBufr splits different observations into BUFR files and BATOR creates the ODB file using from BUFR/HDF5/NetCDF input files.


 * Compilation: BATOR is compiled using gmakpack or makeup.
 * Scripts: scr/Bator.
 * Input: BUFR/HDF5/NetCDF
 * Output: ODB databases for surface and upper-air data assimilation

## BATOR
BATOR creates the ODB files from observational data in BUFR/HDF5/NetCDF format. BATOR also includes filtering (blacklisting) of parameters from stations of different observation types. To run the BATOR program one needs files containing blacklist rules/information, namelist(s), file containing information about observations and their format – refdata -, and some setting for the ODB environment. Documentation provided by Météo France is available at [http://www.umr-cnrm.fr/gmapdoc/spip.php?article229](http://www.umr-cnrm.fr/gmapdoc/spip.php?article229). In particular: [BATOR namelists](http://www.umr-cnrm.fr/gmapdoc/IMG/pdf/namel_bator_cy43-en.pdf), [the param_bator.cfg file](http://www.umr-cnrm.fr/gmapdoc/IMG/pdf/param_bator_cy43-en.pdf) and [the batormap files](http://www.umr-cnrm.fr/gmapdoc/IMG/pdf/bator_changes.cy42_op1.pdf).

### observation window and timeslots
The timeslots characteristics are provided by BATOR using the following environment variables. These are defined in scr/Bator based on settings provided in scr/include.ass and ecf/config_exp.h.

|=Environment variable =|= Description                                                        =|
| --- | --- |
|ODB_ANALYSIS_DATE      |analysis date (YYYYMMDD)                                              |
|ODB_ANALYSIS_TIME      |analysis time (hhmmss)                                                |
|BATOR_NBSLOT           |number of timeslots needed [1, 9999]                                  |
|BATOR_WINDOW_LEN       |width of the temporal assimilation window (in minutes) [1, 9999]      |
|BATOR_WINDOW_SHIFT     |shift of the temporal assimilation window relative to the analysis time (in minutes). Must be negative. |
|BATOR_SLOT_LEN         |width of a standard timeslot (in minutes) [1, 9999]                   |
|BATOR_CENTER_LEN       |width of the centred timeslot (in minutes) [1, 9999]                  |

### batormap
The 'batormap' file lists all the input data files (BUFR,NETCDF,HDF5,OBSOUL) to translate and put in a particular ODB database. Several records can be stored in this file, each one composed by the following 4 fields (blank spaces are used as separator). The batormap file is created by scr/Bator based on settings provided in scr/include.ass and task arguments.

 * The ECMA database extension in which data will be stored, up to 8 characters.
 * The data filename extension, up to 8 characters.
 * Data filename format, up to 8 characters.
 * Kind of data or instrument, up to 16 characters. Must match a kind of data in the subroutine bator_initlong (src/odb/pandormodule/bator_init_mod.F90)

For example:
```bash
conv     conv     OBSOUL   conv
conv     synop    BUFR     synop
```

### param.cfg
BATOR reads BUFR data according to definitions describing BUFR templates in the *param.cfg* file. The general layout of definitions in the *param.cfg* file is as follows:
```bash
BUFR label
a b c d
codage  a1  desc_a1
...
codage  an   desc_an
control b1   val1
...
control bn   valn
offset  c1   inc1
...
offset  cn   incn
values  pos_d1 desc_d1
...
values  pos_dn desc_dn
/BUFR label
```
where: 
 * a: number of unexpanded descriptors (NTDLEN if you are familiar with bufrdc software).
 * b: number of "control" entries - "control" values used by src/odb/pandor/module/bator_decodbufr_mod.F90
 * c: number of "offset" entries - "jump" values used by src/odb/pandor/module/bator_decodbufr_mod.F90
 * d: number of "values" entries - bufrdc VALUES array indices of parameters
 * codage desc: FXY's of NTDLST array values
 * values desc: FXY's of NTDEXP array values

param.cfg files are stored in const/bator_param and linked for use by BATOR in scr/Bator

### Namelists
  * Namelists are needed for BATOR to deal with observations having format structure different than that of MF. For example to read local Seviri data in grib format, one should set some parameters (NLON_GRIB and NLAT_GRIB) in the NADIRS group. Note: If my last modifications will be accepted, we will need to set parameters in the mentioned group, so the use of this namelist become obligatory for “local” (outside MF) HARMONIE system. The namelist looks like this:
```bash
 &NADIRS
   LMFBUFR=.FALSE.,                                         # we are not using Météo France BUFR
   ASCAT_XYGRID=12500.,                                     # ASCAT XYGRID RESOLUTION /LR=25000m/HR=12500m/
   GPSSOLMETHOD="CENT",                                     # Selection method for GNSS data "CENT"/"MEAN"
   NbTempMaxLevels=6000,                                    # Maximum number of radiosonde levels read
   TempSondOrTraj=.FALSE.,                                  # .TRUE. = sondage vertical, .FALSE. = trajectoire
   TempSondSplit=.FALSE.,                                   # .TRUE. = on coupe le radiosondage/timeslot, .FALSE. = profil simple
   ElimTemp0=.FALSE.,                                       # suppression des TEMP sans delta lat/lon/time si .TRUE.
   ElimPilot0=.FALSE.,                                      # suppression des PILOT sans delta lat/lon/time si .TRUE.
   NFREQVERT_TPHR=100,                                      # thinning factor for radiosonde data
   NbMinLevelHr=300,                                        # level threshold for high-resolution treatement of sonde data
   TS_AMSUA(206)%t_select%ChannelsList(:) = -1,             # ...
   TS_AMSUA(206)%t_select%TabFov(:) = -1,                   # ...
   TS_AMSUA(206)%t_select%TabFovInterlace(:) = -1,          # ...
   :                                                        # :
   :                                                        # :
   :                                                        # :
   SIGMAO_COEF(1:18)=18*1.0,                                # Scaling of sigmo-o coefficients
 /
 &NAMSCEN
 /
 &NAMDYNCORE
 /
 &NAMSATFREQ
 /

```
  * Namelist to activate (bator) LAMFLAG (needed to extract the observations for the model + extension zone domain): one needs to fetch the bator_lamflag namelist using the following command
```bash
        lamflag_namelist VAR
```

```bash
 &NAMFCNT
   LOBSONLY=.FALSE.,
 /
 &NAMFGEOM
   EFLAT0=$LAT0,
   EFLON0=$LON0,
   EFLATC=$LATC,
   EFLONC=$LONC,
   EFLAT1=$LAT1,
   EFLON1=$LON1,
   EFDELX=$GSIZE,
   EFDELY=$GSIZE,
   NFDLUN=1,
   NFDGUN=1,
   NFDLUX=$NDLUXG,
   NFDGUX=$NDGUXG,
   Z_CANZONE=1500.,
   REDZONE=$REDZONE_BATOR,
   LVAR=$LVAR,
   LNEWGEOM=.TRUE.,
 /
 &NAMFOBS
   LSYNOP=$LSYNOP,
   LAIREP=$LAIREP,
   LDRIBU=$LDRIBU,
   LTEMP=$LTEMP,
   LPILOT=$LPILOT,
   LPAOB=$LPAOB,
   LSCATT=$LSCATT,
   LSATEM=$LSATEM,
   LSATOB=$LSATOB,
   LSLIMB=$LSLIMB,
   LRADAR=$LRADAR,
```

### Environment variables

  * ODB settings for BATOR:
```bash
		export ODB_CMA=ECMA
		export ODB_SRCPATH_ECMA=${d_DB}/ECMA.${base}
		export ODB_DATAPATH_ECMA=${d_DB}/ECMA.${base} 
		export ODB_ANALYSIS_DATE=${YMD}
		export ODB_ANALYSIS_TIME=${HH}0000
		export IOASSIGN=${d_DB}/ECMA.${base}/IOASSIGN
		export BATOR_NBPOOL=${NPOOLS}

		#--- prepare db dir
		RecreateDir ${d_DB}/ECMA.${base}	   
		#-- create IOASSIGN file for the given sub-base
		cd ${d_DB}/ECMA.${base}	
		export ODB_IOASSIGN_MAXPROC=${NPOOLS}
		$HM_LIB/scr/create_ioassign -l "ECMA" -n ${BATOR_NBPOOL}
```
where $base is the ODB base ($base can be conv (for conventional data), amsu (ATOVS/AMSU-A,AMSU-B/MHS), sev (for Sevir), iasi, radarv (radar) for example).
Important: If you would like to have more bases, do not forget to take that into consideration when generating the "batormap" file for BATOR to define which observations you would like to have in each base.

## Blacklisting

To avoid model forecast degradation, two files can be used to blacklist or exclude data from the analysis. They are also used to blacklist observations that the model cannot deal with because they are not representative (orography, breeze effects...). The reason for the existence of this method of 'blacklisting', built-in Bator, alongside with 'hirlam_blacklist.b' (built-in Screening) is to allow simple and quick changes (and especially without changing binary) in the operational suite.

The selection of an observation to be 'blacklisted' can be done using multi-criteria (SID/STATID, obstype, codetype, varno, channel/level, production center, sub-center producer, network (s) concerned (s), cycle (prod / assim), ..).

### LISTE_LOC
The LISTE_LOC file can be used to blacklist satellite data and also for other data by type and / or subtype for a given parameter (described by varno or not). The contents of the LISTE_LOC are as follows:

|=Column =|= Description                                                         =|= Format =|
| --- | --- | --- |
|1        |Type of action: N: blacklisted, E: exclude                             |a1        |
|2        |The observation type (obsytpe@hdr)                                     |i3        |
|3        |The observation code-type (codetype@hdr)                               |i4        |
|4        |The satellite ID with leading zeros (satid@sat)                        |a9        |
|5        |The centre that produced the satellite data                            |i4        |
|6        |The parameter ID (varno@body) or the satellite sensor ID (sensor@hdr)  |i4        |
|7        |Optional keywords of ZONx4, TOVSn, PPPPn, PROFn                        |          |

TOVSn C1 C2 ... Cn
 * can be aplied to ATOVS radiances
 * n can be at most 9 indicating the involved channels
 * the Ci values specify the channels to be blacklisted

PPPPn P1 P2 ... Pn
 * can be aplied to blacklist dierent pressure levels
 * n can be at most 9 indicating the involved levels
 * the Pi values specify the pressure levels (in hPa) to be blacklisted

PROFn P1a P2 ... Pn-1 I1 I2 ... In-1
 * n can be at most 9 indicating the involved layers
 * the Pi values specify the bottom and top levels of pressure layers (in hPa).
 * The rst layer is always [1000,P1]
 * the Ii values indicate if blacklisting should be applied (=1) or not (=0) to the given layer.

ZONx4 latmin latmax lonmin lonmax
 * can be applied to SATOB/GEOWIND data
 * if x=B then the pixels with lat < latmin or lat > latmax or lon < lonmin or lon > lonmax will be blacklisted
 * if x=C then the pixels with lat < latmin or lat > latmax or (lon > lonmin and lon < lonmax) will be blacklisted.

### LISTE_NOIRE_DIAP
The LISTE_NOIRE_DIAP (const/bator_liste) can be used to blacklist conventional observations by station identifier. The contents of the LISTE_NOIRE_DIAP are as follows:

|= Column  =|= Description                      =|= Format =|
| --- | --- | --- |
|1          |Observation type (obstype@hdr)      |i2        |
|2          |Observation name                    |a10       |
|3          |Observation codetype (codetype@hdr) |i3        |
|4          |Parameter ID (varno@body)           |i3        |
|5          |Station ID (statid@hdr)             |a8        |
|6          |Start date of blacklisting yyyymmdd |a8        |
|7          |Optional layer blacklisting (PROFn) |a180      |
PROFn P1a P2 ... Pn-1 I1 I2 ... In
 * n can be at most 9 indicating the involved layers
 * the Pi values specify the bottom and top levels of pressure layers (in hPa).The rst layer is always [1000,P1]
 * the Ii values indicate if blacklisting should be applied (=1) or not (=0) to the given layer. 
 * The Hxx keyword specifies the analysis hour that should be blacklisted e.g. H00 or H06 etc

Particularities - the blacklisting of certain parameters involves the automatic
blacklisting of other parameter summarized in the table below:

|=obstype =|= specied parameter =|= blacklisted parameters              =|
| --- | --- | --- |
|SYNOP     |39 (t2)              |39 (t2), 58 (rh2), 7 (q)               |
|SYNOP     |58 (rh2)             |58 (rh2), 7 (q)                        |
|TEMP      |1 (z)                |1 (z), 29 (rh), 2 (t), 59 (td), 7 (q)  |
|TEMP      |2 (t)                |2 (t), 29 (rh), 7 (q)                  |
|TEMP      |29 (rh)              |29 (rh), 7 (q)                         |
