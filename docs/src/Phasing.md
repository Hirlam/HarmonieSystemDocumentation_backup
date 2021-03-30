```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Phasing?action=edit"
```
# Phasing information

Version (trunk,[40h1.1](../HarmonieSystemDocumentation/40h1.1/Phasing.md))

## Introduction

In the following we describe the procedure to interface the HIRLAM subversion repository to the git repository at Météo France. Further on, the tasks of the phasers and procedure to create a new branch are described. A course was held at Météo France in 2010 on the subject of *Maintenance Training*. Some of the presentations made at this *Maintenance Training* course may still be of use. They are available from this !GmapDoc web page: [http://www.cnrm.meteo.fr/gmapdoc/spip.php?article208&lang=en](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article208&lang=en)

## Access to external Meteo France git repository

Meteo France have a mirror of their git repository located outside of all firewalls. To be able to access the firewall you have to by granted access by providing a public SSH key to Meteo France. Once this is done you can clone the repository by:

```bash
git clone ssh://reader054@git.cnrm-game-meteo.fr/git/arpifs.git
```

Note that this is only for read access. To arrange access to the repository please contact the HIRLAM system manager.

## git -> subversion merging 

This section of the phasing documentation provides instructions on how to retrieve . In here we assume you have the access rights and the knowledge to connect to the right computers (Météo France git repositories can be accessed from 'merou'). Details on how to access Météo France servers are available here: [wiki:HarmonieSystemDocumentation/MFaccess](../HarmonieSystemDocumentation/MFaccess.md).
 * Set up git for the first time: Météo France provide documentation on how to set up and use their git repository here: [http://www.cnrm.meteo.fr/gmapdoc/spip.php?article218&var_lang=en](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article218&var_lang=en). A git user account must be requested from gco at Météo France. 

Add the following lines to your $HOME/.bashrc file (replacing **yourusername** with your user name):
```bash
export GIT_INSTALL="/home/marp001/git-install"
export GIT_ROOTPACK="git://mirage"
export GIT_HOMEPACK="/home/mrpe/yourusername/git-dev"
export GIT_WORKDIR="/home/mrpe/yourusername/.git-workdir"

export PATH=/home/marp001/git-install/default/bin:/home/marp001/git-install/default/libexec/git-core:/home/marp001/git-install/client/default/
bin:$PATH
```

I issued the **git_start** command (in /home/marp001/git-install/client/default/bin) to initialize a git repository in my own account on merou:

```bash
git_start    ### this will require your git userid and password
```

 * To get the latest tagged version of the source code:
```bash
cd $HOME/git-dev/arpifs/
git tag  ### this command will list available tags in the git repository
git archive --format=tar -o /home/mrpe/whelane/CY40_t1.04.tar --prefix=CY40_t1.04/ CY40_t1.04
cd $HOME
gzip /home/mrpe/whelane/CY40_t1.04.tar
```

 * ftp this zipped tar-ball to wherever you plan to carry out your merging activities.
 
 * Continue with the **Merge into vendor branch** instructions.

### Merge into vendor branch

To import source code from an external vendor we use the script auto_svn_load_dirs.pl in contrib/util.

Unpack your tar file in a directory with a proper name, e.g. CY40_t1.04, and rename the standard projects and remove some projects not used by Harmonie. (Further details on the !ClearCase/GIT/PERFORCE project naming are available here:
[http://www.cnrm.meteo.fr/gmapdoc/IMG/pdf/ykarchi40.pdf](http://www.cnrm.meteo.fr/gmapdoc/IMG/pdf/ykarchi40.pdf)).
```bash
gunzip CY40_t1.04.tar.gz 
tar -xvf CY40_t1.04.tar 
ls CY40_t1.04
cd CY40_t1.04
mv aeolus/ aeo
mv aladin/ ald
mv arpifs/ arp
mv biper/ bip
mv blacklist/ bla
mv satrad/ sat
mv surf sur
mv etrans/ tal
mv trans/ tfl
mv utilities/ uti
mv algor/ xla
mv ifsaux/ xrd
rm -rf cope/ obstat/ scripts/ scat/
```
Check out vendor/aladin/current as current-wc in a parallel directory:
```bash
svn co https://svn.hirlam.org/vendor/aladin/current current-wc
```
Now we are ready to start the merge:
```bash
auto_svn_load_dirs.pl -v -wc current-wc https://svn.hirlam.org/vendor/aladin current CY40_t1.04
```
This will present you with a list of all the files that seem to have been moved.
You then get a chance to have the script "Guess" what the corrective action should be.
You can accept or reject that choice for every file separately.

When all files have been processed, choose "Finish" to have the script complete the update
to vendor/aladin/current and commit the changes.

Subsequently, tag the new vendor/aladin/current:
```bash
svn copy -m "Tag vendor/aladin/current as vendor/aladin/cy40t1.04." https://svn.hirlam.org/vendor/aladin/current https://svn.hirlam.org/vendor/aladin/cy40t1.04
```

### Merge new vendor copy into phasing branch

Create a fresh working copy of the phasing branch (cy40):
```bash
svn co https://svn.hirlam.org/branches/phasing/cy40 working-copy
```
Perform the merge of the new source code. Note that <previous-tag> below should be the version used last time there was a merge from the vendor branch to the trunk. 
If you pick the wrong version you could miss changes. Postpone every conflict by choosing 'p':

```bash
svn merge https://svn.hirlam.org/vendor/aladin/<previous-tag> https://svn.hirlam.org/vendor/aladin/current working-copy/src
```

Resolve the conflicts by using the script [svn_resolve.pl](https://hirlam.org/trac/browser/trunk/contrib/util/svn_resolve.pl) (available in [contrib/util](https://hirlam.org/trac/browser/trunk/contrib/util)):
```bash
cd working-copy
svn_resolve.pl
```

The script gives you the option to view various differences, edit the working copy and
indicate to svn that the conflict has been resolved.

**In the end, the correct source has to end up in the file with the name of the original source.**
That name, with the extension '.working' means what's in the working-copy directory, with '.merge-left' means what's
in the old vendor branch and with '.merge-right' what's in the new vendor branch.

After all conflicts have been resolved (sometimes it might be expedient to simply take the
the updated file from the vendor branch and have researchers resolve conflicts afterwards),
the final commit is in order (also from directory 'working-copy').
```bash
svn commit
```

### Alternatively, merge new vendor copy into trunk

Create a fresh working copy of the trunk:
```bash
svn co https://svn.hirlam.org/trunk/harmonie working-copy
```
Perform the merge of the new source code. Note that <previous-tag> below should be the version used last time there was a merge from the vendor branch to the trunk. 
If you pick the wrong version you could miss changes. Postpone every conflict by choosing 'p':

```bash
svn merge https://svn.hirlam.org/vendor/aladin/<previous-tag> https://svn.hirlam.org/vendor/aladin/current working-copy/src
```

Resolve the conflicts by using the script [svn_resolve.pl](https://hirlam.org/trac/browser/trunk/contrib/util/svn_resolve.pl) (available in [contrib/util](https://hirlam.org/trac/browser/trunk/contrib/util)):
```bash
cd working-copy
svn_resolve.pl
```

**In the end, the correct source has to end up in the file with the name of the original source.**
That name, with the extension '.working' means what's in the working-copy directory, with '.merge-left' means what's
in the old vendor branch and with '.merge-right' what's in the new vendor branch.

After all conflicts have been resolved (sometimes it might be expedient to simply take the
the updated file from the vendor branch and have researchers resolve conflicts afterwards),
the final commit is in order (also from directory 'working-copy').
```bash
svn commit
```

### Reverting tree conflicts
Just a short note to save time ...If you come accross a conflict such as the one below ...
```bash
!     C surfex/SURFEX/.isba_fluxes.F90.swp
      >   local delete, incoming delete upon merge
```
one can try the following procedure:
```bash
touch src/surfex/SURFEX/.isba_fluxes.F90.swp
svn revert  src/surfex/SURFEX/.isba_fluxes.F90.swp
```

## Subversion -> MF git: Create a "contributions-from-hirlam" branch

Every development cycle there is the opportunity to add contributions or bug fixes from the HIRLAM consortium to IFS. This is done by creating a git branch off the latest version of that cycle. These HIRLAM contribution branches are then "posted" to the MF git SCR and GCO staff.

### Create a send branch and add HIRLAM contributions

Create a "send" branch based on the latest tagged vendor version. In the example below the vendor tag of cy40t1.04 is copied to the second contribution branch in the Harmonie phasing branch.

```bash
svn cp https://svn.hirlam.org/vendor/aladin/cy40t1.04 https://svn.hirlam.org/branches/phasing/cy40_send2
```

Commit agreed contributions from the Harmonie phasing branch to the send branch, cy40_send2 for example.

### Create MF git branch(es) containing HIRLAM contributions

Log in to merou.meteo.fr and prepare the HIRLAM send branch code for a final comparison with the MF 
```bash
cd $HOME
mkdir hirlam_sends
cd hirlam_sends
svn export https://svn.hirlam.org/branches/phasing/cy40_send2 cy40_send2_export
cp -r cy40_send2_export cy40_send2_gitexport
cd cy40_send2_gitexport
mv aeo aeolus
mv ald aladin
mv arp arpifs
mv bip biper
mv bla blacklist
mv obt obstat
mv sat satrad
mv sur surf
mv tal etrans
mv tfl trans
mv uti utilities
mv xrd ifsaux
mv xla algor
cd ~/git-dev/arpifs/
git pull
git branch CY40_bf.01_hirlam tags/CY40_bf.01
git checkout CY40_bf.01_hirlam
cd ~/hirlam_sends/
diff -r cy40_send2_gitexport/ ~/git-dev/arpifs/ > diffs.txt
```
Have a quick look in diffs.txt to ensure the send branch code contains the intended differences.

Ensure your account is readable so that when you "post" your branch GCO can read it:
```bash
cd $HOME/../
chmod 755 username
```
Now everything is in place to create some HIRLAM contribution git branches. In the following examples I will create two separate branches with two contributions from HIRLAM developers.
```bash
cd ~/git-dev/arpifs/
git pull
git_branch -r 40 -b t1 -v 04 -u suparar_bugfix      # answer "y" to create this branch
git branch                                          # this lists git branches and "*" indicates the branch you are working in (should be gitUserName_CY40_suparar_bugfix)
cp ~/hirlam_sends/cy40_send2_gitexport/arpifs/phys_dmn/suparar.F90 arpifs/phys_dmn/suparar.F90
git status                                          # check on status
git add arpifs/phys_dmn/suparar.F90                 # add this change to your local git branch
git commit arpifs/phys_dmn/suparar.F90              # enter a useful commit message
git_post                                            # this command "posts" your git branch (this may be the same as/similar to git push)
```
You should receive an e-mail from gco@meteo.fr acknowledging your branch posting. 

Now "move" back out of this new branch:
```bash
git checkout gco_CY40_t1
git fetch
git branch
```

Now an example involving the movement of files:
```bash
git_branch -r 40 -b t1 -v 04 -u lfi_sub_move
git branch
git mv ifsaux/programs/fadate.F90 ifsaux/misc/
git mv ifsaux/programs/fadiff.F90 ifsaux/misc/
git mv ifsaux/programs/lfi_alt_copy.F90 ifsaux/misc/
git mv ifsaux/programs/lfi_alt_indx.F90 ifsaux/misc/
git mv ifsaux/programs/lfi_alt_pack.F90 ifsaux/misc/
git mv ifsaux/programs/lfifactm.F90 ifsaux/misc/
git status
git add ifsaux/misc/fadate.F90  ifsaux/misc/fadiff.F90 ifsaux/misc/lfi_alt_copy.F90 ifsaux/misc/lfi_alt_indx.F90 ifsaux/misc/lfi_alt_pack.F90 ifsaux/misc/lfifactm.F90
git commit
git_post
```
### Send GCO an e-mail relating to HIRLAM contributions
MF request that each contribution branch is accompanied with an e-mail (To:gco@meteo.fr cc: claude.fischer@meteo.fr, Ulf.Andrae@smhi.se) containing the following information:

 * Title/header of email should read like:  "dev"  name_of_target_cycle  short_title
   - name_of_target_cycle  should be CY40 or CY40T1 etc ...
   - short_title  can be either to announce that this is a bugfix or a specific contribution for R&D: "Correction of a bug in Full-Pos"   or  "Additional code for handling Aeolus in ODB"   or  "Hirlam contribution to CY40"   etc ...

 * Date and name of Contributor:
dd/mm/yyyy Name (MF Service, Aladin or Hirlam partner)

 * Model or configuration affected by the modset:
   - arpege, aladin-france, aladin-réunion, arome, aearp, pearp,...
   - for partners: alaro, arome, harmonie (but you may be more specific about harmonie-alaro or harmonie-arome)

 * Context and cycle:
   - context: oper, double, dev   => refers to MF environment. dev => for partners
   - cycle example: 40_op1 (MF only), 40_bf.01 (bugfix), 40_t1 (pre-cycle during phasing)

 * Type of file/resource to be modified:
Namelist, Binary, climatology file, file of constant fields (sigma_b, ...), blacklist, ...   => mostly "Binary" (i.e. code changes) and "namelist" seem relevant for partners

 * Description of the set of modifications:
... a more or less detailed text about the code changes: purpose, how it was done, what is the impact on results or performances, options still under work ...

 * Details about the provided files:
   - if source code changes: name of GIT branch & list of modified/added/deleted routines/files
   - if "files of constants":  (...)  (only MF, irrelevant for partners)
   - if namelist change: name of namelist block, delta of namelist and/or location of namelist file  (probably only relevant to MF)

## Getting namelists used at Meteo-France

Log in to yuki (or tori). Then run the command **genv** (you may have to add /mf/dp/marp/marp001/public/bin to your PATH if you don't have it already):
```bash
mrpe726@yuki:~> genv
usage (1) : genv suite-model:YYYY/MM/DD[-RXX]

            suite = oper dble test
            model = arpege aladin tropique mocage restart peace reunion alacep arome varpack tsr aria algerie qatar libye testmp1 testmp2

usage (2) : genv suite-model

            suite = oper dble test
            model = arpege aladin tropique mocage restart peace reunion alacep arome varpack tsr aria algerie qatar libye testmp1 testmp2

	    NB: same as (1) - today's date is automatically added

usage (3) : genv cycle-id
       ex : genv cy33t0_op1.23
```
Note that there are no namelists for ALARO. Anyway, to get e.g. the current AROME namelists:
```bash
mrpe726@yuki:~> genv oper-arome | grep NAMELIST
NAMELIST_ALADIN="al35t2_arome-op1.16.nam"
NAMELIST_AROME="al35t2_arome-op1.16.nam"
NAMELIST_UTILITIES="ut35t2_arome-op1.04.nam"
```
To actually get the namelists, run the command **gget**
```bash
mrpe726@yuki:~> gget al35t2_arome-op1.16.nam
```
You get a lot of namelists in a directory named $NAMELIST_AROME
```bash
mrpe726@yuki:~> cd al35t2_arome-op1.16.nam/
mrpe726@yuki:~/al35t2_arome-op1.16.nam> ls
diff.al35t2_arome-op1.15.nam  namel_ee927_surf.franxl    namel_lamflag_odb.midpyr  namel_sude_off_fp0
list.al35t2_arome-op1.16.nam  namel_ee927_surf.midpyr    namel_lamflag_odb.nore    namel_surfex_output
namel_bret_off_fp             namel_ee927_surf.nore      namel_lamflag_odb.pari    README
namel_bret_off_fp0            namel_ee927_surf.pari      namel_lamflag_odb.sude    select_bret_off_fp
namel_cplsurf_def             namel_ee927_surf.sude      namel_midpyr_off_fp       select_bret_off_fp0
namel_ee927_bret_cpl          namel_fpos_bret_addsurf    namel_midpyr_off_fp0      select_fran_off_fp
namel_ee927_bret_cpl0         namel_fpos_fran_addsurf    namel_minim               select_fran_off_fp0
namel_ee927_fran_cpl          namel_fpos_franxl_addsurf  namel_nore_off_fp         select_franxl_fp
namel_ee927_fran_cpl0         namel_fpos_midpyr_addsurf  namel_nore_off_fp0        select_franxl_fp0
namel_ee927_franxl_cpl        namel_fpos_nore_addsurf    namel_pari_off_fp         select_franxl_off_fp
namel_ee927_franxl_cpl0       namel_fpos_pari_addsurf    namel_pari_off_fp0        select_franxl_off_fp0
namel_ee927_midpyr_cpl        namel_fpos_sude_addsurf    namel_previ_dyn_off       select_midpyr_off_fp
namel_ee927_midpyr_cpl0       namel_fran_off_fp          namel_previ_off           select_midpyr_off_fp0
namel_ee927_nore_cpl          namel_fran_off_fp0         namel_previ_surfex        select_nore_off_fp
namel_ee927_nore_cpl0         namel_franxl_off_fp        namel_progrele            select_nore_off_fp0
namel_ee927_pari_cpl          namel_franxl_off_fp0       namel_pseudotraj          select_pari_off_fp
namel_ee927_pari_cpl0         namel_franxl_previ         namel_rgb                 select_pari_off_fp0
namel_ee927_sude_cpl          namel_franxl_previ_dyn     namel_rgb_met8            select_sude_off_fp
namel_ee927_sude_cpl0         namel_lamflag_odb.bret     namel_rgb_met9            select_sude_off_fp0
namel_ee927_surf.bret         namel_lamflag_odb.fran     namel_screen
namel_ee927_surf.fran         namel_lamflag_odb.franxl   namel_sude_off_fp
```
## Preparations before phasing

Read the Meteo France webpage about phasing [http://www.cnrm.meteo.fr/aladin/spip.php?article63].

## HARMONIE phasing efforts

[cy38t1](../Phasing/cy38t1.md)

[cy39t1](../Phasing/cy39t1.md)

[cy40t1](../Phasing/cy40t1.md)

[cy41t1](../Phasing/cy41t1.md)

[cy42t1](../Phasing/cy42t1.md)

[LUNBC_in_cy43t1](../Phasing/LUNBC_in_cy43t1.md)

[cy45t1](../Phasing/cy45t1.md)

[cy46t1](../Phasing/cy46t1.md)

### Testbed experiments

The Harmonie testbed is a tool to help you verify the technical functionality of the system. It runs through all meaningful configurations in an efficient manner. 
Read more [here](../HarmonieSystemDocumentation/Evaluation/HarmonieTestbed.md).

### Update documentation

The final task at the end of the phasing is to tag the documentation with the current version number. The documentation has of course been updated continuously but might need a final review before tagging. Some scripts to make tagging easier is attached to this page. After tagging the new pages may be loaded to the wiki using the trac-admin tool on hirlam.org.

```bash
trac-admin /data/www/trac_hirlam_env/ wiki load MYDIR
```

where MYDIR is a directory containing the revised wiki pages. You must have TRAC_ADMIN permissions to be able to use the trac-admin tool.

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


