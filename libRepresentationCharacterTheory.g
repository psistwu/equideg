#-------
# GAP: Representation and Character Theory Library
#-------
# This library provides functions for representation and character theory.
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update: 2016-11-27
#-------

# dependency
  LoadPackage( "repsn" );
  Read( "/home/psist/Development/lib/gap/libBasicGroupTheory.g" );
# => Read( "/home/psist/Development/lib/gap/libSys.g" );

# read declaration file
  Read( "/home/psist/Development/lib/gap/libRepresentationCharacterTheory.gd" );

# read implementation file
  Read( "/home/psist/Development/lib/gap/libRepresentationCharacterTheory.gi" );

