```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Centos6Install?action=edit"
```
# Centos 6 instructions

# INFORMATION

**Please note: the version of gcc/gfortran available on CentOS/Redhat 6 platforms ((GCC) 4.4.7 !20120313 (Red Hat 4.4.7-16)) is not recent enough to compile harminie-40h1 code. gcc/gfortran, netCDF and HDF5 must be installed locally (from source).**

## Requirements
This is a *HOWTO* for building and running Harmonie on a CentOS 6 PC with GNU compilers. This should probably work on a Redhat 6 PCs too. harmonie-38h1 code was used to develop this documentation.

### 64-bit OS
Enter the following command in a terminal to check you actually have a 64-bit Linux PC:
```bash
uname  -m -i -p
```
This should return:
```bash
x86_64 x86_64 x86_64
```

### OS software
This list of required software is a guess at the moment. Your system may require the installation of other libraries. The following instructions require root access to your PC.
 * The compilers
```bash
yum install gcc.x86_64
yum install gcc-c++.x86_64
yum install gcc-gfortran.x86_64
yum install libgcc.x86_64
yum install openmpi.x86_64
yum install openmpi-devel.x86_64
```

 * Get yacc/bison
```bash
yum install byacc.x86_64 bison.x86_64 bison-devel.x86_64
```

 * Get BLAS/LAPACK
```bash
yum install blas.x86_64 blas-devel.x86_64
yum install lapack.x86_64 lapack-devel.x86_64
```

 * I installed NetCDF from the EPEL (Extra Packages for Enterprise Linux) repository. Here is how to enable access to this repository by your CentOS 6 PC:
```bash
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6*.rpm
ls -1 /etc/yum.repos.d/epel*
```
 now install netCDF
```bash
yum install netcdf.x86_64
yum install netcdf-devel.x86_64
yum install netcdf-static.x86_64
```

### Get the code

For the 38h1.2.beta.2 tag:
```bash
mkdir -p $HOME/harmonie_releases/tags
cd $HOME/harmonie_releases/tags
svn co https://svn.hirlam.org/tags/harmonie-38h1.2.beta.2
```

For trunk:
```bash
mkdir -p $HOME/harmonie_releases
cd $HOME/harmonie_releases
vn co https://svn.hirlam.org/trunk/harmonie 
ln -s harmonie trunk
```

## Compile Harmonie
Now let's create our first Harmonie experiment (METIE.LinuxPC setup is designed for standard CentOS 6 Linux PCs):
```bash
cd $HOME
mkdir -p hm_home/trunkexp
cd $HOME/hm_home/trunkexp
$HOME/harmonie_releases/trunk/config-sh/Harmonie setup -r $HOME/harmonie_releases/trunk -h METIE.LinuxPC
```

Local changes that may be required ... in the Env_system:
```bash
:
:
module load metlib/odbapi/0.9.31-gnu
:
:
# Climate data location
export HM_CLDATA=/home/ewhelan/harmonie_climate/38h1.1
export HM_SAT_CONST=/home/ewhelan/harmonie_sat_const
:
:
# Jb data location
export JBDIR=/opt/metdata/harmonie_jbdata
:
export SMSTASKMAX=4
```

Local changes that may be required ... in the Env_submit:
```bash
  $nprocy=2; # instead of 8 if you only have a dual-/quad-core PC
```

Now use the Harmonie system to build the software:
```bash
cd $HOME/hm_home/trunkexp
$HOME/harmonie_releases/trunk/config-sh/Harmonie Install
```
This uses the Harmonie MAKEUP utility to compile the code and create libraries and executables required. Further details on MAKEUP are available here: [wiki:HarmonieSystemDocumentation/Build_with_makeup](../HarmonieSystemDocumentation/Build_with_makeup.md)

## Run an experiment
Instructions for testbed and/or local experiment are detailed here:
 * Your first experiment will require changes to be made to the default settings in $HOME/hm_home/trunkexp/ecf/config_exp.h :
```bash
DOMAIN=IRELAND150       ## choose a small domain to run on your limited PC.
                        ## See $HOME/harmonie_releases/trunk/scr/Harmonie_domains.pm for existing definitions
VLEV=HIRLAM_60          ## I only have (easy access) to HIRLAM model level files on my PC 
ANASURF_INLINE="no"     ## I have experienced some issues with my setup calling SODA from inside CANARI
HOST_MODEL="hir"        ## tell boundary processing that you are using HIRLAM model boundary files
OBDIR=$HOME/scratch/obs ## tell Harmonie where your BUFR observation files are
BDDIR=$HOME/scratch/bnd ## tell Harmonie where your input boundary files are (HIRLAM or IFS files normally)
BDSTRATEGY=available    ## I use a more forgiving boundary file strategy
BDINT=3                 ## I only have (HIRLAM) boundary files every 3 hours
```

 * Once you think you have all your ducks in a row you can try to run your first experiment:
```bash
cd $HOME/hm_home/trunkexp
$HOME/harmonie_releases/trunk/config-sh/Harmonie start DTG=2014040100 DTGEND=2014040112 LL=03 BUILD=no
```

Further details on how to use the Harmonie mini-SMS script system are available here: [wiki:HarmonieSystemDocumentation/Harmonie-mSMS](../HarmonieSystemDocumentation/Harmonie-mSMS.md)
