```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/General?action=edit"
```


## General software requirements

This page outlines, in a general way, the software requirements for compiling HARMONIE on a non-ECMWF platform
### Download HARMONIE

To obtain the HARMONIE source, assuming the computer platform has a git client available, one may check out from the repository at the host hirlam.org:
```bash
git clone https://git.hirlam.org/Harmonie
cd Harmonie
git checkout release-43h2.beta.3 # For the latest tagged version
git checkout develop             # For the development branch
```

At ECMWF, the "checked-out" versions are available on ecgb:
```bash
ecgb:/home/ms/spsehlam/hlam/harmonie_release/git/tags
ecgb:/home/ms/spsehlam/hlam/harmonie_release/develop
```

### Compilers and standard software

The system requires the following standard unix/linux software 

 * A fortran compiler
 * A C compiler
 * flex & bison for lex & yacc
 * ksh and bash
 * perl
 * python

Read more about the tested compilers under [installation](../HarmonieSystemDocumentation/Installation.md).

### MPI and OpenMP

Harmonie supports parallelization through message passing or shared memory multiprocessing. 

 * mpi libraries such as mpich2, openmpi or similar.
 * OpenMP libraries

The system can be compiled without support for MPI, but not all parts of the system can be run without MPI. The forecast model should however work fine without MPI.

### BLAS and LAPACK libraries

You need [BLAS and LAPACK-lite](http://netlib.org/) libraries.

If they are already on your system, verify they have been made with the correct compiler, or rebuild them. Instructions on how to (re-)build BLAS and LAPACK follow below:
 * Download [BLAS](http://www.netlib.org/blas/index.html) and [LAPACK](http://www.netlib.org/lapack/index.html)
 * First build BLAS (untarring blas.tgz places it in the BLAS directory). Go to that directory, and edit make.inc to set the compiler and linker to **gfortran**. Then type 'make'.
 * Subsequenty, for LAPACK, after untarring lapack-lite-3.1.1.tgz, go to the lapack-lite-3.1.1 directory.
 * Copy make.inc.example to make.inc.
 * Edit make.inc to point to the proper compiler/loader (**gfortran**) and to put the variable PLAT to the empty string. Set TIMER to INT_ETIME.
 * Copy the blas.a library from the BLAS directory to the lapack-lite-3.1.1 directory, run ranlib on it, then type 'make'.
 * Then copy the libraries in **/usr/local/lib** with names libblas.a and liblapack.a, respectively, otherwise the default configuration will not find them. Run ranlib on them.

### NETCDF

 Netcdf is required for some routines. Make sure you have the development version installed on your system.

 http://www.unidata.ucar.edu/software/netcdf

### ecCodes

 ecCodes is used to access GRIB1/GRIB2

 https://confluence.ecmwf.int/display/ECC 

### GRIB, BUFR and auxiliary software

The old software for reading GRIB1 and BUFR is included in the HARMONIE system and comprises

 * bufr 000405
 * gribex 000370

In addition there are some extra support libraries.

 * dummies_006
 * rgb_001

[Makeup](../HarmonieSystemDocumentation/Build_with_makeup.md) build these libraries for you. 

### GMTED processing

 To process the GMTED tiff files gdal and python modules for gdal is required.

### Observation monitoring

 To be able to extract observation feedback information sqlite3 is required.

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


