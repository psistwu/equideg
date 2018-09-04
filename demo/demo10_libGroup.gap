# # libGroup demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "Basic", "Group" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


# ## Demo 1: generate the lattice of CCSs of group S4
  Print( "=== Demo 1 ===\n" );
  grp := SymmetricGroup( 4 );
  ccs_list := ConjugacyClassesSubgroups( grp );
  latccs := LatticeCCSs( grp );
  Print( "Generating dot file for CCS lattice of S4.... " );
  DotFileLattice( latccs, "demo10_libGroup/S4_latccs.dot" );
  Print( "Done!\n" );
  Print( "(Please check folder ./demo10_libGroup)" );

