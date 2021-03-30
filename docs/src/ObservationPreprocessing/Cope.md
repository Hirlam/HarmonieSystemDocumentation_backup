```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ObservationPreprocessing/Cope?action=edit"
```
# ODB creation (COPE)
## General Description
HIRLAM, ALADIN and Météo France are working together with ECMWF to develop COPE, Continuous Observation Pre-processing Environment, to replace !Oulan/Bator (and BUFR2ODB at ECMWF), to improve the pre-processing of observations for use in NWP. COPE developments are made in ECMWF's git repository. A COPE [40h1 HARMONIE branch](https://hirlam.org/trac/browser/branches/harmonie_40h1_cope) has been created to test COPE in the HARMONIE framework.

Here are some links that may be of interest:
 * [https://software.ecmwf.int/wiki/display/COPE/COPE](https://software.ecmwf.int/wiki/display/COPE/COPE): COPE wiki (restricted access)
 * [http://www.rclace.eu/File/Data_Assimilation/2014/201406_COPE_Reading_report.pdf](http://www.rclace.eu/File/Data_Assimilation/2014/201406_COPE_Reading_report.pdf): **Report on the COPE technical meeting**, *Alena Trojáková*.  ECMWF, Reading 9-12, June 2014
 * [http://www.cnrm.meteo.fr/aladin/IMG/pdf/copeovervieweoinwhelan.pdf](http://www.cnrm.meteo.fr/aladin/IMG/pdf/copeovervieweoinwhelan.pdf): **Overview of COPE**, *Eoin Whelan*. Joint 24th ALADIN Workshop & HIRLAM All Staff Meeting 2014, 7-11 April 2014, Romania.

## "Support" software packages
This section provides a step-by-step set of instruction on how to compile COPE and COPE related software.
### Preparation
These instructions rely on the ODB API source code bundle [odb_api_bundle-0.15.2-Source.tar.gz](https://software.ecmwf.int/wiki/display/ODBAPI/Releases) and emoslib [libemos-4.4.2-Source.tar.gz](https://software.ecmwf.int/wiki/display/EMOS/Releases). The default install location for software packages is in *$HOME/metapp/*.
```bash
mkdir -p $HOME/test_ecmwf_releases
mkdir -p $HOME/test_ecSource
cp odb_api_bundle-0.15.2-Source.tar.gz $HOME/test_ecmwf_releases/
cp libemos-4.4.2-Source.tar.gz $HOME/test_ecmwf_releases/
cd $HOME/test_ecmwf_releases
gunzip odb_api_bundle-0.15.2-Source.tar.gz
tar -xvf odb_api_bundle-0.15.2-Source.tar
gunzip libemos-4.4.2-Source.tar.gz
tar -xvf libemos-4.4.2-Source.tar
```

### ecBuild (2.4.0)
ecBuild is a set of cmake macros used by other ECMWF software packages.
```bash
cd $HOME/test_ecmwf_releases/odb_api_bundle-0.15.2-Source/ecbuild
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/ecbuild/2.4.0/gnu/
make
make check
make install
```

### eckit (0.14.0)

```bash
cd $HOME/test_ecmwf_releases/odb_api_bundle-0.15.2-Source/eckit
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/eckit/0.14.0/gnu/ -DCMAKE_MODULE_PATH=$HOME/metapp/ecbuild/2.4.0/gnu/share/ecbuild/cmake
make -j 4
make check
make install
```

### metkit (0.3.0)
```bash
cd $HOME/test_ecmwf_releases/odb_api_bundle-0.15.2-Source/metkit
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/metkit/0.3.0/gnu/ -DCMAKE_MODULE_PATH=$HOME/metapp/ecbuild/2.4.0/gnu/share/ecbuild/cmake/ -DECKIT_PATH=$HOME/metapp/eckit/0.14.0/gnu/
make -j 4
make check
make install
```

### libemos (4.4.2)
```bash
cd $HOME/test_ecmwf_releases/libemos-4.4.2-Source
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/libemos/4.4.2/gnu -DGRIB_API_PATH=PATH_TO_GRIBAPI
make
make check
make install
```

## "Main" software packages
These instructions assume you have access to the ODB-API and COPE ECMWF git repositories. The default install location for software packages is in *$HOME/metapp/*.
### odb (40t1.01)
ECMWF maintain a "standalone" version of ODB software that is compiled with cmake. A 40t1 tag, 40t1.01, has been created to support the flavour of ODB used by harmonie-40h1.1.
```bash
cd $HOME/test_ecmwf_releases
git clone https://dui@software.ecmwf.int/stash/scm/odb/odb.git
cd $HOME/test_ecmwf_releases/odb
git pull
git archive --format=tar -o $HOME/test_ecSource/odb-40t1.01-Source.tar --prefix=odb-40t1.01/ 40t1.01
cd $HOME/test_ecSource
tar -xvf odb-40t1.01-Source.tar
cd odb-40t1.01/
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/odb/40t1.01/gnu/ -DCMAKE_MODULE_PATH=$HOME/metapp/ecbuild/2.4.0/gnu/share/ecbuild/cmake/ -DODB_SCHEMAS="ECMA;CCMA"
make -j 8
make check
make install
```

### ODB API (0.15.4)
ODB API is a software developed at ECMWF for encoding and processing of observational data. It includes a SQL filtering and statistics engine, command line tools and APIs for C/C++, Fortran and Python. ODB API works with data format used in ECMWF observational feedback archive. Development of ODB API has been partially funded by the Met Office. More details here: [https://software.ecmwf.int/wiki/display/ODBAPI/ODB+API+Home](https://software.ecmwf.int/wiki/display/ODBAPI/ODB+API+Home)

ODB API provides is required by COPE as well as for ODB2 to ODB1 conversion. 
```bash
cd $HOME/test_ecmwf_releases
git clone https://dui@software.ecmwf.int/stash/scm/odb/odb_api.git
cd $HOME/test_ecmwf_releases/odb_api
git pull
git archive --format=tar -o $HOME/test_ecSource/odb_api-0.15.4-Source.tar --prefix=odb_api-0.15.4/ 0.15.4
cd $HOME/test_ecSource
tar -xvf odb_api-0.15.4-Source.tar
cd odb_api-0.15.4/
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/odb_api/0.15.4/gnu/ -DCMAKE_MODULE_PATH=$HOME/metapp/ecbuild/2.4.0/gnu/share/ecbuild/cmake/  -DECKIT_PATH=$HOME/metapp/eckit/0.14.0/gnu/ -DMETKIT_PATH=$HOME/metapp/metkit/0.3.0/gnu -DENABLE_MIGRATOR=ON -DODB_PATH=$HOME/metapp/odb/40t1.01/gnu -DENABLE_FORTRAN=ON -DENABLE_PYTHON=ON -DENABLE_NETCDF=ON
make -j 8
make check
make install
```

### b2o (40t1.01)
b2o is a library and command line tool to extract ODB data from BUFR files. A 40t1 tag, 40t1.01, has been created to support the flavour of ODB used by harmonie-40h1.1.
```bash
cd $HOME/test_ecmwf_releases
git clone https://dui@software.ecmwf.int/stash/scm/cope/b2o.git
cd b2o
git pull
git archive --format=tar -o $HOME/test_ecSource/b2o-40t1.01-Source.tar --prefix=b2o-40t1.01/ 40t1.01
cd $HOME/test_ecSource
tar -xvf b2o-40t1.01-Source.tar
cd b2o-40t1.01/
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/b2o/40t1.01/gnu/ -DCMAKE_MODULE_PATH=$HOME/metapp/ecbuild/2.4.0/gnu/share/ecbuild/cmake/ -DLIBEMOS_PATH=$HOME/metapp/libemos/4.4.2/gnu/ -DECKIT_PATH=$HOME/metapp/eckit/0.14.0/gnu/ -DODB_API_PATH=$HOME/metapp/odb_api/0.15.4/gnu
make -j 4
make check
make install
```

### COPE
These instructions are based on building the develop branch of COPE. If you wish to use a tagged version you must use version 0.5.3 or greater.
```bash
cd $HOME/test_ecmwf_releases
git clone https://dui@software.ecmwf.int/stash/scm/cope/cope.git
cd $HOME/test_ecmwf_releases/cope
git pull
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/metapp/cope/develop/gnu -DCMAKE_MODULE_PATH=$HOME/metapp/ecbuild/2.4.0/gnu/share/ecbuild/cmake/ -DECKIT_PATH=$HOME/metapp/eckit/0.14.0/gnu/ -DODB_API_PATH=$HOME/metapp/odb_api/0.15.4/gnu -DB2O_PATH=$HOME/metapp/b2o/40t1.01/gnu -DCMAKE_PREFIX_PATH=$HOME/metapp/libemos/4.4.2/gnu/
make -j 4
# make check ## BROKEN DUE TO CHANGES TO ODB SCHEMA IN THIS BRANCH
make install
```

## COPE in HARMONIE system
COPE is currently only available in [branches/harmonie_40h1_cope](https://hirlam.org/trac/browser/branches/harmonie_40h1_cope) and has only been tested on a local Linux server.

The use of COPE in HARMONIE relies on ODB-API, b2o and COPE itself. 
 * ODB-API tools must be included in PATH
 * The ECMA.sch used by COPE is maintained in the b2o version described above. 
 * "mf_vertco_type" specific changes are included in the feature/mf_vertco_type branch of COPE
 * scr/Cope includes the setting of the following environment variables which rely on COPE_DIR and B2O_DIR. These can be set in your Env_system file.
```bash
export COPE_DEFINITIONS_PATH=${COPE_DIR}/share/cope
export ODB_SCHEMA_FILE=${B2O_DIR}/share/b2o/ECMA.sch
export ODB_CODE_MAPPINGS=${B2O_DIR}/share/b2o/odb_code_mappings.dat
export ODBCODEMAPPINGS=${B2O_DIR}/share/b2o/odb_code_mappings.dat
```
