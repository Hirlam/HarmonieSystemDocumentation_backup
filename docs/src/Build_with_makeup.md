```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Build_with_makeup?action=edit"
```


# Building with MAKEUP

## Background

Makeup is an alternative mechanism to build the HARMONIE system Instead of using GMKPACK to build the libraries and binaries, standard GNU make (gmake) procedures are used, making build of executables an easier task. Also parallel make comes for free, thus enhanced turn-around time for build process. Furthermore, rebuilds and change of compiler flags -- either per project and/or per source files basis -- are now trivial to do.

## MAKEUP very quickly

The process of using the MAKEUP system in stand-alone fashion is described next.

Lets define two helper variables for the presentation purposes:

The variable **$HARMONIE_SRC** refers to the directory, where the AROME source code is situated. Another variable **$HARMONIE_MAKEUP** refers to the directory, where build configuration files and MAKEUP's scripts are located. 


```bash
#!sh
# In ksh/bash
export HARMONIE_SRC=/some/path/harmonie/src
export HARMONIE_MAKEUP=/some/path/harmonie/util/makeup
# In csh/tcsh
setenv HARMONIE_SRC /some/path/harmonie/src
setenv HARMONIE_MAKEUP /some/path/harmonie/util/makeup
```

Usually **$HARMONIE_MAKEUP** is **$HARMONIE_SRC/../util/makeup** , but it doesn't have to be (e.g. in FMI's production system the $HARMONIE_MAKEUP is situated on a separate disk than the source code $HARMONIE_SRC) -- and MAKEUP can handle this now.

The process of building HARMONIE executable contains just a few steps:

 1. Goto directory $HARMONIE_MAKEUP and create/edit your configuration file (config.*). Beware of preferred naming convention:
```bash
config.<MET-INSTITUTE>.<MACHINE-PLATFORM>.<COMPILER-NAME>.<FUNDAMENTAL-OPTIONS>.<OPTIONAL-OPTIONS>
```
 1. Run MAKEUP's configure script under $HARMONIE_SRC (for example):
```bash
#!sh
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
```
 1. If applicable, adjust environment settings before launching of make. e.g., on some platforms, one needs to remember loading adequate modules, such as for DMI Cray XT5,
```bash
  module swap PrgEnv-pgi PrgEnv-pathscale  # if pathscale is to be used
  module swap xt-mpt xt-mpt/3.5.0
  module swap xt-asyncpe/3.8 xt-asyncpe/3.4
```
 1. Goto $HARMONIE_SRC directory and type make (or gmake, if make is non-GNU make). Redirect output to a file & terminal:
```bash
#!sh
cd $HARMONIE_SRC
gmake 2>&1 |  tee logfile  # ksh/bash
gmake      |& tee logfile  # csh/tcsh
```


## Using MAKEUP to build auxlibs (bufr, gribex, rgb)

You can now build EMOS- and related libraries by using the MAKEUP. All you need to know is what is your `sources.`<arch> that you would use to build this stuff anyway. Pass that generic name to the MAKEUP's configure through -E option and you're in business. An example for FMI's Cray:

```bash
#!sh
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure -E sources.crayxt $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
gmake
```

This will create extra libs (so called ´´MY_SYSLIBS´´) `libbufr.a`, `libgribex.a` and `librgb.a` and they will end up being linked into your executables, like MASTERODB.

## Using MAKEUP to build also util/gl -tools

HARMONIE utility package GL as located in util/gl directory can also be built as part of MAKEUP process,
if option -G is also given to the configure:

```bash
#!sh
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure -G $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
gmake
```

## Using MAKEUP to build also Oulan and/or Monitor -tools

