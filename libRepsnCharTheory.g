# GAP: Representation and Character Theory Library #

### Synopsis ###
#---
# This library provides functions for representation and character theory.
#---

### Author ###
#---
# Hao-pin Wu <hxw132130@utdallas.edu>
#---

### Dependency ###
  LoadPackage( "repsn" );
#---
# => libBasicGroupTheory.g
# => libSys.g
#---

### Declaration file ###
  Read( Filename( GAPEL_DIR, "libRepsnCharTheory.gd" ) );

### Implementation file ###
  Read( Filename( GAPEL_DIR, "libRepsnCharTheory.gi" ) );

