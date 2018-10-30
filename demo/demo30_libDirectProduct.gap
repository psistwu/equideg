# # libDirectProduct demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "DirectProduct" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );

  # setup direct product of S4 and D3 and compute the CCSs
  Print( "Setting up:\n" );
  Print( "grp1 = S4,\n" );
  Print( "grp2 = D3,\n" );
  Print( "grp = S4xD3.... " );
  grp1 := SymmetricGroup( 4 );
  grp2 := pDihedralGroup( 3 );
  grp := DirectProduct( grp1, grp2 );
  ccs_s4_list := ConjugacyClassesSubgroups( grp1 );
  ccs_d3_list := ConjugacyClassesSubgroups( grp2 );
  ccs_list := ConjugacyClassesSubgroups( grp );
  Print( "Done!\n\n\n" );


# ## Demo 1: Goursat info of a subgroup in S4xD3
  Print( "=== Demo 1 ===\n" );
  csubg := Random( ccs_list );
  subg := Representative( csubg );
  subg_ginfo := GoursatInfo( subg );
  Print( "The Goursat info of the given subgroup:\n" );
  Print( subg_ginfo, "\n\n\n" );


# ## Demo 2: direct product decomposition of a group element
  Print( "=== Demo 2 ===\n" );
  e := Random( grp );
  Print( "Take e as a group element:\n" );
  Print( e, "\n\n" );
  Print( "The direct product decomposition of e:\n" );
  Print( DirectProductDecomposition( grp, e ), "\n\n\n" );


# ## Demo 3: direct product decomposition of a conjugacy class
  Print( "=== Demo 3 ===\n" );
  c := ConjugacyClasses( grp )[ 8 ];
  Print( "Take c as a conjugacy class:\n" );
  Print( c, "\n\n" );
  Print( "The direct product decomposition of c is\n" );
  Print( DirectProductDecomposition( c ), "\n\n\n" );


# ## Demo 4: direct product decomposition of an irreducible character
  Print( "=== Demo 4 ===\n" );
  chi := Random( Irr( grp ) );
  Print( "Take chi as an irreducible character:\n" );
  Print( chi, "\n\n" );
  Print( "The direct product decomposition of chi is\n" );
  Print( DirectProductDecomposition( chi ), "\n\n\n" );
  

# ## Demo 5: print amalgamation symbol of a CCS of S4xD3
  Print( "=== Demo 5 ===\n" );

  # setup names of all CCSs of grp1 (S4)
  Print( "Setup names for CCSs of grp1 (S4).... " );
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

  # setup names of all CCSs of grp2 (D3)
  Print( "Setup names for CCSs of grp2 (D3).... " );
  SetName( ccs_d3_list[ 1 ], "Z1" );
  SetName( ccs_d3_list[ 2 ], "D1" );
  SetName( ccs_d3_list[ 3 ], "Z3" );
  SetName( ccs_d3_list[ 4 ], "D3" );
  Print( "Done!\n\n" );

  # show the amalgamation notation of the CCS
  Print( "The amalgamation symbol of csubg:\n" );
  Print( AmalgamationSymbol( csubg ) );
  Print( "\n\n" );


# ## Demo 5: print amalgamation symbol of a CCS of S4xD3
  Print( "=== Demo 5 ===\n" );

  # setup LaTeX names of all CCSs of grp1 (S4)
  Print( "Setup LaTeX names for CCSs of grp1 (S4).... " );
  SetLaTeXString( ccs_s4_list[ 1  ], "\\mathbb{Z}_1" );
  SetLaTeXString( ccs_s4_list[ 2  ], "\\mathbb{Z}_2" );
  SetLaTeXString( ccs_s4_list[ 3  ], "D_1" );
  SetLaTeXString( ccs_s4_list[ 4  ], "\\mathbb{Z}_3" );
  SetLaTeXString( ccs_s4_list[ 5  ], "V_4" );
  SetLaTeXString( ccs_s4_list[ 6  ], "D_2" );
  SetLaTeXString( ccs_s4_list[ 7  ], "\\mathbb{Z}_4" );
  SetLaTeXString( ccs_s4_list[ 8  ], "D_3" );
  SetLaTeXString( ccs_s4_list[ 9  ], "D_4" );
  SetLaTeXString( ccs_s4_list[ 10 ], "A_4" );
  SetLaTeXString( ccs_s4_list[ 11 ], "S_4" );
  Print( "Done!\n" );

  # setup LaTeX names of all CCSs of grp2 (D3)
  Print( "Setup LaTeX names for CCSs of grp2(D3).... " );
  SetLaTeXString( ccs_d3_list[ 1 ], "\\mathbb{Z}_1" );
  SetLaTeXString( ccs_d3_list[ 2 ], "D_1" );
  SetLaTeXString( ccs_d3_list[ 3 ], "\\mathbb{Z}_3" );
  SetLaTeXString( ccs_d3_list[ 4 ], "D_3" );
  Print( "Done!\n\n" );

  # show the amalgamation notation of the CCS
  Print( "The amalgamation symbol of csubg:\n" );
  Print( PEncStr( LaTeXAmalgamationSymbol( csubg ) ) );
  Print( "\n\n" );