HARMONIE utility package MONITOR and obs-preprocessor OULAN can also be build with MAKEUP. If you add option -B , then you will get Oulan and Monitor executables built, too. Or you can be more selective and oopt only for oulan with -b oulan, or just monitor -b monitor :
```bash
#!sh
cd $HARMONIE_SRC
# Request for building both oulan & monitor, too
$HARMONIE_MAKEUP/configure -B $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
# .. or add oulan only :
$HARMONIE_MAKEUP/configure -b oulan $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
# .. or add monitor only :
$HARMONIE_MAKEUP/configure -b monitor $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
gmake
```

## Building objects away from `$HARMONIE_SRC`-directory

If you do not want to pollute your source directories with objects and thus making it hard to recognize
which files are under version handling system SVN and which ain't (... although SVN command `svn -q st` would tell ...),
then use -P option. This will redirect compilations away from source code, under `$HARMONIE_SRC/../makeup.ZZZ`, where
`ZZZ` is the suffix of your config-file, e.g. `FMI.cray_xt5m.pathscale.mpi+openmp`.

The operation sequence is as follows:

```bash
#!sh
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure [options] -P $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
cd $HARMONIE_SRC/../makeup.FMI.cray_xt5m.pathscale.mpi+openmp/src
gmake
```

The drawback with this approach is that whenever there is an update in the master source directories,
you need to run lengthy `configure` in order to rsync the working directory up to date.
We may need to introduce a separate command for this to avoid full rerun of `configure`.

You can also use lowercase -p option with argument pointing to a directory-root, where to compile:

```bash
#!sh
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure [options] -p /working/path $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
cd /working/path/src
gmake
```

Now, it is important to understand that this `/working/path` has no connection to version handling i.e. if you change something 
in your master copy (say : issue a `svn up`-command), then your working directory remains unaltered. To synchronize it, do the following:

```bash
#!sh
cd /working/path/src
gmake rsync
```


## More details

### Re-running configure

Afterwards you can rerun configure as many times as you wish.  Please note that the very first time is always slowed (maybe 10 minutes) as interface blocks for arp/ and ald/ projects are generated.

Usually running configure many times is not necessary -- not even when you have changed your config-file (!) -- except when interface blocks needs to be updated/re-created (-c or -g options). For example, when subroutine/function call argument list has changed.
Then the whole config+build sequence can be run under $HARMONIE_SRC as follows:
```bash
#!sh
cd $HARMONIE_SRC
# -c option: Check if *some* interface blocks need regeneration and regenerate
$HARMONIE_MAKEUP/configure -c $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
# -g option: Force to regenerate interface blocks 
# $HARMONIE_MAKEUP/configure -g $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
gmake
```

### Changing the number of tasks for compilation

The number of tasks used for gmake-compilations is set by default to 8. See NPES parameter in $HARMONIE_MAKEUP/defaults.mk
To change the default, you can have two choices:

 1. Add NPES to your config-file, for example set it to 2:
```bash
#!sh
NPES=2
```
 1. Invoke gmake with NPES parameter, e.g. set it to 10:
```bash
#!sh
gmake NPES=10
```

### Inserting DRHOOK for Meso-projects

To insert `DrHook` profiling automatically for mpa/ and mse/ projects, reconfigure with -H option:
```bash
#!sh
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure -H $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
```

You can also pick and choose either mpa/ or mse/ projects with -h option (can be supplied several times):

```bash
#!sh
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure -h mpa $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
$HARMONIE_MAKEUP/configure -h mse $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
# The following are the same as if the option -H was used
$HARMONIE_MAKEUP/configure -h mpa -h mse -h surfex $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
$HARMONIE_MAKEUP/configure -h mpa:mse:surfex $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
```

In the future it may not be necessary to insert `DrHook` automagically, if the insertion has been 
done in the `svn` (version handling) level.

### Speeding up compilations by use of RAM-disk

To further speedup compilation and if you have several GBytes of Linux RAM-disk (/dev/shm) available, do the following:

 1. Create your personal RAM-disk subdirectory and check available disk space
```bash
#!sh
mkdir /dev/shm/$USER
df -kh /dev/shm/$USER
```
 1. Reconfigure with RAM-disk either by defining LIBDISK in your config-file or running
