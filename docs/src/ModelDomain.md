```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ModelDomain?action=edit"
```


## Model Domain

## Introduction
There are four projections available in HARMONIE, polar stereographic, lambert, mercator and rotated mercator. The model itself chooses the best (least distortion) projection among the first three given your domain specifications. The rotated mercator projection is selected through the variable *LROTMER*. Note that the polar stereographic project is defined at 90^o^N(S) whereas in GRIB1 it is defined at 60^o^ N(S).

Polar stereographic, Lambert and Mercator projectionRotated mercator projection
## Model domain settings

For each domain we set variables related to the geometry and the resolution like:

HARMONIE model domains are defined in settings in [Harmonie_domains.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_domains.pm). The following variables related to the geometry and the resolution are required:

 * *TSTEP* is model timestep in seconds
 * *NLON* is number of points in x-direction.
 * *NLAT* is number of points in y-direction.
 * *LONC* is the longitude of domain centre in degrees.
 * *LATC* is the latitude of domain center in degrees.
 * *LON0* is the reference longitude of the projection in degrees.
 * *LAT0* is the reference latitude of the projection in degrees. __If *LAT0* is set to 90, the projection is **polar stereographic**. If *LAT0* < 90, the projection is **lambert** unless LMRT=.TRUE..___  
 * *GSIZE* is grid size in meters in both x- and y-direction.
 * *EZONE* is number of points over extension zone in both x- and y-direction. Default value 11. 
 * *LMRT* switch for rotated Mercator projection. If LMRT=.TRUE. LAT0 should be zero.

*NLON* and *NLAT* should satisfy the equation 5^b^ * 3^d^ * 2^e^, where a-e are integers >= 0.

 * ~~*BDNLON* is number of points in x-direction for intermediate climate file. *BDNLON* > *NLON*.~~
 * ~~*BDNLAT* is number of points in y-direction for intermediate climate file. *BDNLAT* > *NLAT*.~~

The default area is the Denmark domain (DKCOECP). The following values for C+I zone and truncation are calculated in [Harmonie_domains.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_domains.pm) from the values above. 

 * *NDLUXG* is number of points in x-direction without extension (E) zone.
 * *NDGUXG* is number of points in y-direction without extension (E) zone.
 * *NMSMAX_LINE* is truncation order in longitude. By default (*NLON*-2)/2. 
 * *NSMAX_LINE* is truncation order in latitude. By default (*NLAT*-2)/2. 
 * *NMSMAX_QUAD* is truncation order in longitude. By default (*NLON*-2)/3. It is used to create filtered orography with lower resolution.
 * *NSMAX_QUAD* is truncation order in latitude. By default (*NLAT*-2)/3. It is used to create filtered orography with lower resolution.

~~Note that to run with LSPSMORO=yes you have to use a linear grid. I.e. NLON/NLAT must satisfy~~

## Domain creation tool

To help with the design of a new domain, there is an [interactive tool](https://www.hirlam.org/nwptools/domain.html)
that lets you experiment with the grid parameters described above, and visualize the resulting domain immediately
on a map, see figure below.


At present, it only works for Lambert and polar stereographic projection, not rotated mercator.

## Creating a new domain
If you are happy with your new domain created with the help of the domain creation tool you can add it to [Harmonie_domains.pm](https://hirlam.org/trac/browser/Harmonie/scr/Harmonie_domains.pm) for your experiment, my_exp (assuming you have set up the experiment):
```bash
cd $HOME/hm_home/my_exp
PATH_TO_HARMONIE/config-sh/Harmonie co scr/Harmonie_domains.pm
#
# add domain information for new domain called MYNEWDOM in this file
#
vi scr/Harmonie_domains.pm
#
# set DOMAIN=MYNEWDOM in the experiment config file
#
vi ecf/config_exp.h 
```
You can now start a new experiment with a newly defined domain called MYNEWDOM.

## Create a test domain with gl
Before you go through the full climate generation process you can generate a test domain using gl. Define your domain in the namelist like:
```bash
&NAMINTERP
OUTGEO%NLON = 300 ,
OUTGEO%NLAT = 300,
OUTGEO%PROJECTION = 3,
OUTGEO%WEST = 17.0,
OUTGEO%SOUTH = 58.0,
OUTGEO%DLON = 2500.0
OUTGEO%DLAT = 2500.0
OUTGEO%PROJLAT = 60.0
OUTGEO%PROJLAT2 = 60.0
OUTGEO%PROJLON = 0.0,
/
```
Running gl using this namelist by
```bash
gl -n namelist_file
```
will create an GRIB file with a constant orography which you can use for plotting. 
[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


