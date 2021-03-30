```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Evaluation/Mitraillette?action=edit"
```
# Mitraillette - the ALADIN dynamical core testbed

Mitraillette is a script designed to validate ALADIN configurations and is particularly useful to test a new cycle. This script uses a chain of jobs: when a job is finished it launches the following job, in a predetermined order. There are several documents describing the system on the 
[gmapdoc site](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=mitraillette)

The latest version of mitraillette can be found on:

```bash
https://svn.hirlam.org/trunk/contrib/mitraille
```
or
```bash
beaufix:/home/gmap/mrpm/yessadk/SAVE/mitraille
```

Due to current access limitations to tori, this version will not necessarily be up to date. It is, however, possible to check out the svn version from lxgmap workstations:

```bash
svn co https://svn.hirlam.org/trunk/contrib/mitraille
```

Before your start using mitraillette please read the general instructions in [here](http://www.cnrm.meteo.fr/gmapdoc/meshtml/mitraillette.html)

## Configure the system for your host.

Under protojobs you find subdirectories for different hosts. Currently there are definitions for yuki and c1a. In each host directory there are four files.

```bash
config           # Configuration of main directories and local environment variables
jobtrailer       # End of job specification
memtable         # Definition of memory requirements for different configurations
monoheader       # Header for a 1 PE job on the local batch system
multiheader      # Header for a N PE job on the local batch system
timetable        # Definition of wall time requirements for different configurations
```

The main change is that the headers and trailers in the job*-files are separated. And that mitraillette.x has been updated to build the chain-files using these files. The config file is source in the beginning of the main script mitraillette.x.


The tori config file looks like

```bash

#
# Mitraillette configuration file for tori
#

# Where to find prototype jobs and namelists
REFDIR=/cnrm/gp/mrpm/mrpm624/mitraille

# where the prototype job_* files are
REF_JOBSDIR=$REFDIR/protojobs
# where the namelists are
REF_NAMDIR=$REFDIR/namelist


# Where to store the output files
WORKDIR=/work/$USER

# Where to put your modified job* files, i.e. the chain-files
# MITRA_HOME is defined in mitraiellette.x as your pwd
JOB_LOC=$MITRA_HOME
TMP_LOC=$TMP_LOC

# Location of input data
FILE_PATH=/cnrm/gp/mrpm/mrpm603/anal_a_mitraille

# Definition of cp/ecp for files and namelists
CP="/bin/cp -b 32768"
ECP="/bin/cp -b 32768"

# Batch and MPI launch definitions
SUBMIT=/usr/bin/nqsII/qsub
MPILAUNCH="mpirun -nn 1 -nnp nb_proc"
LOPT_SCALAR=F
MBX_SIZE=0

# NEC specific envifonment variables
export F_UFMTENDIAN=31
export F_SYSLEN=1000
export F_FMTBUF=131072
export F_PROGINF=DETAIL
export F_FTRACE=FMT2
export F_RECLUNIT=BYTE
export MPIPROGINF=ALL_DETAIL
export MPISEPSELECT=0
export MPISUSPEND=ON
export MPIEXPORT="MPISUSPEND,F_FTRACE,F_FMTBUF,F_RECLUNIT,MPIPROGINF,PATH,DR_HOOK,DR_HOOK_IGNORE_SIGNALS"

```

Modify to fit your needs or add your own host with the current definitions as a template.


**NPROMA**


None of the NPROMA settings are changed in the namelists. The current values are suitable for tori (NEC vector) but probably not for other machines. There is a small script, mitraille/util/Parse_nproma.pl, that changes all different values to one in the namelists.

## c2a instructions based on cy40
The following instructions will instruct the user on how to build the code to be evaluated by mitraillette using the Harmonie build system and how to use mitraillette.

### Build executables
On ecgb get the phasing code
```bash
cd
mkdir -p harmonie_release/branches/phasing
cd harmonie_release/branches/phasing
svn co https://svn.hirlam.org/branches/phasing/cy40
```

On ecgb build cy40
```bash
cd
cd hm_home
mkdir cy40_main_makeup_c2a
cd cy40_main_makeup_c2a
~hlam/Harmonie setup -r $HOME/harmonie_release/branches/phasing/cy40
vi Env_system # set PRECOMPILED= to empty in Env_system - this ensures you will compile a nice fresh clean build
~hlam/Harmonie install
```

### Run mitraillette
On ecgb get mitraillette code and copy to c2a:
```bash
cd
mkdir mitraille_releases
cd mitraille_releases
svn co https://svn.hirlam.org/trunk/contrib/mitraille
rsync -tvaz --exclude=.svn mitraille /cca/perm/ms/ie/dui # please insert correct PATH to your PERM directory
```
The next few instructions are a bit messy - I am waiting for access to MF mitraille before I update trunk/contrib/mitraille properly. In the meantime ...Make a copy of the Harmonie executables in $PERM on c2a:
```bash
mkdir -p $PERM/HarmBin/cy40ald/
cp $TEMP/hm_home/cy40_main_makeup_c2a/bin/MASTERODB $PERM/HarmBin/cy40ald/
cp $TEMP/hm_home/cy40_main_makeup_c2a/bin/PGD $PERM/HarmBin/cy40ald/
```
Log in to c2a and configure and run your mitraillette evaluation as follows:
```bash
cd $PERM/mitraille
./mitraillette_v012014.x AL40T1 PRO_FILE.al40t1_hirlam_mono mono
./test.xNNNN
```
This PRO_FILE points to  /perm/ms/ie/dui/HarmBin/cy40ald/MASTERODB copied above. The mitraillette.x script will have created a test script called test.xNNNN where NNNN is an integer. Let's run the test script:
```bash
./test.xNNNN
```
Now have a look at the output produced. Still on c2a:
```bash
cd $TEMP/mitraillette/al40t1/mitraillette_NNNN
ls -ltr
cd $TEMP/OUTPUT_FILES/AL40T1
ls -ltr
```

### MORE TO FOLLOW
**Please note: I have yet to merge the cycle 40 mitraillette updates into trunk/contrib. I want to get these updates from MF myself**
I have to see if my tests have succeeded! 

## Quick start on c1a

 * Check out the script and put i under $HOME/mitraille on c1a. 
 * Modify PRO_FILE.al37.c1a to point to your binary
 * Create directory al37
 * Create a multi job chain by
```bash
./mitraillette.x AL37 PRO_FILE.al37.c1a multi 
```
 * Run the created test.xNNNN script
 * Results can be found under $TEMP

**Utilities**

A set of exmple scripts used to compare different runs are gathered under util. Read more in the util/README. Please fill with your own tools!

----

Last modified [[LastModified]]