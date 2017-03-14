#-------
# GAP: Group Direct Product Library
#-------
# This library provides functions
# for finding and describing
# subgroups and subconjugacies
# in Direct Prodcut of Groups
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update: 2016-11-27
#-------

# dependency
  Read( Filename( GAPEL_DIR, "libBasicGroupTheory.g" ) );
# => Read( Filename( GAPEL_DIR, "libSys.g" ) );

# include declaration file
  Read( Filename( GAPEL_DIR, "libGroupDirectProduct.gd" ) );

# include implementation file
  Read( Filename( GAPEL_DIR, "libGroupDirectProduct.gi" ) );

