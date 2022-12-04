# # libOrbitType demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  LoadPackage( "EquiDeg" );

# ## Setup
  Print( "=== Setup ===\n" );
  Print( "Take grp = S4 and take its CCSs and irreducible representations.... " );
  grp := SymmetricGroup( 4 );
  ccss := ConjugacyClassesSubgroups( grp );
  irrs := Irr( grp );
  Print( "Done!\n\n\n" );


# ## Demo 1: generate orbit type lattices for all irreducible representations
  Print( "=== Demo 1 ===\n" );
  Print( "Compute orbit type lattice of all irreducible representations.... " );
  lats := List( irrs, irr -> LatticeOrbitTypes( irr ) );
  Print( "Done!\n" );

  for i in [ 1 .. Size( irrs ) ] do
    PrintFormatted( "Computing orbit type lattice and Generating dot file for the {}-th S4-irreducible representation.... ", i );
    dotfile := StringFormatted( "demo20_OrbitType/S4_irr{}_latorbt.dot", i );
    irr := irrs[ i ];
    lat_orbtyp := LatticeOrbitTypes( irr );
    DotFileLattice( lat_orbtyp, dotfile );
    Print( "Done!\n" );
    Print( "It admits maximal orbit types:\n" );
    max_orbtyps := MaximalOrbitTypes( irr );
    Print( max_orbtyps, "\n\n" );
  od;
  Print( "(Please check folder ./demo20_OrbitType)" );
