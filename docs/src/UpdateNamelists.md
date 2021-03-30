```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/UpdateNamelists?action=edit"
```
# Update the namelist hashes

## Introduction

Each namelists is build from a perl dictionary of different settings, 
[harmonie_namelists.pm](https://hirlam.org/trac/browser/Harmonie/nam/harmonie_namelists.pm) as the deviation from the default setup.
One section takes care of the general file settings, one of the mpp options and the large ones of different configurations. The script 
[gen_namelists.pl](https://hirlam.org/trac/browser/Harmonie/nam/gen_namelists.pl) allows us to build new namelists adding the settings on top of each other.
In the following we describe how to add new namelists and include them in the suite.

## Create a new hash module

Let us assume we have some new 4DVAR namelists we would like to merge.
Create a directory, 4dvar, and put your new namelists in here. Run the script 
[Create_hashes.pl](https://hirlam.org/trac/browser/Harmonie/nam/Create_hashes.pl)

```bash
./Create_hashes.pl 4dvar
Create namelist hash for 4dvar 
Scan 4dvar/namscreen_dat_4d 
Scan 4dvar/namtraj_1_4d 
Scan 4dvar/namvar_dat_4d 
Create namelist hash 4dvar.pm 
Create updated empty namelist hash empty_4dvar.pm for 4dvar
```

We have now created a perl module for the new namelists. One with empty namelist entries, 4dvar_empty.pm, and one with all namelists in the right format, 4dvar.pm. To get one of your namelists back ( sorted ) you can write:
```bash
./gen_namlist.pl -n 4dvar_empty.pm -n 4dvar.pm namscreen_dat_4d
```

To get the module integrated in the system the module has to be merged with the conventions in harmonie_namelists.pm, but as a start the full namelists can be used. Copy the new empty*.pm to empty.pm to get the updated list of empty namelists.

## Create the new namelist

Add the new namelists to the script [Get_namelist](https://hirlam.org/trac/browser/Harmonie/scr/Get_namelist). In this case we would add a new case for 4dvar

```bash
4dvartraj) 
   NAMELIST_CONFIG="$DEFAULT minimization dynamics ${DYNAMICS} ${PHYSICS} ${PHYSICS}_minimization ${SURFACE} ${EXTRA_FORECAST_OPTIONS} varbc minim4d"
    ;;
```



[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


