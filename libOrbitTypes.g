#-------
# GAP: Lattice of Orbit Types Library
#-------
# This library provides functions for
# finding lattice of orbit types of
# a given group representation
#
# Author: Hao-pin Wu <hxw132130@utdalls.edu>
# Last update: 2016-11-27
#-------

# dependency
  Read( Filename( GAPEL_DIR, "libBasicGroupTheory.g" ) );
# => Read("/home/psist/Development/lib/gap/libSys.g");

# include declaration file
  Read( Filename( GAPEL_DIR, "libOrbitTypes.gd" ) );

# include implementation file
  Read( Filename( GAPEL_DIR, "libOrbitTypes.gi" ) );

