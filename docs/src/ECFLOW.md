```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ECFLOW?action=edit"
```


## Running Harmonie under ecFlow

## Introduction

This document describes how to run Harmonie under ecFlow scheduler at ECMWF. ecFlow is the ECMWF workflow manager and it has been written using python to improve maintainability, allow easier modification and introduce object orientated features as compared to the old scheduler SMS. ecFlow can be used in any HARMONIE version in and above harmonie-40h1.1.beta.1.

### Start your experiment supervised by ecFlow
 
Launch the experiment in the usual manner by giving start time, DTG, end time, DTGEND and other optional arguments

```bash
      ~hlam/Harmonie start DTG=YYYYMMDDHH
```

If successful, ecFlow will identify your experiment name and start building your binaries and run your forecast. If not, you need to examine the ecFlow log file `$HM_DATA/ECF.log`. `$HM_DATA` is defined in your `Env_system` file. At ECMWF `$HM_DATA=$SCRATCH/hm_home/$EXP` where `$EXP` is your experiment name.

The ecflow viewer stars automatically. To view any suite for your server or other servers, the server must be added to ecflowview Edit/Preferences/Servers and selected in Servers. See below on how to find the port and server name.

 * More than one experiment is not allowed with the same name monitored in the same server so Harmonie will start the server and delete previous non-active suite for you.
 * For deleting a suite manually using ecflow_client --port XXXX --host XXXX --delete force yes /suite or using the GUI Collector node+CTRL+click1 selecting ###ecflow_client --delete force yes <full_name>
 * If other manual intervention in server or client is needed you can use ecflow commands [https://software.ecmwf.int/wiki/display/ECFLOW/Home].

At ECMWF there are two server options `ECF_HOST=ecgate` or `ECF_HOST=ecgb-vecf` where the latter available since release-43h2.beta.5. Set `ECF_HOST` in `Env_system` to choose between the servers.

## ecFlow control

### Finding the port and host of the ecFlow server

Information about server variables can be found by running

```bash
      ecflow_server status 
```

At ECMWF you can also find `ECF_PORT`/`ECF_HOST` by checking the files under `/hpc/perm/ms/$GROUP/$USER/HARMONIE`, like 

```bash
hlam@ecgb11:~/hm_home/43_aug> ls -rlt /hpc/perm/ms/spsehlam/hlam/HARMONIE/*.ecf.*
-rw-r-----. 1 hlam hirald     10443 Aug  8 13:11 /hpc/perm/ms/spsehlam/hlam/HARMONIE/ecgb-vecf.4531.ecf.log
-rw-r-----. 1 hlam hirald      8804 Aug  8 13:12 /hpc/perm/ms/spsehlam/hlam/HARMONIE/ecgate.4531.ecf.log
```

### Check the status of your server

To check the status of your server you can use

```bash
ecflow_client --stats  --port ECF_POST  --host ECF_HOST
```

or

```bash
ecflow_client --port ECF_PORT  --host ECF_HOST  --ping
```

### Open the viewer of a running ecFlow server

If you know that your ecFlow server is running but you have no viewer attached to it you can restart the viewer:

```bash
ecflow_ui &
```

### Stop your ecFlow server

If you are sure you're running the server on the login node of your machine you can simply run

```bash
ecflow_stop.sh
```

A more complete and robust way is

```bash
export ECF_PORT=<your port>
export ECF_HOST=<your server name>
ecflow_client  --halt=yes
ecflow_client  --check_pt
ecflow_client  --terminate=yes
```


### Restart your ecFlow server

 If the server is not running you can start again using the script

```bash
 ecflow_start.sh -d /hpc/perm/ms/$GROUP/$USER/HARMONIE/
```

 Again, if ecFlow is running on a different machine you have to login and start it on that machine. For the virtual server `ecgb-vecf` you would do

```bash
 ssh ecgb-vecf
 module load ecflow
 ecflow_start.sh -d /hpc/perm/ms/$GROUP/$USER/HARMONIE/
```

As an alternative you can let Harmonie start the server for you when starting your next experiment.

### Keep your ecFlow server alive

The ecFlow server running on ecgate will eventually die causing an unexpected disruption in you experiments. To prevent this you can add a cron job restarting the server e.g. every fifth minute.

```bash
> crontab -l
*/5 * * * * /home/ms/$GROUP/$USER/bin/cronrun.sh ecflow_start.sh -d /hpc/perm/ms/$GROUP/$USER/HARMONIE > ~/ecflow_start.out 2>&1
```

where to small script `cronrun.sh` make sure you get the right environment

```bash
#!/bin/bash
source ~/.bash_profile
module unload ecflow
module load ecflow/4.12.0
$@
```

The ecFlow server version may change over time.

### Add another user to your ecflowviewer

Sometimes it's handy to be able to follow, and control, your colleagues experiments. To be able to do this do the following steps:

 - Find the port number of your colleague as described above.
 - In the ecflowviewer choose edit->preferences->servers and fill in the appropriate host and port and give it a useful name. Click on add to save it.
 - If you click on Servers in the viewer the name should appear and you can make it visible by clicking on it.


### Changing the port

By default, the port is set by 
```bash
export ECF_PORT=$((1500+usernumber))
```
in `mSMS.job` (40h1.1), or `Start_ecFlow.sh` (trunk). 

If you want to change this number (for example, if that port is in use already), you will also need to add a -p flag when calling `ecflow_start.sh` as follows:
```bash
ecflow_start.sh -p $ECF_PORT -d $JOBOUTDIR
```
Otherwise, `ecflow_start.sh` tries to open the default port. 

Note: if you already have an ecFlow server running at your new port number before launching an experiment, this won't be an issue. 

 

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


