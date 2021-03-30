```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/MFaccess?action=edit"
```
# Using Météo-France Servers

## Introduction

The procedure to get access to MF servers and their read-only git repository is outlined here

## First steps
 * Discuss your requirements for access to MF servers with the HIRLAM System project leader, Daniel Santos (dsantosm@aemet.es).
 * Download two forms *"Undertaking for the use of Météo-France computer resources"* and *"Demande d'authorisation de conexion au résau de Météo Franc"* from [http://www.cnrm.meteo.fr/aladin/spip.php?article157](http://www.cnrm.meteo.fr/aladin/spip.php?article157). 
   - The *"Undertaking for the use of Météo-France computer resources"* form  is to be signed by you only
   - The *"Demande d'authorisation de conexion au résau de Météo Franc"* must be signed by you and your department head. It must also include an institute stamp. You should enter details in *Contacts*, *Compte d'accesés aux machines du Centre de Cacul* and at the bottom with authorization from you institute manager with institute stamp.   - A scan of both forms with a brief introductory note should be sent to Eric Escaliere (eric.escaliere@meteo.fr) and cc'ed to Daniel Santos (dsantosm@aemet.es) and Claude Fischer (claude.fischer@meteo.fr).
   - Be careful with the *"Machine du client"*. I had to specify the name and IP address of my institute's Firewall server as this is what the outside world sees when I access external servers from my PC.
 * Météo-France will send (by post) your username (*Identificateur*) and password (*Mot de passe*) for log in.
 * The authentication process itself remains in two steps (first “parme”, then target), as before. 
 * A few specific examples follow (see [how_to_connect_toFW_afterCorr.pdf](how_to_connect_toFW_afterCorr.pdf), MF's instructions for full details):
   * beaufix:
```bash
ewhelan@realin23:gcc-8.3.1:.../~> which beaufix
alias beaufix='telnet beaufix.meteo.fr'
	/usr/bin/telnet
ewhelan@realin23:gcc-8.3.1:.../~> beaufix 
Trying 137.129.240.110...
Connected to beaufix.meteo.fr.
Escape character is '^]'.
Check Point FireWall-1 authenticated Telnet server running on mascarpone
User: whelane
password: your_parme_password
User whelane authenticated by FireWall-1 authentication

Connected to 137.129.240.110
Red Hat Enterprise Linux Server release 6.9 (Santiago)
Kernel 2.6.32-696.6.3.el6.x86_64 on an x86_64
beaufixlogin0 login: whelane
Password: your_ldap_password
Last login: Tue Oct 13 10:15:53 from gw2.met.ie
 _                           __  _       
| |                         / _|(_)      
| |__    ___   __ _  _   _ | |_  _ __  __
| '_ \  / _ \ / _` || | | ||  _|| |\ \/ /
| |_) ||  __/| (_| || |_| || |  | | >  < 
|_.__/  \___| \__,_| \__,_||_|  |_|/_/\_\ 

[whelane@beaufixlogin0 ~]$ 
```

## What next? **TO BE CONFIRMED**
### Access to MF servers via parme
 * Once you are happy that you can access PARME from your PC you should once again contact Eric Escaliere (eric.escaliere@meteo.fr) and request login details for merou (Eric will send you a temporary password) and LDAP login details to front-id to enable access to COUGAR, YUKI, BEAUFIX and ID-FRONT
 * An automatic e-mail will be sent from expl-identites@meteo.fr with you LDAP repository password.
 * front-id requires certain criteria for your password. These are detailed in French below. When you have received LDAP login details for front-id:
```bash
ewhelan@eddy:~> telnet parme.meteo.fr
Trying 137.129.20.1...
Connected to parme.meteo.fr.
Escape character is '^]'.
Check Point FireWall-1 authenticated Telnet server running on parmesan
User: whelane
password: ********
User whelane authenticated by FireWall-1 authentication
Host: front-id

Connected to id-front
Red Hat Enterprise Linux AS release 4 (Nahant Update 5)
Kernel 2.6.9-55.ELsmp on an x86_64
login: whelane
Password: 
Last login: Mon Nov  4 05:14:22 from gw2.met.ie
Bienvenue EOIN WHELAN
Vous pouvez changer votre mot de passe
-------------------------------------------------------------------------
- Controle de validite sur les mots de passe avant de poster la demande -
- Le OLD doit etre fourni. -
- Au moins 8 car, au plus 20 car. -
- Au moins 2 car. alpha et 2 car. non-alpha. -
- Ne pas ressembler a UID NAME et OLD sur une syllabe de + de 2 car. -
-------------------------------------------------------------------------
-------------------------------------------------------------------------
Hello EOIN WHELAN
You may change your password
-------------------------------------------------------------------------
- Validity control before demand acceptation -
- You must enter the old password first -
- The new password must contain: -
- At least 8 characters, 20 characters maximum -
- At least 2 alphanumeric characters and 2 non-alphanumeric characters -
- The passwd must contain a part of UID NAME -
-------------------------------------------------------------------------
Changing password for user 'whelane(56064)'.
Enter login(LDAP) password: 
New password: 
Re-enter new password: 
Votre mot de passe a ete change

```

 * When you have received login details for merou from Eric:
```bash
ewhelan@eddy:~> telnet parme.meteo.fr
Trying 137.129.20.1...
Connected to parme.meteo.fr.
Escape character is '^]'.
Check Point FireWall-1 authenticated Telnet server running on parmesan
User: whelane
password: ********
User whelane authenticated by FireWall-1 authentication
Host: merou

Connected to merou
Red Hat Enterprise Linux Server release 5.6 (Tikanga)
Kernel 2.6.18-238.el5 on an x86_64
login: whelane
Password: 
Last login: Tue Nov  5 10:06:35 from gw2.met.ie
[whelane@merou ~]$ passwd
Changing password for user whelane.
Changing password for whelane
(current) UNIX password: 
New UNIX password: 
Retype new UNIX password: 
passwd: all authentication tokens updated successfully.
[whelane@merou ~]$ 
```

### Access to (read-only) MF git arpifs git repository
MF use ssh keys to allow access to their read-only git repository. If approved by the HIRLAM System PL you should request access to the repository by sending a request e-mail to Eric Escaliere (eric.escaliere@meteo.fr) and cc'ed to Daniel Santos (dsantosm@aemet.es) and Claude Fischer (claude.fischer@meteo.fr) your ssh public key attached.

Once you have been given access you can create a local clone by issuing the following commands:
```bash
cd $HOME
mkdir arpifs_releases
cd arpifs_releases
git clone ssh://reader054@git.cnrm-game-meteo.fr/git/arpifs.git
```
Happy gitting!

[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)

----


