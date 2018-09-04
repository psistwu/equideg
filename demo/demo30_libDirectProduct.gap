# # libDirectProduct demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "Basic", "Group", "DirectProduct" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );

  # setup direct product of S4 and D3 and compute the CCSs
  Print( "Setup grp1 = S4, grp2 = D3 and grp = S4xD3 and compute their CCSs.... " );
  grp1 := SymmetricGroup( 4 );
  grp2 := pDihedralGroup( 3 );
  grp := DirectProduct( grp1, grp2 );
  ccs_s4_list := ConjugacyClassesSubgroups( grp1 );
  ccs_d3_list := ConjugacyClassesSubgroups( grp2 );
  ccs_list := ConjugacyClassesSubgroups( grp );
  Print( "Done!\n\n\n" );


# ## Demo 1: show direct product info of a subgroup in S4xD3
  Print( "=== Demo 1 ===\n" );
  c := ccs_list[ 38 ];
  subg := Representative( c );
  subg_dpinfo := SubgroupDirectProductInfo( subg );
  Print( "The direct product info of the given subgroup:\n" );
  Display( subg_dpinfo );
  Print( "\n\n" );


# ## Demo 2: show the amalgamation notation of a CCS of S4xD3
  Print( "=== Demo 2 ===\n" );

  # obtain amalgamation quadruple of the CCS
  c_amalquad := AmalgamationQuadruple( c );
  Print( "The amalgamation quadruple of the given CCS:\n" );
  Display( c_amalquad );
  Print( "\n" );

  # setup names of all CCSs of grp1(S4)
  Print( "Setup names for CCSs of grp1(S4).... " );
  SetName( ccs_s4_list[ 1 ], "Z1" );
  SetName( ccs_s4_list[ 2 ], "Z2" );
  SetName( ccs_s4_list[ 3 ], "D1" );
  SetName( ccs_s4_list[ 4 ], "Z3" );
  SetName( ccs_s4_list[ 5 ], "V4" );
  SetName( ccs_s4_list[ 6 ], "D2" );
  SetName( ccs_s4_list[ 7 ], "Z4" );
  SetName( ccs_s4_list[ 8 ], "D3" );
  SetName( ccs_s4_list[ 9 ], "D4" );
  SetName( ccs_s4_list[ 10 ], "A4" );
  SetName( ccs_s4_list[ 11 ], "S4" );
  Print( "Done!\n" );

  # setup names of all CCSs of grp2(D3)
  Print( "Setup names for CCSs of grp2(D3).... " );
  SetName( ccs_d3_list[ 1 ], "Z1" );
  SetName( ccs_d3_list[ 2 ], "D1" );
  SetName( ccs_d3_list[ 3 ], "Z3" );
  SetName( ccs_d3_list[ 4 ], "D3" );
  Print( "Done!\n\n" );

  # show the amalgamation notation of the CCS
  c_amalnotation := AmalgamationNotation( c );
  Print( "The amalgamation notation of the given CCS:\n" );
  Display( c_amalnotation );
  Print( "\n\n" );


  # ## Demo 3: direct product decomposition of a CC and an irreducible character of S4xD3
  Print( "=== demo 3 ===\n" );

  # direct product decomposition of a CC
  cc_s4_list := ConjugacyClasses( grp1 );
  cc_d3_list := ConjugacyClasses( grp2 );
  cc_list := ConjugacyClasses( grp );
  cc := cc_list[ 9 ];
  cc_dpd := DirectProductDecomposition( cc );
  Print( "The direct product decomposition of a CC of S4xD3:\n" );
  Display( cc_dpd );
  Print( "\n" );

  # direct product decomposition of an irreducible characeter
  char := Irr( grp )[ 7 ];
  char_decomp := DirectProductDecomposition( char );
  Print( "The direct product decomposition of an irreducible character of S4xD4:\n" );
  Display( char_decomp );
  Print( "\n" );