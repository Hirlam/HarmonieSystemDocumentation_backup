```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ClimateSimulation?action=edit"
```


# How to run a Climate simulation with Harmonie

**Introduction**
Harmonie for climate applications is available from the trunk (cycle37).
In climate mode, the model makes montly restarts. Only historical simulations driven by ERA-Interim have been made so far.
SST is forced as a lower boundary and is updated at the same time as the lateral boundaries.

**Experiment Settings**
In ecf/config_exp.h  a few changes are made.

* SIMULATION_TYPE=climate
* BDSTRATEGY=era
* No assimilation
* Set BDDIR to your BD location

Start the experiment in the same way as NWP e.g Harmonie start DTG=2012010100 DTGEND=2012060100

**Nested runs**
SURFEX is used in all climate simulations so HOST_SURFEX has to be true.
Use SURFEX_PREP to interpolate SURFEX data to the inner domain.

* HOST_SURFEX="yes"
* BDSTRATEGY=same_forecast
Optional
* SURFEX_PREP="yes"

**Ongoing work**
In SURFEX there are some settings that are not tested but planned to be used as default values.

* FLake
* 3-L snow scheme
* CISBA=DIF

Atmosphere
* Use RCP in scenarious
* Forced by EC-Earth

**NetCDF with gl**
There is a possibilty to convert FA-files to netcdf with gl. The code is still under development but a first test can soon be found in trunk. 
We aim to use the CF1.4 convention.


[Back to the main page of the HARMONIE System Documentation](../HarmonieSystemDocumentation.md)
----


