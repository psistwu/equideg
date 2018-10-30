# # Lie Group Test
#
# Test of Lie group functions in libGroup
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );

  # generate a set and its power set
  S := [ 1, 2, 3 ];
  P := Combinations( S );
  SS := [ 1, 9, 4, 2, 5 ];
