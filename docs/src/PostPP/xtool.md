```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PostPP/xtool?action=edit"
```

# Post processing with xtool

## xtool

**Xtool**, part of the **gl** package, provides a utility to calculate differences between GRIB/FA files and produce the result in a new GRIB file. See xtool part of [gl-README](https://hirlam.org/trac/browser/Harmonie/util/gl/README#L221). The main commands are:

```bash
 
                          xtool                                 
 
 Simple usage:                                                  
  xtool -f1 FILE1 [ -fN FILEN] -op OPERATOR [ -o OFILE]       
  i.e. apply OPERATOR on FILEN and output to OFILE              
  operator is one of SUM/DIFF/AVE/STDV/RMS/MS                      
  1 file : SUM/AVE/SQR                                          
  2 files: SUM/AVE/PROD/DIFF/RMSE/STDV/SAL                      
  3 files: DIFF/SAL                                             
 
 Accumulated usage:                                             
  xtool -sdtg1 YYYYMMDDHH -edtg1 YYYYMMDDHH -ll1 LLL -ll2 LLL \ 
        -p1 PATH1 -p2 PATH2 -fcint HH -op OPERATOR              
  i.e. accumulate OPERATOR on FILE1 and FILE2 during the period 
  sdtg1 to edtg1 with step of fcint.                            
  sdtg2/edtg2=sdtg1/edtg2 - (LL1-LL2) unless given              
 
 Time information in the path should be given as                
  -p1 /data/test/fc@YYYY@@MM@@DD@@HH@+@LLL@ or something like   
  -p2 /data/@YYYY@/@MM@/@DD@/@HH@/fc@YYYY@@MM@@DD@_@HH@+@LLL@   
 
 Different parameters can be compared by using the xkey         
 variable in the namelist                                       
 
 Flag summary :                                                 
  -h                : Print this help                           
  -fN FILE          : Single file name                          
  -pN PATH          : Path name                                 
  -sdtgN YYYYMMDDHH : Start date/time                           
  -edtgN YYYYMMDDHH : End date/time                             
  -llN LLL          : Forecast length to use                    
  -fcint HH         : Forecast cycle interval in hours          
  -iN               : format of the input file GRIB/FA          
  -s                : Run silent                                
  -of               : Output format GRIB/FA/SCREEN              
  -g                : Prints ksec/cadre/lfi info                
  -p                : Use FA file without extension zone        
  -f                : Global FA switch                          
  -a FILE           : Accumulation file to be read              
  -n namelist       : Use namelist to set additional options    
  -igd              : Set lignore_duplicates=F                  
  -r VALUE          : Rescale the output with a constant VALUE  
 
```


## DIFF
One of the things xtool is useful for is to check if the result from two different experiments differ. This is done by applying the DIFF operator and writing the output to the screen like

```bash
 xtool [-f] -f1 FILE1 -f2 FILE2 -of SCREEN
```

The is heavily used in the [Harmonie testbed](../../HarmonieSystemDocumentation/Evaluation/HarmonieTestbed.md) to check the difference between versions of the system.

Below is a simple example of how to use **xtool**. You may also check the [field extraction](https://hirlam.org/trac/browser/Harmonie/scr/Fldver) to find examples. 

 What is the difference between +24h and +48h MSLP forecasts during August 2008?

 1. Namelist for **xtool**, which lists the parameters (here mean sea level pressure) to be examined:

```bash
&NAMINTERP
  PPPKEY%ppp = 001,
  PPPKEY%lll = 000,
  PPPKEY%ttt = 103,
/
```

 2. Run xtool.

```bash
xtool -sdtg1 2008080100 -edtg1 2008083000 -ll1 48 \
      -sdtg2 2008073100 -edtg2 2008082900 -ll2 24 \
      -p1 /your_model_data/YYYY/MM/HH/fcYYYYMMDD_HH+LLL \
      -p2 /your_model_data/YYYY/MM/HH/fcYYYYMMDD_HH+LLL \
      -fcint 6 -op DIFF -n your_namelist \
      -o output.grb
```

  * **-sdtg1**, **-edtg1**, **-ll1**: The cycles to look for the +48h forecast.
  * **-sdtg2**, **-edtg2**, **-ll2**: The cycles to look for the +24h forecast.
  * **-p1**, **-p2**: Naming rules for the files in cycle 1 and 2, respectively.
  * **-fcint**: Interval between forecast cycles.
  * **-op**: Operation to be applied. Possible choices *DIFF*, *SUM*, *AVE*, *STDV* or *SAL*
  * **-n**: Namelist file.
  * **-o**: Name of the output grib file.

 3. Output file (**output.grb**) now contains one 2D-field with accumulated 48-24h difference of mean sea level pressure.  

## SAL

**S**tructure **A**mplitude **L**ocation (**SAL**) is object based quality measure for the verification of QPFs ([Wernli et al., 2008](http://ams.allenpress.com/perlserv/?request=get-abstract&doi=10.1175%2F2008MWR2415.1)). **SAL** contains three independent components that focus on Structure, Amplitude and Location of the precipitation field in a specified domain. 

 * **S**: Measure of structure of the precipitation area (-2 - +2). Large **S**, if model predicts too large precipitation areas.
 * **A**: Measure of strength of the precipitation (-2 - +2). Large **A**, if model predicts too intense precipitation.
 * **L**: Measure of location of the precipitation object (0 - +2). Large **L**, if modelled precipitation objects are far from the observed conterparts. 

 * **SAL** can be activated in **xtool** by using *-op SAL* option. e.g.

```bash
 xtool -f1 model.grib -f2 observation.grib -op SAL -n namelist
```

 * Output of the **SAL** are 2 simple ascii-files:
  1. *scatter_plot.dat* containing date, **S**,**A** and **L** parameters.
  2. *sal_output.dat* containing more detailed statistics collected during the verification (location of center of mass, number of objects, measure of object size etc.).

