#-------
# GAP: 2-transitive Group Library
#-------
# This library provides functions
# for identifying 2-transitive
# groups and representations
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update: 2016-11-27
#-------

# dependency
  Read( Filename( GAPEL_DIR, "libBasicGroupTheory.g" ) );
# => Read( Filename( GAPEL_DIR, "libSys.g" ) );

# include declaration file
  Read( Filename( GAPEL_DIR, "lib2transitiveGroup.gd" ) );

# include implementation file
  Read( Filename( GAPEL_DIR, "lib2transitiveGroup.gi" ) );