```bash
cd $HARMONIE_SRC
$HARMONIE_MAKEUP/configure -L /dev/shm/$USER $HARMONIE_MAKEUP/config.FMI.cray_xt5m.pathscale.mpi+openmp
```
 1. Also define TMPDIR to point to /dev/shm/$USER to allow compiler specific temporary files on RAM-disk
```bash
#!sh
# In ksh/bash-shells:
export TMPDIR=/dev/shm/$USER
gmake 2>&1 |  tee logfile
# In csh/tcsh-shells:
setenv TMPDIR /dev/shm/$USER
gmake      |& tee logfile
```

Please note that the step-2 creates all libraries AND executablus under the directory pointed by the -L argument. Object files and modules still, however, are placed under corresponding source directories.

### What if you run out of RAM-disk space ?

Sometimes you may find that the disk space becomes limited in /dev/shm/$USER. Then you have an option to supply LIBDISK parameter directly to gmake-command without need to reconfigure:

```bash
#!sh
gmake LIBDISK=`pwd`
```

This usually increases the throughput time as creation of the AROME executable to disk rather than RAM-disk may be 5-10 times slower.
But at least you won't run out of disk space.

----
## How is ODB related stuff handled ?

The `Observational DataBase` (ODB) is a complicated beast for good reasons. Unlike any other project, which produce just one library per project, correct use of ODB in variational data assimilation requires several libraries.

The trick to manage this with MAKEUP is to create a bunch of symbolic links pointing to $HARMONIE_SRC/odb/ -project directory. There will be one (additional) library for each link. And then we choose carefully the correct subdirectories and source codes therein to be compiled for each library.

### Specific ODB-libraries, their meaning & the source files included


