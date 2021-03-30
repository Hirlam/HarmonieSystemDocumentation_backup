```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/HarmonieBenchMark?action=edit"
```

# Harmonie RAPS benchmark

## Background

This page describes the current situation for harmonie as a benchmarking tool. During 2013 several HIRLAM countries will start the procurement for new computers. We hope that by coordinating the efforts we can make a win-win situation for all concerned parties, both vendors and institutes. The benchmarkers on the vendors' side will be able to concentrate their efforts on a single source code base for better productivity and enhanced feedback to the community. Moreover, we believe that the efforts with a common benchmark package will improve the model and might be found useful also in other Harmonie institutes. For the current effort cy38h1 have been chosen as the baseline version. The cycle is currently under preparation and evaluation within the ALADIN/HIRLAM community.

## Getting the package

The package is under preparation and is based on [harmonie-38h1.alpha.2](https://hirlam.org/trac/browser/tags/harmonie-38h1.alpha.2) plus [11688] and [11708].

The second, version is available here: [https://hirlam.org/portal/download/benchmark/src/HMbench_cy38a2_export.tar.gz].

Input data and some simple scripts can also be found on hirlam.org [https://hirlam.org/portal/download/benchmark/data/cy38].

## Organization of the package

## Input files

Please note that it is crucial to have right namelist settings to enable reproducibility. A set of input files including feasible namelists for different problem sizes is provided to ease up the startup for testing. The problem sizes are sorted according to the international clothing sizes as follows:     

```bash
 XS)
   # 50x50x65, 2.5km resolution
   BDDIR=XS
   MBX_SIZE=20000000
   TSTEP=60

  M)
   #  384x400x65, 2.5km resolution
   BDDIR=M
   MBX_SIZE=200000000
   TSTEP=60

  L)
   #  Nlon,Nlat,Nlev :         750         960          65, 2.5km resolution
   BDDIR=L
   BDINTERVAL=10800.
   TSTEP=60

  XL)
   #  Nlon,Nlat,Nlev :1200        1200          65, 2.5km resolution
   BDDIR=XL
   MBX_SIZE=200000000
   TSTEP=60

  XXL)
   # 1600x1600x65, 2.5km resolution
   BDDIR=XXL
   MBX_SIZE=2000000000
   TSTEP=60
```

You will also need the files [covers.tar](https://hirlam.org/portal/download/benchmark/data/cy38/covers.tar) and [rrtm_const.tar](https://hirlam.org/portal/download/benchmark/data/cy38/rrtm_const.tar).

## Status

 * The model is not reproducible for different NPROCX/NRPOCY with the default HARMONIE edmfm scheme. Until solved reproducibility can be achieved by removing from `&NAMPARAR`:

```bash
   CMF_CLOUD='STAT',
   CMF_UPDRAFT='DUAL',
   LMIXUV=.TRUE.,
```


    * This makes the the code reproducible on c2a(IBMP7) with the default compilation flags. UPDATE: also with multiple OpenMP threads. 
    * Not reproducible on Intel Sandy Bridge (ifort 12.0.5.220 ) with -O2 -fp-model precise but with -O0. OpenMP not reproducible even with -O0.

 * OpenMP works technically (on Intel Sandy Bridge, ifort 12.0.5.220) but we don't get reproducible results when changing the number of openmp threads.
 * OpenMP now also tested with ifort 13.0.1 on Sandy Bridge (not using -xAVX flag). Still reproducibility cannot be achieved with any combination of (the many!) compiler flags and environment variable settings tested.
   * If linked without MKL libraries reproducibility is retained.

 * Gfortran 4.6.3 on an Ubuntu 12.04 workstation, domain XS, gives full reproducibility against variations in NPROCX, NPROCY and OMP_NUM_THREADS.

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
