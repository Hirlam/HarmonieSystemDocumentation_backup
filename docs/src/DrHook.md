```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/DrHook?action=edit"
```
# Profiling & traceback tool Dr.Hook

## Background

Dr.Hook (& the Medicine Head :-) was developed at ECMWF in 2003 to overcome
problems in catching runtime errors. Their IBM system at the time was quite
impotent to produce meaningful traceback upon crash. It was decided that something
need to be done urgently.

Dr.Hook gets its name from Fujitsu VPP's hook-functionality in their Fortran compiler, 
which enabled to call user functions upon enter and exit of a routine. Dr.Hook is of course
a former US rock-band from 70's, which probably did not survive to this millenium due to
heavy drug use!  

In about week or so late 2003 the first version of Dr.Hook saw daylight. It turned out
nearly immediately that we could try to gather information for profiling purposes, too,
like wall & CPU clock times, possibly MFlop/s and memory consumption information.

One drawback with Dr.Hook was that (initially just) Fortran code needed to be instrumented
by subroutine calls, which was a bother. However, for IFS code and automatique insertion 
script was developed greatly simplifiying the task.

## Activating Dr.Hook

Two things have to be in place in order to use Dr.Hook:

  1. Fortran (or C) codes must contain explicit Dr.Hook calls to enable instrumentation, starting from the main program
  1. Certain environment variable(s) need to be set

### An example of Fortran instrumentation

```bash
SUBROUTINE HOP(KDLEN,KDBDY,KSET,KHORIZ)
!**** *HOP* - Operator routine for all types of observations.
!     E. ANDERSSON            ECMWF          01/04/99
...
USE PARKIND1  ,ONLY : JPIM     ,JPRB
USE YOMHOOK   ,ONLY : LHOOK,   DR_HOOK
...
IMPLICIT NONE
...
REAL(KIND=JPRB) :: ZHOOK_HANDLE ! Stack variable i.e. do not use SAVE
...
! Before the very first statement
IF (LHOOK) CALL DR_HOOK('HOP',0,ZHOOK_HANDLE)
...
! Before any RETURN-clause
IF (LLcondition) THEN
  IF (LHOOK) CALL DR_HOOK('HOP',1,ZHOOK_HANDLE)
  RETURN
ENDIF
...
! Before the very last statement
IF (LHOOK) CALL DR_HOOK('HOP',1,ZHOOK_HANDLE)
END SUBROUTINE HOP

```

### Some environment variables

To activate Dr.Hook and to enable tracebacks upon failure:

```bash
#!sh
export DR_HOOK=1
```

This sets the Fortran-variable **LHOOK** to **.TRUE.**.

By default all usual Unix-signals are caught (like SIGFPE=8, SIGSEGV=11, etc.).
Occasionally, during development, some of them can be turned off, e.g. SIGFPE:

```bash
#!sh
export DR_HOOK_IGNORE_SIGNALS=8
```

To enable low-overhead wall clock time profiling, set also:

```bash
#!sh
export DR_HOOK_OPT=prof
```

Also recommended options are:

```bash
#!sh
export DR_HOOK_SHOW_PROCESS_OPTIONS=0
mkdir -p /some/path/hook
export DR_HOOK_PROFILE=/some/path/hook/drhook.prof.%d
```

The former one reduces Dr.Hook informative output upon initialization.
This can be messy as so many processors are printing the same, often useless,
output to the stderr.

The latter defines the profile files' location. The **%d** will be replaced with
MPL-task id (= MPI-task plus 1).

Sometimes it is necessary to turn Dr.Hook off and *also* make sure no signals are caught
by Dr.Hook -- as this the (unfortunate?) default due to function call to **C_DRHOOK_INIT_SIGNALS** in **arp/setup/sumpini.F**.
Now there is a new environment variable **DR_HOOK_INIT_SIGNALS** to prevent this. So, to make sure Dr.Hook does *not*
interfere your run *at all*, give:

```bash
#!sh
export DR_HOOK=0
export DR_HOOK_INIT_SIGNALS=0
```

### Timeline memory profiling

It is possible to activate timeline profiling to see jumps in memory usage.
Output is written to stdout. Controlling variables are:

```bash
#!sh
export DR_HOOK=1
export DR_HOOK_TIMELINE=1
#-- Optional:
export DR_HOOK_TIMELINE_FREQ=1 # the default = 1000000
export DR_HOOK_TIMELINE_MB=1 # th default jump 1 MByte
```

Upon each **DR_HOOK_TIMELINE_FREQ**-call to **DR_HOOK** this will check for one MByte (or **DR_HOOK_TIMELINE_MB**) jumps in
resident memory usage, and will print a line containing cumulutive wall clock time since start, resident memory size right now, high water mark so far, routine name (instrumented to Dr.Hook).
----

### Implicit MPL-library (and MPI) initialization

Be aware that the very first call to **DR_HOOK** also attempts to initialize MPL-library for you. Sometimes this is not desired
or causes some hard to understand failures, especially with programs where MPI is not involved, but Dr.Hook calls are present.
To turn this initialization off, set

```bash
#!sh
export DR_HOOK_NOT_MPI=1
```

For example, asyncronous I/O module **SAMIO** does that -- from within its Fortran. It calls *before first Dr.Hook call*
function

```bash
CALL C_DRHOOK_NOT_MPI()
```

Thus, this can be used elsewhere, too (like in **util/gl** tools):

```bash
PROGRAM SOME_UTILGL_TOOL
...
CALL C_DRHOOK_NOT_MPI()
!-- The following now does NOT initialize MPL nor MPI for you
IF (LHOOK) CALL DR_HOOK('SOME_UTILGL_TOOL',0,ZHOOK_HANDLE)
...
IF (LHOOK) CALL DR_HOOK('SOME_UTILGL_TOOL',1,ZHOOK_HANDLE)
```

----

## Overheads

The **DR_HOOK=1** has practically no overhead on a scalar machine.
Profiling with **DR_HOOK_OPT=prof** causes some 5% overhead.

On a vector machine overhead are so big that Dr.Hook should not be used there, unfortunately.