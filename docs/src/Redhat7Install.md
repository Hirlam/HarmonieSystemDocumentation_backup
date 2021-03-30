```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Redhat7Install?action=edit"
```
# Redhat 7 instructions
## Requirements
This is a *HOWTO* for building and running Harmonie on a Redhat 7 server with GNU compilers using Open MPI. This should probably work on a CentOS 7 PCs too.

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

 * Install subversion to permit easy download of the code:
```bash
yum install subversion.x86_64
```



 * To use the mXCdp GUI to monitor the HARMONIE mini-SMS system the perl-Tk library is required. At the time of writing I could not find a trustworthy perl-Tk rpm to install the software. Some system libraries may be required (this list may not be complete):
```bash
yum install perl-devel.x84_64 perl-Time-HiRes.x86_64
yum install gcc.x864_64
yum install libX11-devel.x86_64 libxcb-devel.x86_64 xorg-x11-proto-devel.noarch libXau-devel.x86_64
yum install libpng-devel.x86_64 zlib-devel.x86_64
```
... and here is how to install perl-Tk from source:
```bash
cd $HOME
wget http://search.cpan.org/CPAN/authors/id/S/SR/SREZIC/Tk-804.032.tar.gz
gunzip Tk-804.032.tar.gz
tar -xvf Tk-804.032.tar
cd Tk-804.032
perl Makefile.PL
make
make test
make install
```

 * The compilers
```bash
yum install gcc-gfortran.x86_64 libgfortran.x86_64 libquadmath.x86_64 libquadmath-devel.x86_64
```

 * ksh for the makeup:
```bash
yum install ksh
```

 * Get yacc/bison
```bash
yum install flex.x86_64
yum install bison.x86_64 byacc.x86_64
```

 * Get Open MPI:
```bash
yum install environment-modules.x86_64 infinipath-psm.x86_64 libesmtp.x86_64 opensm-libs.x86_64libibumad.x86_64 tcl.x86_64
yum install openmpi.x86_64 openmpi-devel.x86_64
```

 * Enable access to EPEL software:
```bash
wget https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum install epel-release-7-5.noarch.rpm
```

 * Get BLAS/LAPACK (the requirement to create soft-links for BLAS and LAPACK may be corrected in EPEL at some stage).
```bash
yum install blas.x86_64 blas-devel.x86_64
yum install lapack.x86_64 lapack-devel.x86_64
cd /usr/lib64
ln -s liblapack.so.3 liblapack.so
ln -s libblas.so.3 libblas.so
```

 * I also installed NetCDF and HDF5 from the EPEL:
```bash
yum install netcdf.x86_64 netcdf-cxx.x86_64 netcdf-cxx-devel.x86_64 netcdf-cxx-static.x86_64 netcdf-devel.x86_64 netcdf-fortran.x86_64 netcdf-fortran-devel.x86_64 netcdf-static.x86_64 hdf5.x86_64 hdf5-devel.x86_64 libcurl-devel.x86_64
```

### Get the code


For trunk:
```bash
mkdir -p $HOME/harmonie_releases
cd $HOME/harmonie_releases
svn co https://svn.hirlam.org/trunk/harmonie 
ln -s harmonie trunk
```

## Compile Harmonie
Now let's create our first Harmonie experiment (METIE.LinuxPC setup is designed for standard CentOS 6 Linux PCs):
```bash
cd $HOME
mkdir -p hm_home/trunkexp
cd $HOME/hm_home/trunkexp
$HOME/harmonie_releases/trunk/config-sh/Harmonie setup -r $HOME/harmonie_releases/trunk -h METIE.LinuxRH7gnu
```

Local changes that may be required ... in the Env_system:
```bash
:
:
:
# Climate data location
export HM_CLDATA=/data/nwp/harmonie_climate/40h1
export HM_SAT_CONST=/data/nwp/harmonie_sat_const
:
:
# Jb data location
export JBDIR=/data/nwp/harmonie_jbdata
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
