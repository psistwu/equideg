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
  ccss := ConjugacyClassesSubgroups( grp );
  brng := BurnsideRing( grp );
  basis := Basis( brng );
  Print( "Done!\n\n" );

  # setup names of all CCSs of grp1 (S4)
  Print( "Setup names for CCSs of grp1 (S4).... " );
  SetName( ccss[ 1 ], "Z1" );
  SetName( ccss[ 2 ], "Z2" );
  SetName( ccss[ 3 ], "D1" );
  SetName( ccss[ 4 ], "Z3" );
  SetName( ccss[ 5 ], "V4" );
  SetName( ccss[ 6 ], "D2" );
  SetName( ccss[ 7 ], "Z4" );
  SetName( ccss[ 8 ], "D3" );
  SetName( ccss[ 9 ], "D4" );
  SetName( ccss[ 10 ], "A4" );
  SetName( ccss[ 11 ], "S4" );
  Print( "Done!\n" );

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
