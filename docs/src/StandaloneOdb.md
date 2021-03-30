```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/StandaloneOdb?action=edit"
```
# ODB software
## Get the software
To make best use of ODB information produced by your Harmonie experiment one should use ODB and ODB-API software developed by ECMWF. Below are instruction on how to obtain the software from ECMWF.

### ODB-API
ODB-API software is open source and released under an Apache licence: [https://software.ecmwf.int/wiki/display/ODBAPI](https://software.ecmwf.int/wiki/display/ODBAPI) 

### ODB
*ODB stands for Observational !DataBase. It is database software to store and retrieve large amounts of meteorological numerical data in an efficient manner while used from within IFS. ODB software mimics relational database queries through its ODB/SQL -compiler and accesses data currently via a Fortran90 library interface.* The original documentation is available here: [http://www.ecmwf.int/research/ifsdocs/CY28r1/pdf_files/odb.pdf](http://www.ecmwf.int/research/ifsdocs/CY28r1/pdf_files/odb.pdf)

## Building your ODB software
The ODB-API Software bundle uses cmake [http://www.cmake.org](http://www.cmake.org) to configure the make files used to compile the software. The instructions below worked with Redhat 7/GCC 4.8.5 and CentOS 7/GCC 4.8.5. On newer systems python functionality may have to be switched off with -DENABLE_PYTHON=OFF.

```bash
VERSION=0.18.1
wget https://software.ecmwf.int/wiki/download/attachments/61117379/odb_api_bundle-${VERSION}-Source.tar.gz
gunzip odb_api_bundle-${VERSION}-Source.tar.gz
tar -xvf odb_api_bundle-${VERSION}-Source.tar
cd odb_api_bundle-${VERSION}-Source
mkdir build
cd build
cmake.. -DCMAKE_INSTALL_PREFIX=/opt/metapp/odb_api/${VERSION}/gnu \
-DENABLE_ODB_API_SERVER_SIDE=ON -DENABLE_FORTRAN=ON \
-DENABLE_GRIB=OFF -DENABLE_ODB_SERVER_TIME_FORMAT_FOUR_DIGITS=ON \
-DENABLE_PYTHON=ON -DENABLE_ODB=ON -DODB_SCHEMAS="ECMA;CCMA"
make -j 2
ctest
make install
```

# ACTION: FOR EOIN: everything below here needs to be updated

# ODB data
## Convert ODB-1 to ODB-2
Details on how to convert your ODB-1 (Harmonie experiment) databases to ODB-2 using odb_migrator are described here. I have used version 0.9.31 of ODB-API (I have had some problems with 0.9.32). I will use a Harmonie CCMA conventional ODB-1 database as an example:
```bash
tar -xvf odb_ccma.tar
cd odb_ccma/CCMA/
dcagen
cd ../../
ls -l ../conv.38h1.sql
which odb_migrator
/opt/metlib/odb_api/0.9.31/gnu/bin/odb_migrator -addcolumns "expver='    38h1',class=2,stream=1025,type=264" odb_ccma/CCMA ../conv.38h1.sql var${DTG}.odb
ls -l var${DTG}.odb
```
Here is the SQL file used: [conv.38h1.sql](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/StandaloneOdb/conv.38h1.sql). To construct my conv.38h1.sql file did carried out the following commands:
```bash
cd odb_ccma/CCMA/
odbsql -q "select * from desc,timeslot_index,hdr,body" | head -1 
```

## Instructions for use on ecgb
On ecgb I have installed *odb_migrator* in my own account. ODB developers have promise to provide a "system" installation of odb_migrator soon. The next version of ODB-API on ecgb should include *odb_migrator*. My installation is here:
```bash
/home/ms/ie/dui/odbapi/0.9.31
```

To produce your own ODB-2 file from a Harmonie CCMA tar ball on ecgb:

```bash
module load odb
export PATH=/home/ms/ie/dui/odbapi/0.9.31/bin:$PATH
export LD_LIBRARY_PATH=/home/ms/ie/dui/odbapi/0.9.31/lib:$LD_LIBRARY_PATH
cd $SCRATCH
mkdir ODB2odb
cd ODB2odb
## copy your odb_stuff.tar/odb_ccma.tar file from ECFS/your home system to this directory
## eg -- ecp ec:/dui/harmonie/refSonde38h1p1/2013/12/27/00/odb_stuff.tar .
tar -xvf odb_stuff.tar
tar -xvf odb_ccma.tar
cd odb_ccma/CCMA/
dcagen
cd ../../
odb_migrator odb_ccma/CCMA -addcolumns "expver='refSonde',class=2,stream=1025,type=264" /home/ms/ie/dui/odbapi/conv.38h1.sql conv2013122700.odb
odb header conv2013122700.odb
odb sql 'select distinct varno' -i conv2013122700.odb
odb sql 'select count(*) where varno=2' -i conv2013122700.odb
#
rm -f bdstrategy odb*.tar ## tidy up the directory if you wish
rm -rf odb_ccma
```

# ODB visualisation
ODB-2 data can be visualized (directly) using Metview. On local platforms Metview must be built with ODB support (that uses ODB-API software) to visualize ODB-2 data. Here is an example, odbmap.mv4, of using Metview on ecagte to visualize ODB-2 data using a Metview Macro. This example requires an ODB-2 data file as input. Optionally this macro can also plot domain grid-points from a Harmonie GRIB file (called dom.grib) to indicate the extent of your Harmonie model domain.
 * Usage:
```bash
 odbmap:: Usage: metview -b odbmap.mv4 inputfile odbvar odbrequest odblegend outputtype
 odbmap::   where: inputfile  -- ODB-2 file
 odbmap::   where: odbvar     -- ODB variable to be plotted
 odbmap::                     -- (enclosed with inverted commas)
 odbmap::   where: odbrequest -- ODB SQL request 
 odbmap::                     -- (enclosed with inverted commas)
 odbmap::   where: odblegend  -- legon/legoff
 odbmap::   where: outputtype -- ps/png
```
 * An example to plot 2m temperature observation values on 25th December 2013 at 12z:
```bash
cd  $SCRATCH
cp -r /home/ms/ie/dui/odbMacroTest .
cd odbMacroTest
metview4 -b odbmap.mv4 conv201312.odb "obsvalue" "andate=20131225 and antime=120000 and varno=39" legon png
xv odbmap.1.png
```
