```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/How_to_use_hires_topography?action=edit"
```

# Harmonie System Documentation
## How to Introduce New High-Resolution Topography into Harmonie

## Introduction

This page describes how to set up and use an ultra-high resolution topographic data set for your Harmonie domain, instead of the current standard GTOPO30 data set.

The data replacing GTOPO30 is likely to be much denser (by a factor of 100 or more), so it probably doesn’t make much sense for each centre to store a complete quasi-global set.  It is much more practical for each centre to generate and store a local sub-set of the high-resolution topography to encompass just their own computational domains. First the principal process is described and in [#DoitallinsideHARMONIE here] the streamlined implementation, with the coarser GMTED2010 data, in the system is summarized.

## Background

The standard topographic data set currently used by Harmonie is the global “GTOP030” set from NASA (http://gcmd.nasa.gov/records/GCMD_NCAR_DS758.0.html ).   This is a “Digital Elevation Model”  (DEM) with a horizontal resolution of 30 arc seconds (approx. 1km).   As Harmonie model configurations start to use grid-sizes of 1km or smaller, the computational grid can have finer resolution than the topographic grid, and so topography becomes a new limiting factor in the full model resolution.  

It is possible now to overcome this limitation of the relatively coarse GTOPO30 topography by replacing it with a much finer-scale DEM.  One such DEM representation of the earth’s surface has been available since Oct. 2011.  This is version 2 of the DEM derived from the Aster instrument on board the Terra satellite, as part of the collaboration between Japan’s Ministry of Economy, Trade and Industry (METI), and NASA in the U.S.  In the Aster dataset, surface elevations are reported at a horizontal resolution of approx. 30m. Thus the Aster data is about 900 times denser than GTOPO30, i.e., has about 30 times higher resolution in each horizontal dimension.  The average error in the vertical elevation estimates is approx. 6-10m (I think of this as the typical height of a tree or a house – the kind of things that can confuse the satellite radiometer into reporting a false surface elevation).  

More information about the Aster DEM is available at http://asterweb.jpl.nasa.gov/gdem.asp .  

Even for “relatively” coarse Harmonie grids (perhaps even 2.5km meshes), the “slope”, “roughness”, “silhouette” and other physical attributes of the topography used by Harmonie can be provided much more accurately by Aster data than by GTOPO30.

## Obtaining ASTER high-resolution DEM data

The data are publicly and freely available from NASA’s “reverb” web-site (http://reverb.echo.nasa.gov/reverb/).   Since the resolution is so fine, the complete dataset is quite voluminous: the compressed file for each 1^o^ x 1^o^ (longitude-latitude) tile or “granule” at 50^o^ N is about 15MB if totally land-covered.  To obtain the data you want:

 1. Draw a bounding rectangle around your domain of interest (even all of Europe!) at that “reverb” web-site;
 2. Select“ASTER Global Digital Elevation Model V0002” from the list of data sets further down the same web-page;
 3. Click the “Search for Granules” box at the bottom of the page.

From here you will be brought through a standard registration process familiar to anyone who has ever bought a train ticket online – the main difference being that the Aster data are free.   Once registration is complete, you should receive an email after 1-2 days telling you that your data is ready, and how you can ftp it to your own computer.  

I obtained 97 “granules” of such data (i.e., DEM files for an area approximately 1^o^ square), covering the islands of Ireland and the UK (14^o^ longitude x 11^o^ latitude).  The 57 “missing” granules are simply ocean regions that encompass no land at all.  No granules are provided for any 1-degree tile that is completely over the open ocean, since sea-level elevation is assumed to be zero.   Each granule is a separate zip file, varying in size up to about 15MB, depending on the fraction of land area in each 1-degree tile and the complexity of the topography itself.  Granules are identified by the latitude and longitude of the southwest (lower-left) corner (or more precisely, of the geometric centre of the southwest corner pixel), which is given in the file-name.  

## Processing the Raw Aster Data

Each “granule” of data is a zip file that unzips to 2 “tiff” files (`ASTGM2_*_dem.tif`, containing the actual data, and `ASTGM2_*_num.tif`, containing “quality assessment”), along with a generic README.pdf.

The Quality Assessment files (*num.tif) contains the number of “stereo scene pairs” used to determine elevation at each pixel (if positive) or the source of non-ASTER elevation data used to 
replace bad ASTER DEM (if negative).  Values less than 5 are associated with relatively larger errors in the elevation measurement.  Larger values are associated with more accurate final estimates of surface elevation.

This information can help to identify those regions where the Aster values may need to be merged or replaced with elevation data from some other source.

For the purposes of formatting the DEM data for Harmonie, the first step is to extract the (longitude, latitude, elevation) triplet for each “pixel” (or  “grid-point”) from the `ASTGM2_*_dem.tif`  files.  

This can be done using software such as the Geospatial Data Abstraction Library (**GDA**L) open-source tools, available from http://www.gdal.org.  Once installed, these can be used to read, merge, and otherwise manipulate geoTIFF files.

The command I used to generate a simple text file containing longitude, latitude and elevation from an `ASTGM2_*_dem.tif` file is, e.g.,

```bash
gdal_translate –of XYZ ASTGM2_N59W006_dem.tif ASTGM2_N59W006_xyz.txt
```

This fills the ascii output file  `ASTGTM2_N59W006_xyz.txt` with rows of (longitude, latitude, elevation) values, starting from the northwest (top-left) corner (-6, 60), and proceeding eastwards to (-5,60), then moving south to the next row, ending up at the southeast (bottom-right) corner (-5,59).  Each output text file contains 3601 x 3601 data-points, i.e., 12,967,201 rows, and uses over 550 MB of storage.  Note that the various granules overlap each other at the boundaries (the line of boundary data is included in each bounding file).  Elevation is in units of metres.

This is relatively straightforward and only needs to be done once for each file,  even if there may be more efficient ways to do it.

The command above can easily be scripted to process the full collection of `*dem.tif` files:

```bash
for i in $( ls ASTGTM2_*_dem.tif ); do
  gdal_translate -of XYZ $i $i.xyz
done
```

To obtain some information about any particular tif file, use the **gdalinfo** command.  

Next, the data from each separate 1^o^ x 1^o^ text file were combined into a single flat unformatted little-endian binary file consisting of surface elevation every 30m or so encompassing the entire Harmonie domain.  For an Ireland/UK domain, bounded between latitudes 49 and 60 deg. N, and between longitudes 11 deg. W and 3 deg. E, this contains approx. 40,000 (latitude) x 50,000 (longitude) data points – or about 2 billion points altogether.  (2 billion points stored in 2-byte integer format use about 4GB of storage).  A domain like this can easily be extended to the west and north, where there is no land and where sea-level elevation is simply zero.  In order to extend it to the south or east, however, where there is land, extra Aster granules would be required.  See the attached standalone program (or [wiki:hires_topog_gather_tiles.f]) for the details of what I did (crude but effective; nothing fancy and probably not the best way, but simple and it works).  The file is written with the first element at the northwest corner, progressing eastwards, then south, with the last element at the southeast corner.

## Errors and Data Gaps

I did not notice any gaps or "bad data" in the Aster topography over Ireland and the UK, but there do seem to be some gaps, negative pixels or positive "spikes" elsewhere, esp. over Scandanavia and other high latitudes.  The "quality assessment" numbers in the `ASTGM2_*_num.tif`files mentioned above can help to identify bad or dubious elevation values.  Nicolas Bauer (FMI) has a procedure for detecting and correcting these.  

## Formatting topographic data for use by Harmonie

The main topographic data files used by Harmonie are in `$HM_CLDATA/PGD`, and are called `gtopo30.hdr` and `gtopo30.dir` .  In principle, all that is required now is to replace these 2 files (containing GTOPO30 data) with equivalent files containing Aster data.  There is no need to change the file names or to edit any Harmonie source code – just create new files with the old names, and containing Aster instead of GTOPO30 data.

The `gtopo30.hdr` file is the “header” file, containing meta-data about the main data file (`gtopo30.dir`).   The header file contains all the information needed by the MASTERODB executable to read in the real data from the `gtopo30.dir` file, and to use it appropriately within the rest of Harmonie.   The original `gtopo30.hdr` file contains:

```bash
GTOPO30 orography model, rewritten by V. Masson, CNRM, Meteo-France, 16/07/98
nodata: -9999
north: 90.
south: -90.
west: -180.
east: 180.
rows: 21600
cols: 43200
recordtype: integer 16 bytes
```

Note that this file specifies a global domain.  To use Aster data for the Ireland/UK domain, this content ended up being replaced with:

```bash
ASTER orography model, starting UL
nodata: -9999
north: 60
south: 49
west: -11
east: 3
rows: 39601
cols: 50401
recordtype: integer 16 bits
```


While the number of rows and columns is about the same as before, the topographic domain is much smaller.

In the Harmonie source, the key files that are involved in reading and parsing the `gtopo30.hdr` and `gtopo30.dir` files are `surfex/pgd/zoom_pgd_orography.F90` and `surfex/aux/read_direct.F90`.  Parsing these files reveals  what is needed to write `gtopo30.hdr` and `gtopo30.dir` files containing Aster data.  I wrote another simple program to do this, based largely on programs already written by Nicolas Bauer and Imanol Guerrero, and provided by Laura Rontu.   This program is available as attachement, or at:  [wiki:hires_convert.f] .

The part of this file that writes the header data is:

```bash
!    Header file for harmonie:
       open(unit=23,file="hires_irluk_hm.hdr",form='formatted',
     &      status='new',IOSTAT=ios)
            write(23,FMT='(A)') "GTOPO30 orography model, starting UL"
            write(23,FMT='(A)') "nodata: -9999"
                  write(caux,*) north
            write(23,FMT='(A)') "north: "//adjustl(trim(caux))
                  write(caux,*) south
            write(23,FMT='(A)') "south: "//adjustl(trim(caux))
                  write(caux,*) west
            write(23,FMT='(A)') "west: "//adjustl(trim(caux))
                  write(caux,*) east
            write(23,FMT='(A)') "east: "//adjustl(trim(caux))
                  write(caux,*) npts_ns
            write(23,FMT='(A)') "rows: "//adjustl(trim(caux))
                  write(caux,*) npts_ew
            write(23,FMT='(A)') "cols: "//adjustl(trim(caux))
            write(23,FMT='(A)') "recordtype: integer 16 bits"
```

The character variable “caux” is used here as an “internal” file to hold the various domain parameters corresponding to the Aster data.

The main DEM data file is written in integer*2 format to the new `gtopo30.dir` file, as in:

```bash
      integer*2, allocatable :: elev_hm(:,:)
      integer*2                   ::  idata
      character*2                :: cdata, ctmp
      equivalence (idata,cdata)
...   
      allocate (elev_hm(npts_ew,npts_ns))
!  Start of main (outer) loop:
       do j=1,npts_ns
          read(21) elevation
          elev_hm(:,j) = elevation(:)
       enddo
          close(21)
          deallocate(elevation)

!  So now elev_hm should be filled.

!  Byte-swap from little to big-endian (for sake of Harmonie build...):
       do j=1,npts_ns
          do i=1,npts_ew
              idata = elev_hm(i,j)
              ctmp(1:1) = cdata(1:1)
              cdata(1:1) = cdata(2:2)
              cdata(2:2) = ctmp(1:1)
              elev_hm(i,j) = idata
          enddo
       enddo

       open(unit=24,file="gtopo30.dir",form="unformatted",
     &      access="direct",recl=npts_ns*npts_ew*2,status="new",err=999)

!  Write starting from NW corner, working east, then south one row:
        write(24,rec=1) ((elev_hm(i,j),i=1,npts_ew), j=1,npts_ns)
```

Note the explicit conversion to big-endian (so no “`-convert big-endian`” compiler flag should be used with this).   

Note too that when using Intel compilers, the “`-assume byterecl`” option must be used so that record lengths are in bytes instead of (4-byte) words.

Once those simple programs are run to perform straightforward file-format conversions, the resulting gtopo30.hdr and gtopo30.dir files (containing Aster data) can be used directly in $CLDATA/PGD in place of the original “real” ones (containing GTOPO30 data). 
Those files are read by Harmonie during the “Climate” phase, and generate reference “climate” files PGD.lfi and PGD.fa.  These remain constant and are not generated again for each Harmonie installation.  They are read in by the surfex module during each Forecast phase, and used wherever surface topographic data is needed.

## Do it all inside HARMONIE

We discovered that there are a lot of "holes" in the ASTER data over Scandinavia, so instead we focused on the GMTED2010 data set (http://topotools.cr.usgs.gov/gmted_viewer/). This almost global dataset is compiled of different high resolution DEM sources and the highest available resolution is 7.5 arc seconds (~250 meters). It is used by Meteo-France for their 1.3 km domain. This data also comes in tiles of big tif-files like the ASTER data so a similar method described above can be used on this dataset. The different tiles cover an area that is 30 by 20 degrees longitude/latitude. There are no valid data north of 84 degrees north and south of 56 degrees south. The two steps described above have been streamlined in harmonie-40h1 and the main tasks have been gathered in Prepare_gmted which is called from Prepare_pgd. What's required from the user is to download (http://topotools.cr.usgs.gov/gmted_viewer/viewer.htm) the GMTED2010 data and locate them in the appropriate location and point the following variable in Env_system to the location:
```bash
   export GMTED2010_INPUT_PATH=/project/hirlam/harmonie/climate/GMTED2010
```

To use the GMTED2010 data and not GTOPO30 we have to define the input source, once again in ecf/config_exp.h .

```bash
   TOPO_SOURCE=gmted2010
```

The Prepare_gmted script checks for the chosen domain size and selects the necessary tiles and then combines them together into one geotiff file under $CLIMDIR. Small python script tif2bin.py then converts the new geotiff to the binary (dir/hdr) format needed for PGD generation.

On cca (ECMWF) the following input files are available under /project/hirlam/harmonie/climate/GMTED2010:

```bash
 10N030W_20101117_gmted_mea075.tif
 30N030E_20101117_gmted_mea075.tif
 30N000E_20101117_gmted_mea075.tif
 30N030W_20101117_gmted_mea075.tif
 30N060W_20101117_gmted_mea075.tif
 30N090W_20101117_gmted_mea075.tif
 50N030E_20101117_gmted_mea075.tif
 50N000E_20101117_gmted_mea075.tif
 50N030W_20101117_gmted_mea075.tif
 50N060W_20101117_gmted_mea075.tif
 50N090W_20101117_gmted_mea075.tif
 70N030E_20101117_gmted_mea075.tif
 70N000E_20101117_gmted_mea075.tif
 70N030W_20101117_gmted_mea075.tif
 70N060W_20101117_gmted_mea075.tif
 70N090W_20101117_gmted_mea075.tif
```


## Tests of Aster vs. GTOPO30 Topography

The images below shows the topography of the Burren, a hilly region in the west of Ireland, approx. 30km square, as represented by GTOPO30 (top) and Aster (bottom).  The extra detail provided by Aster is apparent.  The segments of straight line represent the coastline as plotted by the GrADS "hires" map.


The difference fields of surface winds and sea-level pressure between a Harmonie run using GTOPO30 PGD files and another Harmonie run using PGD files from the Aster topography are shown in the image below.  Both runs were at 0.5km resolution over a West of Ireland domain, and the difference fields were taken after a 24hr forecast.  The only difference between these two runs was the PGD.lfi and PGD.fa topographic files used as input – or more precisely, between the topographic datasets used to generate those 2 PGD files.  


The first point to emphasize about this chart is that the differences are very small: the scale on the right is in units of 0.02hPa, and maximum sea-level pressure difference is only about 0.1hPa in magnitude (though it can be of either sign), and surface wind-speed differences are no larger than 0.4m s^-1^.  So refining the PGD topography has a relatively small impact on the overall forecast.  The main feature of the sea-level pressure difference field is the wave-train originating in the mountains of Connemara and propagating downstream eastwards.  The slight difference in representation of those mountains between GTOPO30 and Aster is enough to generate that weak but surprisingly coherent wave-train.  

The topographic input used by the “Aladin” part of Harmonie (from Oro_Mean, Nb_Peaks, and other files) were unchanged for these runs.  

## What about the Aladin Topography Files (Oro_Mean, etc.)?

The directory $HM_CLDATA/GTOPT030 contains 9 files, 7 of which are derived in some way from the full GTOPO30 topography data set:



|=  File 			=|=		Field 					=|=	  Unit =|=  Nb bits =| 
| --- | --- | --- | --- |
| Oro_Mean 		|  Mean orography (mean of Hmean)       |      m     |  16  | 
| Sigma 			|		Sub-grid std dev of Hmean 	|	 m 	|  16  |
| Nb_Peaks 			|      Number of sub-grid peaks 	|		|   8   |
| Hmax-HxH-Hmin_ov4 	|     mean of (Hmax-Hmean)(Hmean-Hmin)/4 |  m^2^ 	|  32  |
| Dh_over_Dx_Dh_over_Dy  |   mean of dHmean/dx x dHmean/dy  |   m^2^ km^-2^  |  32  | 
| Dh_over_Dx_square 	|      mean of (dHmean/dx)^2^ 		|	 m^2^ km^-2^   |  32  |
| Dh_over_Dy_square 	|	mean of (dHmean/dy)^2^	                |     m^2^ km^-2^     |  32  |
| Water_Percentage 		|	Land/Sea mask 	|				 % water |  8  |
| Urbanisation 		|	Fraction of urbanisation  	|		 % city  |   8  |

2 of the files (Urbanisation, Water_Percentage) are from a NOAA/Navy Global95 dataset and are not related to GTOPO30 at all.  

The other 7 files each contain information derived from 5x5 sub-grid boxes of the main gtopo30.dir.  (So each is 25 times smaller than gtopo30.dir, accounting for data-type).

The word "mean" in the table above means "averaged over the GTOPO30 pixels contained in one 2'30" box (usually 5x5 GTOPO30 pixels)".   

All these files are read in by `ald/c9xx/eincli1.F90` .  At run-time, the files are only read during the "Climate" phase of each run, and the information in them ultimately written out to the m01, m02, etc. monthly files.

After that, however, these files have no effect whatsoever on Forecast output.  

If the 7 secondary GTOPO30 files above are replaced with equivalent ones generated from Aster data, they are read during the "Climate" phase and embedded into m01, m02, etc., but then forecast runs that use these generate output that is bit-wise identical to that produced by a "control" executable (and "control" m01, etc.) based on GTOPO30.  (Originally, I found some very small differences in output between my "Aster" and "GTOPO30" runs, but that must have been due to me changing something too much in my "Aster" executable, which necessarily uses modified eincli1.F90 and einter1.F90 input files, or not using a totally "clean slate" of input files to start with).

So those 9 derived files in $HM_CLDATA/GTOPT030 are ultimately redundant, and there is no point replacing them with equivalent ones based on high-resolution Aster topography.

## Comment Laura Rontu 21 July 2013 

In my understanding, the 7 secondary files are used to derive the following three fields in m01 etc. (example from gl listing of some m01):

```bash
 SURFET.GEOPOTENT> 001:220-00000-105@   10115_00:00+0000 000 Standard deviation of orograph   0.000E+000  195.020E+000    4.812E+003  326.546E+000
 SURFVAR.GEOP.ANI> 001:221-00000-105@   10115_00:00+0000 000 Anisotropy coeff of topography   0.000E+000  542.720E-003    1.000E+000  313.600E-003
 SURFVAR.GEOP.DIR> 001:222-00000-105@   10115_00:00+0000 000 Direction of main axis of topo  -1.571E+000   96.202E-003    1.939E+000  661.270E-003
```

These are used by the ALADIN/ALARO buoyancy wave parametrization for generation and dissipation of subgrid-scale waves due to orography. Such a parametrization is not applied in AROME, thus these fields are not used there and do not have any influence on AROME results. However, these or similar variables can be found also in the PGD file, among other orography-related variables derived from GTOPO30 (another example of gl listing of some PGD.lfi):

```bash
 ZS              > 001:008-00000-105@20051219_00:00+0000 000 Oro hgt.     0.000E+000  137.923E+000    1.354E+003  152.975E+000
 AVG_ZS          > 001:001-00600-105@20051219_00:00+0000 000 Average oro     0.000E+000  137.923E+000    1.436E+003  154.681E+000
 SIL_ZS          > 001:002-00600-105@20051219_00:00+0000 000 Silhouette oro     0.000E+000  150.633E+000    1.575E+003  168.821E+000
 SSO_STDEV       > 001:005-00600-105@20051219_00:00+0000 000 Stdv SSO    -0.000E+000   16.335E+000  435.020E+000   24.560E+000
 MIN_ZS          > 001:003-00600-105@20051219_00:00+0000 000 Min subgrid oro     0.000E+000  119.170E+000    1.250E+003  136.836E+000
 MAX_ZS          > 001:004-00600-105@20051219_00:00+0000 000 Max subgrid oro     0.000E+000  162.376E+000    1.776E+003  181.778E+000
 SSO_ANIS        > 001:006-00600-105@20051219_00:00+0000 000 Aniso SSO     0.000E+000  543.880E-003    1.000E+000  194.160E-003
 SSO_DIR         > 001:007-00600-105@20051219_00:00+0000 000 Direction SSO   -90.000E+000   29.056E+000   90.000E+000   40.999E+000
 SSO_SLOPE       > 001:008-00600-105@20051219_00:00+0000 000 Slop SSO     0.000E+000   28.708E-003  718.360E-003   41.450E-003
 HO2IP           > 001:009-00600-105@20051219_00:00+0000 000 h/2 i+     0.000E+000    6.905E+000  274.755E+000   11.246E+000
 HO2JP           > 001:010-00600-105@20051219_00:00+0000 000 h/2 j+     0.000E+000    7.030E+000  290.501E+000   11.472E+000
 HO2IM           > 001:011-00600-105@20051219_00:00+0000 000 h/2 i-     0.000E+000    6.964E+000  256.012E+000   11.534E+000
 HO2JM           > 001:012-00600-105@20051219_00:00+0000 000 h/2 j-     0.000E+000    7.190E+000  352.647E+000   11.734E+000
 AOSIP           > 001:013-00600-105@20051219_00:00+0000 000 A/S i+     0.000E+000    8.055E-003  548.990E-003   14.087E-003
 AOSJP           > 001:014-00600-105@20051219_00:00+0000 000 A/S j+     0.000E+000    8.297E-003  461.020E-003   14.306E-003
 AOSIM           > 001:015-00600-105@20051219_00:00+0000 000 A/S i-     0.000E+000    8.280E-003  521.020E-003   14.863E-003
 AOSJM           > 001:016-00600-105@20051219_00:00+0000 000 A/S i-     0.000E+000    8.454E-003  471.930E-003   15.079E-003
```

Presently, derivations are done automatically, so there is nothing to worry for the user from the point of view of technical implementation. However, eventually there are needs for further development and improvements when the high-resolution source data on topography will be used.
 

## Conclusion

In order to replace the (relatively) coarse-resolution GTOPO30 topography with higher-resolution data (e.g., from Aster), it is enough to generate replacements for the `gtopo30.hdr` and `gtopo30.dir` files in the `$HM_CLDATA/PGD` directory, as described in the upper part of this page.