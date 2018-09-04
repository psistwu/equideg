# # GAP: Representation and Character Theory Library
#
# Synopsis:
# This library provides functions for representation and character theory.
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#
# Dependency:
# => libGroupTheory.g
# => libSys.g
  LoadPackage( "repsn" );
#


# ## Declaration file
  Read( Filename( GAPEL_PATH, "libRepsnCharTheory.gd" ) );

# ## Implementation file
  Read( Filename( GAPEL_PATH, "libRepsnCharTheory.gi" ) );

