```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Fast_start_on_cca?action=edit"
```

# Configure for faster setup on cca

## Background

Since ECMWF switched from the IBM based c2a to the new Cray XC30 cca setting up and start a new HARMONIE experiment has been a very slow process. With the current settings it may take several hours from the moment you say **Harmonie start** until the code is fully compiled and the real run starts. In the following we describe how to configure your experiment to get started in about half an hour.

## What's special with cca?

The main cause for the slow synchronization and compilation time on cca is the Lustre file system. Such a file system is optimized for large files but is less efficient for large numbers of small files. As a comparison it takes ~2 minutes to copy the full harmonie system from `ecgb:$HOME` to `$PERM` whereas it takes about 1 hour or more to make the same copy to `cca:$SCRATCH`. It's not the transfer to cca that takes time but the IO on the `$SCRATCH` file system.

## How to set it all up

The changes required can be viewed in [13814] and in below we go through what you have to do as a user. At the bottom of the page you'll find the versions adapted so far.

### Using the $PERM disk

Normally HARMONIE is setup to use `$SCRATCH` as the main disk for both `ecgb` and `cca`. Two changes are required in `Env_system` to use the `$PERM` disk on `cca`.

 * Set `HM_LIB=/hpc$PERM/build_harmonie/$EXP/lib ` for the `ecgb` part of `Env_system`
 * Set `HM_LIB=$PERM/build_harmonie/$EXP/lib` for the `cca` part of `Env_system`

This means that `ecgb:$HM_LIB == cca:$HM_LIB` so the synchronization between `ecgb` and `cca` is for free. Your working directories and results will still be found under `$SCRATCH/hm_home/$EXP`.

### Compiling with gmkpack

Harmonie comes with two way of compiling the code, [Makeup](../HarmonieSystemDocumentation/Build_with_makeup.md) and [Gmkpack](../HarmonieSystemDocumentation/Installation.md). Both methods have their benefits but in this particular case Gmkpack gives us the fastest throughput for two reasons.

 - We only compile the source you have changed for the rest we reuse the already built libraries. This is partly true for Makeup as well but in the search for what to actually compile takes longer time.
 - Less disk space and number of inodes is required compared to Makeup. We only copy the code to be compiled.

The above mentioned is only true if you make small changes for larger number of changes that requires recompilation of big parts of the code it may not necessary be true any longer. To compile with gmkpack set

 * `MAKEUP=no in Env_system`
 * Make sure `BUILD_ROOTPACK=no in ecf/config_exp.h  `. The already compiled libraries are listed below. If you have to compile the full code Makeup is faster.

The reproducibility between compilation with Makeup and gmkpack has not been checked yet although great care has been taken to use the same compilation options. To avoid unpleasant surprises you are not recommended to change compilation method between to experiments that you expect to compare.

### Things to keep an eye on

The disk space on `cca:$PERM` is limited not only for the disk space in GB but also for the number of files, the inodes. A typical experiment takes 2.5GB and uses 10000 inodes. Thus the number of experiments you can setup this ways is limited. To check your quota on `cca:$PERM` type

 ` quota -v `

on `cca`.

### What about existing experiments?

There is not a great need to change your setup if you have a running experiment. The costly part is the initial setup and compilation. If you still feel you would like to do it you are advised to remove everything from `cca:$SCRATCH/hm_home/$EXP` and `ecgb:$SCRATCH/hm_home/$EXP` after you have checked that the necessary restart files are available on ecfs. The other alternative is to start a new experiment with the same changes and make sure you start with initial conditions from your old experiment.

## Updated HARMONIE configurations

The changes will progressively be implemented in the used configurations as listed below. If you miss any configuration please contact us. Note that the default settings will not be changed for the tagged versions. Note that for the trunk or for branches a new ROOTPACK is required for every update in the `src` directory and that the new ROOTPACK may not always be available.

```bash

  harmonie-38h1

   tags:

   ~hlam/harmonie_release/tags/harmonie-38h1.1 ROOTPACK=/project/hirlam/harmonie/pack/38h1_main.01.gnu.x
   ~hlam/harmonie_release/tags/harmonie-38h1.2 ROOTPACK=/project/hirlam/harmonie/pack/38h1_main.02.gnu.x

   branches:

   ~hlam/harmonie_release/branches/harmonie-38h1 ROOTPACK=/scratch/ms/spsehlam/hlam/common_rootpack/38h1_branch_harmonie_38h1_13749.01.gnu.x
   ~hlam/harmonie_release/branches/harmonEPS-38h1.1 ROOTPACK=/project/harmonie/pack/38h1_harmonEPS_13706.01.gnu.x
                                                    ROOTPACK=/project/harmonie/pack/38h1_harmonEPS_13827.01.gnu.x

  harmonie-40h1

   tags:
   ~hlam/harmonie_release/tags/harmonie-40h1.1.beta.1 ROOTPACK=/project/hirlam/harmonie/pack/40h1_beta_1.01.gnu.x

   branches:

   ~hlam/harmonie_release/trunk ROOTPACK=/scratch/ms/spsehlam/hlam/common_rootpack/40h1_trunk_NNNNN.01.gnu.x


```
