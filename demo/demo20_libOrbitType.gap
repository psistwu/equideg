# # libOrbitType demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "OrbitType" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


# ## Setup
  Print( "=== Setup ===\n" );
  Print( "Take grp = S4 and take its CCSs and irreducible representations.... " );
  grp := SymmetricGroup( 4 );
  ccss := ConjugacyClassesSubgroups( grp );
  irr := Irr( grp );
  Print( "Done!\n\n\n" );


# ## Demo 1: generate orbit type lattices for all irreducible representations
  Print( "=== Demo 1 ===\n" );
  Print( "Compute orbit type lattice of all irreducible representations.... " );
  lat_list := List( irr_list, irr -> LatticeOrbitTypes( irr ) );
  Print( "Done!\n" );

  for i in [ 1 .. Size( irr_list ) ] do
    Print( "Generating dot file for the ", i ,"-th S4-irreducible representation.... " );
    dotfile := Concatenation( "demo20_libOrbitType/S4_irr", String( i ), "_latorbt.dot" );
    DotFileLattice( lat_list[ i ], dotfile );
    Print( "Done!\n" );
  od;
  Print( "(Please check folder ./demo20_libOrbitType)" );
