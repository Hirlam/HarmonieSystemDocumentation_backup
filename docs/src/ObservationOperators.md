```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ObservationOperators?action=edit"
```
# Observation operators
This documentation summarises the observation operator in HARMONIE and the use of the HOP_DIRVER tool. The test harness, HOP_DRIVER, calls the observation operator and generates FG departures without calling any model code or initialising any model modules. Firstly, the IFS is used to dump a single-observation gom_plus to file from the 1st trajectory of an experiment. Dumping multiple observations would require a more complex and full-featured dump (good file format, multi-process parallel). For code refactoring HOP_DRIVER can be used to test changes to the observation operator of a particular observation type.

## HARMONIE and HOP_DRIVER
The HOP_DRIVER program was first added to CY42R2 code. The tool was initially implemented to test refactoring of the IFS observation operator code src/arpifs/op_obs/hop.F90. At the moment the refactor branch ([branches/refactor/harmonie](https://hirlam.org/trac/browser/branches/refactor/harmonie)) is the only HARMONIE code set that includes HOP_DRIVER. Instructions on how to prepare the code and run HOP_DRIVER using HARMONIE are outlined below. Presentation made at [OOPS Observation Operator Workshop](../HirlamMeetings/ModelMeetings/ObOpWorkshop.md) may provide some useful background information.
### Comments on the branch
 * Code changes were required in order to compile cy42r2bf.04 + mods (provided by MF/ECMWF) in the HARMONIE system: [14312], [14325], [14326], [14330], [14331], [14332], [14333], [14334].
 * Changes were made to makeup in order to compile HOP_DRIVER correctly: [14310], [14327], [14328], [14329], [14335], [14362], [14382], [14392].
 * Included in [14362] is a change to ODBSQLFLAGS which is set to "ODBSQLFLAGS=-O3 -C -UCANARI -DECMWF $(ODBEXTRAFLAGS)" in order to use ECMWF flavoured ODB used by HOP_DRIVER
 * On cca GNU compilers 4.9 are not fully supported, ie I had to build GRIB-API and NetCDF locally using gcc/gfortran 4.9 on cca
 * An environment variable, HOPDIR, is used to define the location of necessary input data for HOP_DRIVER
 * An environment variable, HOPCOMPILER, is used by the HOP_driver script to define the compiler used. This is used to compare results.

### Running on ecgb/cca
```bash
cd $SCRATCH
mkdir -p harmonie_releases/branches/refactor
cd harmonie_releases/branches/refactor
svn co https://svn.hirlam.org/branches/refactor/harmonie-42R2
cd $HOME
mkdir -p hm_home/rfexp
cd hm_home/rfexp
$SCRATCH/harmonie_releases/branches/refactor/harmonie-42R2/config-sh/Harmonie setup -r $SCRATCH/harmonie_releases/branches/refactor/harmonie-42R2
$SCRATCH/harmonie_releases/branches/refactor/harmonie-42R2/config-sh/Harmonie hop_driver
```

### Running on local platforms
So far, only METIE.LinuxRH7gnu, which uses gfortran 4.9 and openmpi, has been tested. Input data for the amsua test case is available on ECFS at ECMWF: ec:/dui/hopdata.tar.gz
```bash
cd $HOME
mkdir -p harmonie_releases/branches/refactor
cd harmonie_releases/branches/refactor
svn co https://svn.hirlam.org/branches/refactor/harmonie-42R2
cd $HOME
mkdir -p hm_home/rfexp
cd hm_home/rfexp
$HOME/harmonie_releases/branches/refactor/harmonie-42R2/config-sh/Harmonie setup -h METIE.LinuxRH7gnu -r $HOME/harmonie_releases/branches/refactor/harmonie-42R2
$HOME/harmonie_releases/branches/refactor/harmonie-42R2/config-sh/Harmonie hop_driver
```


## HOPOBS: amsua
Currently there is only one observation type, AMSU-A (HOPOBS=amsua), available for testing with HOP_DRIVER. Alan Geer (ECMWF) has already carried out the refactoring of the HOP code related to AMSU-A observations. A single observation is provided in the ECMA and is used to test the refactoring of the HOP code. To carry out the testing of the amsua refactoring HOPOBS should be set to amsua in ecf/config_exp.h .

 |=reportype@hdr=|=obstype@hdr=|=sensor@hdr=|=statid@hdr =|=stalt@hdr=|=date@hdr =|=time@hdr=|=degrees(lat)=|=degrees(lon)=|=report_status@hdr=|=datum_status@body=|=obsvalue@body=|=varno@body=|=vertco_type@body=|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 12                | 173.28        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 12                | 158.86        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 3                 | 227.40        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 3                 | 260.82        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 256.90        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 239.60        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 12                | NULL          | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 3                 | 217.69        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 209.39        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 214.05        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 223.02        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 234.42        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 245.14        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 1                 | 257.18        | 119        | 3                |
 | 1007          | 7           | 3          | '        4' | 832800    | !20140131 | 215914   | -29.5906     | 0.3113       | 1                 | 12                | 227.91        | 119        | 3                |
## HOP_DRIVER
### Using HOP_DRIVER
With **LHOP_RESULTS=.TRUE.** HOP_DRIVER will write results to a file called *hop_results${MYPROC}* for comparison between online and offline results. (The results file is opened by [src/arpifs/var/taskob.F90](https://hirlam.org/trac/browser/branches/refactor/harmonie/src/arpifs/var/taskob.F90)). HOP_DRIVER results are written to *hop_results${MYPROC}* in [src/arpifs/op_obs/hop.F90](https://hirlam.org/trac/browser/branches/refactor/harmonie/src/arpifs/op_obs/hop.F90):
```bash
 :
 :
IF(LHOP_RESULTS) THEN
!$OMP CRITICAL
  ! Output for comparison between online and offline results:
  WRITE(CFILENAME,'("hop_results",I4.4)') MYPROC
  OPEN(NEWUNIT=IU,FILE=CFILENAME,POSITION='APPEND',ACTION='WRITE',FORM='FORMATTED')
  DO JOBS = 1,KDLEN
    DO JBODY=1,IMXBDY
      IF (JBODY>ICMBDY(JOBS)) CYCLE
      IBODY = ROBODY%MLNKH2B(JOBS)+(JBODY-1)
      WRITE(IU,'(6I8,2F30.14)') MYPROC, KSET, JOBS, NINT(ROBHDR%DATA(JOBS,ROBHDR%SEQNO_AT_HDR)),&
        & NINT(ROBODY%DATA(IBODY,ROBODY%VERTCO_REFERENCE_1_AT_BODY)), &
        & NINT(ROBODY%DATA(IBODY,ROBODY%VARNO_AT_BODY)), ZHOFX(JOBS,JBODY), ZXPPB(JOBS,JBODY)

    ENDDO
  ENDDO
  CLOSE(IU)
!$OMP END CRITICAL
ENDIF
 :
 :
```
The HOP_driver script (based a script provided by MF) sorts the contents of the hop_results0001 file for comparison with some results made available by ECMWF/MF:
```bash
 :
 :
#
# Check HOP_DRIVER results (available for gfotran and intel)
#
ln -s $HOPDIR/${HOPOBS}/results.$HOPCOMPILER .
cat hop_results* | sort -k1,1n -k2,2n -k3,3n -k5,5n -k6,6n > results.driver
echo
cmp -s results.$HOPCOMPILER results.driver
if [ $? -eq 0] ; then
  echo "RESULTS ARE STRICTLY IDENTICAL TO THE REFERENCE FOR HOPCOMPILER=$HOPCOMPILER :-)"
else
  echo Compare exactly against the results dumped from hop:
  echo "xxdiff results.$HOPCOMPILER results.driver &"
  diff results.$HOPCOMPILER results.driver
  exit 1
fi
 :
 :
```
On cca you will find useful output from HOP_DRIVER in cca:$TEMP/hm_home/rfexp/archive/HOPDRIVEROUT:
```bash
fort.4
NODE.001_01
hop_results0001
results.gfortran
results.driver
```

### The code
HOP_DRIVER is a short program written by Deborah Salmond (ECMWF) to test code changes made to the observation operator. The program [src/arpifs/programs/hop_driver.F90](https://hirlam.org/trac/browser/branches/refactor/harmonie/src/arpifs/programs/hop_driver.F90) is summarised here.

 * The program sets up the model geometry and observations:
```bash
 :
 :
CALL GEOMETRY_SET(YRGEOMETRY)
CALL MODEL_SET(YRMODEL)

CALL IFS_INIT('gc7a')

CALL SUINTDYN

CALL SUGEOMETRY(YRGEOMETRY)        !From GEOMETRY_SETUP

CALL SURIP(YRGEOMETRY%YRDIM)             !From MODEL_CREATE

! Set up Observations, Sets
CALL SUDIMO(YRGEOMETRY,NULOUT)     !From SU0YOMB
CALL SUOAF              !From SU0YOMB
CALL SUALOBS            !From SU0YOMB
CALL SURINC             !From SU0YOMB
CALL SETUP_TESTVAR      !From SU0YOMB
CALL SUOBS(YRGEOMETRY)              !From CNT1
CALL ECSET(-1,NOBTOT,0) !From OBSV
CALL SUPHEC(YRGEOMETRY,NULOUT)

! Setup varbc (from cnt1.F90) and read VARBC.cycle
CALL YVARBC%SETUP_TRAJ
 :
 :
```

 * HOP_DRIVER then loops over the number of observation sets (NSETOT) and reads a *GOM PLUS* for each observation set. HRETR and HOP are then called:
```bash
 :
 :
DO ISET=1,NSETOT
  IDLEN   = MLNSET(ISET)
  IMXBDY = MAX(MMXBDY(ISET),1)

  ALLOCATE(ZHOFX(IDLEN,IMXBDY))
  ZHOFX=RMDI

  ! READ GOM_PLUS FROM DUMP
  CALL GOM_PLUS_READ_DUMP(YGP5,ISET)

  IF(IDLEN /= YGP5%NDLEN) THEN
    CALL ABOR1('Sets are incompatible')
  ENDIF

  :
  :
  :

  CALL HRETR(YRGEOMETRY%YRDIMV,IDLEN,IMXBDY,ISET,1,YGP5,YVARBC)

  CALL HOP(YRGEOMETRY%YRDIMV,YGP5,YVARBC,IDLEN,IMXBDY,ISET,1,LDOOPS=.TRUE.,PHOFX=ZHOFX)

  !write(0,*)'ZHOFX',ZHOFX
  DEALLOCATE(ZHOFX)

  CALL GOM_PLUS_DESTROY(YGP5)

ENDDO

 :
 :
```