| **Library**   | **Description**                                 | **Source files**                   |
| --- | --- | --- |
| libodb          | ODB core library                                  | lib/ & aux/ : [a-z]*.F90 [a-z]*.c    |
|                 |                                                           | module/ & pandor/module : *.F90      |
| libodbport      | Interface between IFS (ARPEGE/ALADIN/AROME) & ODB | cma2odb/ & bufr2odb/ : *.F90         |
|                 | -- also contains BUFR2ODB routines                        | pandor/extrtovs & pandor/fcq & pandor/mandalay : *.F90 |
| libodbdummy     | ODB-related dummies                                       | lib/   : [A-Z]*.F90 [A-Z]*.c         |
| libodbmain      | ODB tools, main programs (C & Fortran)                    | tools/ : [A-Z]*.F90 *.c *.F          |
| libPREODB       | ERA40 database (not needed, but good for debugging)       | ddl.PREODB/*.sql  , ddl.PREODB/*.ddl |
| libCCMA         | Compressed Central Memory Array database (minimization)   | ddl.CCMA/*.sql    , ddl.CCMA/*.ddl   |
| libECMA         | Extended Central Memory Array database (obs. screening)   | ddl.ECMA/*.sql    , ddl.ECMA/*.ddl   |
| libECMASCR      | Carbon copy of ECMA for obs. load balancing between PEs | ddl.ECMASCR/*.sql , ddl.ECMASCR/*.ddl|


From the file $HARMONIE_MAKEUP/configure you can also find how different files are nearly hand-picked for particular libraries. Search for block

```bash
#!sh
 if [[ "$d" = @(odb|odbport|odbdummy|odbmain)]] ; then
     case "$d" in
              odb) case "$i" in
                   lib|aux)              files=$(\ls -C1 [a-z]*.F90 [a-z]*.c 2>/dev/null) ;;
                   module|pandor/module) files=$(\ls -C1 *.F90 2>/dev/null) ;;
                   esac ;;
          odbport) case "$i" in
                   cma2odb|bufr2odb)                           files=$(\ls -C1 *.F90 2>/dev/null) ;;
                   pandor/extrtovs|pandor/fcq|pandor/mandalay) files=$(\ls -C1 *.F90 2>/dev/null) ;;
                   esac ;;
         odbdummy) [[ "$i" != "lib"]] || files=$(\ls -C1 [A-Z]*.F90 [A-Z]*.c 2>/dev/null) ;;
          odbmain) [[ "$i" != "tools"]] || files=$(\ls -C1 [A-Z]*.F90 *.c *.F 2>/dev/null) ;;
     esac
 elif [[ "$d" = @($case_odbs)]] ; then
   [[ "$i" != "ddl.$d"]] || {
       files=$(\ls -C1 *.ddl *.sql 2>/dev/null)
       mkdepend=$CMDROOT/sfmakedepend_ODB
   }
 else
  ... 
```

### Handling SQL-query and data layout files

For SQL-query compilations (ODB/SQL queries are translated into C-code for greater performance),
`odb98.x` SQL-compiler executable is also built as a first thing in the MAKEUP process.

Queries and data definition layouts (DDL-files) are always under <database>/ddl.<database>/ directory.

----


## Miscellaneous stuff

### Selective compilation

It is very easy to deviate from the generic compilation options for certain source files or even projects.
If you want to change compiler option (say) from **-O3** to **-O2** for routine `src/arp/pp_obs/pppmer.F90`, you can add the following
lines at the end of your config-file:

```bash
pppmer.o: FCFLAGS := $(subst -O3,-O2,$(FCFLAGS))
```

If you want to apply this to all `pppmer*.F90`-routines, then you need to enter the following "wildcard"-sequence:

```bash
pppme%.o: FCFLAGS := $(subst -O3,-O2,$(FCFLAGS))
```

Note by the way that for some reason we need to use `pppme%.o` as the more natural (from Unix) `pppmer%.o` would choose only
routines `pppmertl.F90` and `pppmerad.F90`, not the routine `pppmer.F90` at all!

Applying different compiler flags for project (say) **arp** only, then one can put the following at the end of config-file:

```bash
ifeq ($(PROJ),arp)
%.o:  FCFLAGS := $(subst -O3,-O2,$(FCFLAGS))
endif
```


### (Re-)building just one project

Sometime you could opt for rebuilding only (say) the **xrd**-project i.e. **libxrd.a**. This can be done as follows:

```bash
#!sh
gmake PROJ=xrd
```


### Cleaning up files

You can clean up by

```bash
#!sh
gmake clean
```

... or selectively just the project **arp**:

```bash
#!sh
gmake PROJ=arp clean
```

This clean does *not* wipe out makefiles i.e. you don't have to rerun configure
after this.

### Restoring and cleaning up the state of `$HARMONIE_SRC`

The following command you can run only once before issuing another configure command.
It will remove all related object and executable files as well as generated makefiles, logfiles etc. stuff which
was generated by MAKEUP's configure :

```bash
#!sh
cd $HARMONIE_SRC
gmake veryclean

# .. or alternatively :
$HARMONIE_MAKEUP/unconfigure
```

### Ignoring errors

Sometimes it is useful to enforce compilations even if one or more routines fail to compile.
In such cases recommended syntax is:

```bash
#!sh
gmake -i

# or not to mess up the output, use just one process for compilations

gmake NPES=1 -i
```


### Creating precompiled installation

If you want to provide precompiled libraries, objects, source code to other users
so that they do not have to start compilation from scratch, then make a distribution
or precompiled installation as follows:

```bash
#!sh
gmake PRECOMPILED=/a/precompiled/rootdir precompiled
```

After this the stuff you just compiled ends up in directory `/a/precompiled/rootdir` with
two subdirectories : `src/` and `util/`. All executables are currently removed.

You can repeat this call, and it will just `rsync` the modified bits.

### Update/check your interface blocks outside `configure`

The `configure` has options -c or -g to check up or enforce for (re-)creation of interface blocks of
projects `arp` and `ald`. To avoid full and lengthy `configure`-run, you can just do the following:

```bash
#!sh
gmake intfb
```

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----



