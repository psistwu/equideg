# # libOrbitType demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "OrbitType" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


# ## Demo 1: generate lattices of orbit types of all irreducible $(S_4)$-representations
  Print( "=== Demo 1 ===\n" );
  grp := SymmetricGroup( 4 );
  ccs_list := ConjugacyClassesSubgroups( grp );
  irr_list := Irr( grp );
  lat_list := List( irr_list, irr -> LatticeOrbitTypes( irr ) );
  for i in [ 1 .. Size( irr_list ) ] do
    Print( "Generating dot file for the ", i ,"-th S4-irreducible representation.... " );
    dotfile := Concatenation( "demo20_libOrbitType/S4_irr", String( i ), "_latorbt.dot" );
    DotFileLattice( lat_list[ i ], dotfile );
    Print( "Done!\n" );
  od;
  Print( "(Please check folder ./demo20_libOrbitType)" );
