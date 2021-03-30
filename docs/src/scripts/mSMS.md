```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/scripts/mSMS?action=edit"
```

# mini-SMS and mini-XCdp

## Overview

 * What is mini-SMS?
 * What is mini-XCdp?
 * How does mini-SMS fit into the Harmonie script system?
 * Basic mini-SMS:
   * Definition file(s)
   * Tasks and containers, execution
   * Control structures (`if, repeat, loop, trigger, complete`)
 * Interaction with mini-SMS through mini-XCdp (demo)

## What is mini-SMS?

Mini-SMS is a simple [[Color(blue, job scheduler)]], the source code is contained in the perl script [mSMS.pl](https://hirlam.org/trac/browser/trunk/harmonie/msms/mSMS.pl).
It was written around year 2000 by Gerard Cats, former Hirlam system manager, in order to make the Hirlam runs at ECMWF (and locally) run more efficiently.
It was inspired by, and is a subset of [SMS](http://www.ecmwf.int/products/data/software/sms.html), the **Supervisor and Monitoring System**, developed at ECMWF.
The main advantage of mini-SMS compared to full SMS is that it is easy to port to a new system, e.g., your laptop. Having a home-made system also makes it easier for the system managers to implement new features when this is required.

Mini-SMS basically works as follows: the user provides a description of the suite of programs that (s)he wants to run, possibly distributed over several computers. This description is in the [[Color(blue, (template) suite definition file)]]. In that file, the user should also specify in what order the modules must be executed, by using certain [[Color(blue, control structures)]].

In Harmonie, things related to mini-SMS are located in subdirectory [msms](https://hirlam.org/trac/browser/trunk/harmonie/msms). The main template definition file is [harmonie.tdf](https://hirlam.org/trac/browser/trunk/harmonie/msms/harmonie.tdf), but there are also others.

## What is mini-XCdp?

Mini-XCdp is a graphical user interface (GUI) to the mini-SMS scheduler. The source code is contained in the perl script [mXCdp.pl](https://hirlam.org/trac/browser/trunk/harmonie/msms/mXCdp.pl).
It communicates with mini-SMS by sending HTTP requests. For this to work, a small extension [WebServer.pl](https://hirlam.org/trac/browser/trunk/harmonie/msms/WebServer.pl) is included by `mSMS.pl` on demand.
More information on the client/server interaction can be found [here](../../HarmonieSystemDocumentation/scripts/mXCdp.md), and also in this [blog post](https://hirlam.org/trac/blog/split_mSMS_mXCdp).

The name mini-XCdp is perhaps a bit unfortunate, it is not as closely mimicking ECMWF's **XCdp** (X Control and display program) as mini-SMS follows full SMS. But it gives the user some possibilities to interact with the scheduler, e.g.:
 * If a task aborts, it can be restarted from the GUI, without rerunning the whole suite.
 * Log files (and job container scripts) can be viewed.
 * Job status can be overridden, e.g. forced to "complete".
 * Tasks or families can be suspended (and resumed).
 * (Active) jobs can be killed (if implemented for the local system)

The GUI can be started also if the scheduler is currently not running. In that case it is possible to see in what state the scheduler was when it terminated. It should generally also be possible to restart the scheduler from exactly where it left off and continue the run, possibly with some manual intervention. 

## How does mini-SMS fit into the Harmonie script system?

The master script [Harmonie](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/Harmonie) is the user's main interface to the system. `Harmonie` is a perl script, which will again usually invoke the old interface (sh) script [Main](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/Main). `Harmonie` recognizes a set of "actions" (as implemented in the scripts [Actions](https://hirlam.org/trac/browser/trunk/harmonie/scr/Actions) and [Actions.pl](https://hirlam.org/trac/browser/trunk/harmonie/scr/Actions.pl)). The most important actions will invoke the script [Start](https://hirlam.org/trac/browser/trunk/harmonie/scr/Start). Finally, `Start` will invoke the mini-SMS script `mSMS.pl` with the correct arguments, and with the proper environment variables set. The user should normally never invoke the scripts `mSMS.pl` or `mXCdp.pl` herself.

### = Script call sequence:=
 * [[Color(blue, Harmonie)]] (top level script, perl)
  * [[Color(blue, Main)]] (old top level script, sh)
   *     * [[Color(blue, Start)]] (reads [config_exp.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/config_exp.h))
     * [[Color(blue, mSMS.pl)]] (input: [harmonie.tdf](https://hirlam.org/trac/browser/trunk/harmonie/msms/harmonie.tdf); template definition file)
      1. prepare [[Color(green, harmonie.def)]] (and harmonie.html)
      2. play      * [[Color(blue, mXCdp.pl)]] (if $mSMS_WEBPORT == 1)

Note that mini-SMS goes through two steps, the preparation step and the execution (play) step. In the first step, the template definition file is converted into a plain definition file. This preparation step is something unique to mini-SMS, it is not a part of full SMS. In full SMS, the definition file is "played" directly. However, full SMS accepts several things in the .def file that mini-SMS does not, e.g., if- and loop-statements. These are only understood in the preparation step of mini-SMS, making these constructs less dynamic than in full SMS. It is e.g. not possible to test on variables that change during the run. 

Note also that `Harmonie start DTG=...` will usually automatically invoke also `mXCdp.pl` in addition to `mSMS.pl`. But if the user decides to close the GUI, a new GUI can be opened later by the command
```bash
 Harmonie mon
```
It is possible to have more than one GUI open for the same experiment, e.g., one at work and another one at home.

At ecgb, mSMS is now submitted as a batch job in a special queue minisms, with no guarantee of immediate execution (although this is what usually happens). Thus, since mXCdp still starts immediately, it can sometimes report that there is no running scheduler (since mSMS has not started execution yet). This behaviour is likely to confuse users, if they don't realize that mSMS and mXCdp are two separate processes.

## (mini-)SMS basics

 * The definition file(s) (e.g., harmonie.tdf) describes the system to be run in terms of [[Color(blue, suites, families, tasks)]] and [[Color(blue, control structures)]].
 * A family is just a group of tasks and/or other families. A suite is a top-level family.
 * All tasks need a [[Color(green, "task".sms)]] [[Color(blue, container)]] (script). In Harmonie, many containers are simply symbolic links to [default.sms](https://hirlam.org/trac/browser/trunk/harmonie/sms/default.sms), which invokes a script named [[Color(green, "task")]].
 * All containers should include the files [sms.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/sms.h) and [hosts.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/hosts.h) at the top, and [end.h](https://hirlam.org/trac/browser/trunk/harmonie/sms/end.h) at the bottom.
 * By default all tasks start as soon as possible. We must include [[Color(blue, triggers)]] to specify dependencies between tasks, e.g. that one task must wait for another task to complete before it can start execution.

### = (mini-)SMS variables=
 * In the definition file, variables may be defined and set by [[Color(green, edit)]] statements, e.g.:
```bash
 edit SMSTRIES 1
 edit SMSCMD "perl -S Submit.pl -o %SMSJOBOUT% %SMSJOB% >> mSMS.log 2>&1"
```
 * Variables are referred to by [[Color(blue, %VAR%)]]. Variables that start with SMS might have a special meaning to mSMS. Avoid such names if you need to create your own variable.

### = mini-SMS task execution=
When mini-SMS decides it is time to execute a particular task (i.e., it is triggered) it first converts the [[Color(green, "task".sms)]] container script into a (sh) script [[Color(green, "task".job%SMSTRYNO%)]], where [[Color(blue, %SMSTRYNO%)]] is the attempt number of the task. %SMSTRYNO% runs from 1 to [[Color(blue, %SMSTRIES%)]] (default 1) for automatically submitted tasks, but %SMSTRIES% is ignored for tasks that are rerun through the GUI.

Since jobs might have different requirements for memory, number of CPUs, host to run on, whether to run as a background job or be submitted to a batch queuing system etc., in Harmonie all jobs go through a second step, the so-called "Universal Job Submission Filter" (script [Submit.pl](https://hirlam.org/trac/browser/trunk/harmonie/scr/Submit.pl)). This filter reads the [[Color(green, "task".job%SMSTRYNO%)]] file and the [[Color(green, Env_submit)]] file for this (sms)host, and then creates the final (sh) job file [[Color(green, "task".job%SMSTRYNO%-q)]]. In this file, headers (for the queueing system) and footers might have been added.

All tasks emit [[Color(blue, signals)]] at certain stages of their execution, namely when [[Color(green, active)]] and [[Color(orange, complete)]] or [[Color(red, aborted)]].

The various colors that the boxes get in the GUI correspond to the current state of the actual family or task. The codes are as follows:


| [[Color2(blue, white, queued)]] | [[Color2(cyan, black, submitted)]] | [[Color2(green, black, active)]] | [[Color2(yellow, black, complete)]] | [[Color2(red, white, aborted)]] | [[Color2(orange, black, suspended)]] | [[Color2(brown, white, unknown)]] | [[Color2(magenta, black, halted)]] | [[Color2(black, white, shutdown)]] |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |


### = mini-SMS client/server communication=

Before changeset [13288] this signalling was always via files created in $SMSFLAGDIR (often $HM_DATA). The scheduler would remove these files as soon as the signals were registered. After [13288], it is also possible to configure the system so that signals are sent over http instead of using files. One possible drawback with http signals is that if the mSMS scheduler terminates while tasks are still submitted or active, signals can be lost. With files these signals would be picked up if the scheduler was restarted through the mXCdp interface, but this will not happen with http signals. Therefore, more user interaction might be necessary on systems with http signals. If you see errors like

```bash
msms_client error for request
'http://ecgb06:27965/_ctrl/set?t=/letkf_harmonEPS_38h11_v6_e1/Date/Hour/Cycle/Mbr000/PostAnalysis/Makegrib_an&s=1':
500 Can't connect to ecgb06:27965 (Connection refused)
#################################################################
# Failed to send signal 'complete' to mini-SMS!
# If mini-SMS is dead and you restart it from mXCdp, you should
# manually set this task to 'complete' to resume your run!
#################################################################
```

the mSMS server has died before the task completed. To sort this out you have to restart your server ( using Harmonie mon ) and check all the tasks that are still running ( i.e. are green ). If the have completed you can just change startus to complete and accordingly for aborted tasks. 


### Template definition file control structures

Below is a brief list of the various control structures that a template definition file (.tdf) may contain. Those in blue are common with full SMS, and will also appear in the generated (.def) definition file. Those in green will be processed during the preparation step and might be transformed into something else in the definition file. 

 *    * The typical condition is:  ( some/family/task == complete )
   * If queued, the task will be submitted when the condition is fulfilled.

 *    * mini-SMS sets the task or family complete **without executing it** if the condition is fulfilled.
   * Note that complete statements are checked before triggers, therefore, if a task has both a trigger and a complete statement it may get the status complete before the trigger is fulfilled. This might be surprising if you have another task triggered on this particular task being complete.  **NOTE added later:** After changeset [10876] (Sept. 8, 2012), this has been changed; a task is not set complete before it is also triggered.

 *    * This generates an iterative loop in the scheduler, the variable [[Color(blue, var)]] is cycled between its start and stop values.
   * The execution is **sequential**, i.e., one iteration must complete before the next is queued.

 *    * This construct may only appear in a tdf file, the preprocessing step will "duplicate" the loop body the specified number of times in the definition file.
   * In the loop body, use of [[Color(green, @var@)]] will be replaced by the actual loop iterate.
   * Note that the execution is normally **parallel**, unless the loop body contains triggers to make each "iterate" wait for the previous one.

 *  *  *    * These constructs may also only appear in tdf files, the preprocessing step will include or ignore lines depending on the outcome of the tests. The first two variants are there for historic reasons. The third form (general if) can easily replace the two varieties above.
   * Note that full SMS also has if-tests, but these are evaluated at playtime (which is more general).

For many examples of the use of these constructs, take a look at [harmonie.tdf](https://hirlam.org/trac/browser/trunk/harmonie/msms/harmonie.tdf). Since changeset [10930], this tdf also covers ensemble mode, there is no separate *harmeps.tdf* anymore.

The indentation style used in these tdf files may look confusing, but there is a separation of prepare-time constructs (ifs and loops), which are indented independently of the other standard definition file constructs.

## More documentation

 * On [mini-SMS](https://hirlam.org/UG/HL_Documentation/mSMS). Old and slightly outdated, but extensive.
 * On [mini-XCdp](../../HarmonieSystemDocumentation/scripts/mXCdp.md). A bit more detailed than in this page. An even older document (from before the split into two separate programs) can be found [here](https://hirlam.org/UG/HL_Documentation/mSMS/mXCdp).

----


