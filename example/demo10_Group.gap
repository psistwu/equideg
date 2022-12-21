# # libGroup demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  LoadPackage( "EquiDeg" );

# ## Let <G>=S4
  Print( "=== Setup ===\n" );
  Print( "Let <G>=S4.... " );
  G := SymmetricGroup( 4 );
  Print( "Done!\n\n\n" );

# ## Demo 1: assign abbriviations for CCSs of <G>
  Print( "Compute CCSs of G and assign them abbriviations.... " );
  CCSs_G := ConjugacyClassesSubgroups( G );
  CCSs_abbrv := [ "Z1", "Z2", "D1", "Z3", "V4", "D2",
      "Z4", "D3", "D4", "A4", "S4" ];
  SetCCSsAbbrv( G, CCSs_abbrv );
  Print( "Done!\n\n\n" );

# ## Demo 2: generate the lattice of CCSs of <G>
  Print( "=== Demo 1 ===\n" );
  Print( "Generating dot file for CCS lattice of S4.... " );
  latccs := LatticeCCSs( G );
  DotFileLattice( latccs, "demo10_Group/S4_latccs.dot" );
  Print( "Done!\n" );
  Print( "(Please check folder ./demo10_Group)" );

