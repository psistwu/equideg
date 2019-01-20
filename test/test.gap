# # Lie Group Test
#
# Test of Lie group functions in libGroup
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  LoadPackage( "EquiDeg" );

  x := X( Integers, "x" );

  f := x^-2+x^-1+x;
  Print( Degree( f ) );
