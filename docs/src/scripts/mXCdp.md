```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/scripts/mXCdp?action=edit"
```
# A new client / server solution for mXCdp / mSMS

The original mini-XCdp monitor was written as a set of (perl/Tk) subroutines
running inside the mini-SMS scheduler. Although working fairly well for almost 10 years, this solution has a number of weaknesses:

 * If the monitor crashes, the scheduler will also crash. This has been observed frequently, especially after logging out and trying to revive the graphical window in a new login session. A solution to this problem has never been found because the problem is believed to originate from within the Tk toolkit.
 * The mSMS scheduler can have only one monitoring window.
 * Monitoring from a different computer than the one that is running the mSMS scheduler is difficult (although a solution with limited functionality, using the --lead and --follow options of mSMS does actually exist).
 * If the Hirlam/Harmonie toplevel job is submitted to a batch queueing system, monitoring may not be possible at all, because the DISPLAY variable is lost or not meaningful.

In order to improve on this situation, a new solution separating mSMS and mXCdp into two programs (server and client) has been developed.
Communication between them goes via the HTTP protocol, familiar from web servers and browsers. A new set of subroutines (in a new file `WebServer.pl`, included by `mSMS.pl`) turns the mSMS scheduler into a little web server that accepts HTTP connections.
There are two types of clients:

 * The special client mXCdp (in `mXCdp.pl`), which is written in perl and reuses most of the old code from `mXCdp.plib`.
 * Any web browser that can handle !JavaScript.

The mXCdp client is started by typing `'Hirlam mxcdp'` or `'Harmonie mxcdp'` from the user's experiment directory (in just the same way as was supposed to revive the monitoring window in the old solution ... but often crashed). This can now actually be done whether the mini-SMS scheduler is running or not. If the scheduler is not running, the mXCdp client will read the definition and checkpoint files, and show the status of mini-SMS when it last terminated, whether it was complete or aborted. It is also possible to e.g. inspect log files of failed tasks. It is even possible to restart the mini-SMS server from where it left off, if this is desirable. In this case mini-SMS is restarted in the halted state, so that you can sort out any inconsistencies (e.g. as a result of lost signals) before continuing.

The look and feel of the new client is very similar to the old one. The only slight disadvantage of the new client is that the status of the various tasks and families is not immediately updated as in the old solution, but instead every time the client polls the server. By default this is every 10 seconds (it can be changed via the menus of mXCdp). In practice this is frequent enough to not be of much annoyance. A new icon on the menu bar will indicate the status of the communication. The meaning is as follows:

 * [[Image(no_server.png)]] There is no running mini-SMS server for the experiment.
 * [[Image(no_comm.png)]] mini-SMS is alive, but no communication is taking place right now.
 * [[Image(comm_active.png)]] Communication between the mini-SMS server and the mXCdp client is ongoing.

If the server is alive its URL (see below) will be displayed in a tooltip if you pass your cursor over the status icon.

## How to activate / disable

The usage of the new client/server solution is controlled by the environment variable `mSMS_WEBPORT`, which is expected to be an integer. It is interpreted as follows:

 * If mSMS_WEBPORT <= 0, the web server is disabled, and the old monitor can still be used (unless mXCdp=DISABLE).
 * If 1 <= mSMS_WEBPORT < 1024, the port that the server will listen on is selected at random, in the range 10000 to 30000. If mSMS_WEBPORT=1 (the default), the new mXCdp client will start automatically whenever `Hirlam` or `Harmonie` is started or resumed/prodded. If you don't want automatic startup of the client (e.g., for batch queue submitted runs), but still want a random port, set e.g. mSMS_WEBPORT=2.
 * If mSMS_WEBPORT >= 1024 (i.e., a non-privileged port), the mSMS server will try to listen on the given port.

If mSMS_WEBPORT >=1 (i.e., the web server is enabled), the old monitor is disabled. In other words, both solutions should not be active at the same time (although technically possible), to avoid confusion.

## Security
The URL (which could be something like `'http://ecgb:12345/'`) of the mSMS web server is written to a file `.webserver` in the mSMS working directory. This directory is `$HL_DATA` for Hirlam and `$HM_DATA` for Harmonie. The file has permissions 0600, i.e., it is only readable by the owner of the experiment. This is because there is no mechanism to prevent other users from connecting to your server's port and trying to control your experiment. So with a port chosen at random you will at least have security comparable to that of the pin code on your bank card. If you're not satisfied with that, or for some reason want a fixed port to listen on (e.g. to set up an ssh tunnel from a remote machine), more security is possible. You can place a file in your experiment directory (`~/hl_home/$EXP` or `~/hm_home/$EXP`) called `.htpasswd`, containing username/password combinations generated with the `htpasswd` utility. In this case any action that implies control over the mSMS server (status changes, job submission, termination etc.) will request authentication. If successfully authenticated, your credentials will be remembered for the duration of the monitoring session.

## Local installation
If your local computer platform has a fairly recent perl version, you should not have to do anything special in order to use the new client / server solution. The code is built on the perl `libwww` library, which is now included in the base perl installation. More specifically, the server is built upon the module `HTTP::Daemon` and the client around `LWP::UserAgent`. The graphical part of the client uses the
Tk toolkit as before, so you may still have to install this toolkit.

## Removed features
A few minor features have been removed compared to the old built-in monitor. The menu entries
 * Allow unsafe operations for 60s
 * Single sweep
 * Lead mode control
 * Auto exit after ...
 * Auto abort after ...
 * Open single-task families
 * Close single-task families
are no longer present. In addition, if the popup menu entry "submit job" is chosen, the buttons marked
 * Edit command
 * Edit jobfile
 * Recreate job and command
have all been removed. Some of this might reappear depending on feedback (and inspiration).

## New features
As indicated above, the client/server solution opens up some new possibilities:
 * You can have as many monitoring windows as you like connected to your mSMS server. For example, if you have an interesting experiment running at ECMWF when leaving work, you can (if you bring your Actividentity keychain token with you) log in from home and open a new monitor to watch how your experiment is going.
 * Monitoring of operational runs (e.g. by operators) should be easier to achieve, also if these jobs are submitted to a batch queueing system.
 * You can start the monitor even if the experiment is no longer running, to see in what state it was when it terminated. If not complete, you may also be able to resume it from the monitor.

Another new feature, which is not directly related to the client / server separation, is that mXCdp will now remember the size and placement of the toplevel windows of the application between invocations. These data are stored in `~/.mxcdprc`.

## The !JavaScript client
If you sit on a computer where the URL of the mSMS web server makes sense (i.e., it is within your domain) and you have access to a good web browser like e.g. Firefox, you can try to open a connection to the server from your browser. The window will split into two frames, on the left you will have the suite/family/task tree as in mXCdp, and on the right you will by default see the html version of the suite definition file. This frame will also be used if you want to inspect job or log files. The graphics of the !JavaScript client is based on the Yahoo User Interface library (YUI). You need to be connected to the internet to download the necessary files from Yahoo servers to use it (this will happen automatically). This client is not as well tested as the mXCdp client however, and does not (yet?) have all the same possibilities for interaction with the server. So mXCdp would be your preferred client if you can use it.

Enjoy!
