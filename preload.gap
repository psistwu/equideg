# # preload
#
# The script setup paths and reads required libraries.
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # setup paths
  GAPEL_PATH := Directory( "../" );
  MakeReadOnlyGlobal( "GAPEL_PATH" );

  # read libraries
  if IsBound( LIB_LIST ) then
    for lib in LIB_LIST do
      fname := Concatenation( "lib", lib, ".g" );
      Print( "Loading ", fname, " .... " );
      Read( Filename( GAPEL_PATH, fname ) );
      Print( "Done!\n");
    od;
    Unbind( fname );
    Unbind( lib );
  fi;
  Print( "Preloading is complete.\n\n" );
