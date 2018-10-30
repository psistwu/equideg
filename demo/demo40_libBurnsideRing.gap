# # libBurnsideRing demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "OrbitType", "BurnsideRing" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


# ## Demo 1: compute basic degrees of all irreducible (S_4)-representations
  Print( "=== Demo 1 ===\n" );
  Print( "Generating Burnside ring A(S4)...." );
  grp := SymmetricGroup( 4 );
  brng := BurnsideRing( grp );
  basis := Basis( brng );
  Print( "Done!\n\n" );

  Print( "Compute Basic degree of each S4-irreducible representation.... " );
  irr_list := Irr( grp );
  bdeg_list := List( irr_list, irr -> BasicDegree( irr ) );
  Print( "Done!\n\n" );

  Print( "All basic degrees:\n");
  for bdeg in bdeg_list do
    Print( bdeg, "\n" );
  od;
  Print( "\n" );

  Print( "Squares of all basic degrees (follow the same order):\n" );
  for bdeg in bdeg_list do
    Print( bdeg^2, "\n" );
  od;
