```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ObservationPreprocessing/ObservationData?action=edit"
```
# Observation data
In off-line experiments the Prepare_ob script extracts observations from a data archive, e.g from MARS archive at ECMWF platform, or from existing observation files available locally.
# ECMWF
At ECMWF, the HARMONIE script [prepares the retrieval (retrin) file for MARS request. [source:Harmonie/scr/WriteMARSreq](https://hirlam.org/trac/browser/Harmonie/scr/WriteMARSreq]) is executed by [source:Harmonie/scr/Prepare_ob].
```bash
    WriteMARSreq -d $DATE -t $TIME -r $RANGE -o $OBSLIST -m ./retrin -z $BUFRFILE -g $GEOL
```
The variables above denote
  * DATE - analysis date
  * TIME - analysis time
  * RANGE - extraction time interval
  * OBSLIST - list of the observations to be extracted according to MARS definition; 
  * BUFRFILE - name of the extracted BUFR file
  * GEOL - Extraction of the model domain properties from the climate file as follows
```bash
  $BINDIR/domain_prop $CLIMDIR/m$MM -f -MAX_EXT > foo
     EASTEC=$( tail -1 foo | head -1 | sed 's/ //g' )
     NORTHEC=$( tail -2 foo | head -1 | sed 's/ //g' )
     WESTEC=$( tail -3 foo | head -1 | sed 's/ //g' )
     SOUTHEC=$( tail -4 foo | head -1 | sed 's/ //g' )
```


# LOCAL
Otherwise, this step consists of fetching (or waiting for) the observations stored in $OBDIR defined in ecf/config_exp.h . In that case one can use the command "cat" to merge different observations into one BUFR file, ob${DTG}. In general, HIRLAM services are adopting SAPP, ECMWF's scalable acquisition and pre-processing system, to process (conventional) GTS reports and other observational data for use in operational NWP. SAPP produces BUFR encoded in the same way as observational BUFR data available in the MARS archive.
 