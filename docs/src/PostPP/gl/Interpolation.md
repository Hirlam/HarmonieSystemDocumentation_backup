```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PostPP/gl/Interpolation?action=edit"
```


# Interpolations with gl

## Introduction

In the following we describe the geometrical routines in gl. gl can handle the following projections

 * lat/lon
 * Rotated lat/lon
 * Lambert
 * Polar stereographic
 * Rotated Mercator

## Interpolation

 All interpolations are handled within the module [module_interpol.f90](https://hirlam.org/trac/browser/Harmonie/util/gl/mod/module_interpol.f90). The module contains 

 * clear_interpol to clear the interpolation setup
 * setup_interpol where the position of the output gridpoints in the input grid are calculated
 * setup_weights where we calculate the interpolation weights. Interpolation can be nearest gridpoint or bilinear. The interpolation can be masked with a field
   that tells which gridpoints from the input fields that can be used. 

 The setup routines are only called once.

 * interpolate runs the interpolation
 * resample works like the interpolation if the input grid is coarser than the output grid. If reversed it takes the averages of the input gridpoints belonging to each output gridpoit.

 Interpolation can be done between different projections as wall as to geographical points. The most general exmple on the usage of the interpolatin can be found in  [any2any.F90](https://hirlam.org/trac/browser/Harmonie/util/gl/grb/any2any.F90).

 For practical usage see the section about [postprocessing](../../../HarmonieSystemDocumentation/PostPP/gl.md)


## Rotations

 All rotations are handled within the module [module_rotations.f90](https://hirlam.org/trac/browser/Harmonie/util/gl/mod/module_rotations.f90). The module contains 

 * clear_rotation to clear the rotation setup
 * prepare_rotation prepare rotations from input geometry to output geometry via north south components.
 * rotate_winds runs the actual rotation.

## Staggering

 The staggering of an input file is based on the knowledge about the model and is set [here](https://hirlam.org/trac/browser/Harmonie/util/gl/mod/module_griblist.f90). 
 The restaggering is done in [restag.f90](https://hirlam.org/trac/browser/Harmonie/util/gl/grb/restag.f90) as a simple average between gridpoints. The staggering of the output geomtery
 is defined by `OUTGEO@ARKAWA`, where A and C are available options.


[Back to the main page of the HARMONIE System Documentation](../../../HarmonieSystemDocumentation.md)
----


