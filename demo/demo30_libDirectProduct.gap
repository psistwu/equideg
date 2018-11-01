# # libDirectProduct demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "DirectProduct" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );

# ## Setup
  Print( "=== Setup ===\n" );
  # setup direct product of S4 and D3 and compute the CCSs
  Print( "Take grp1 = S4, grp2 = D3 and grp = S4xD3.... " );
  grp1 := SymmetricGroup( 4 );
  grp2 := pDihedralGroup( 3 );
  grp := DirectProduct( grp1, grp2 );
  ccss_grp1 := ConjugacyClassesSubgroups( grp1 );
  ccss_grp2 := ConjugacyClassesSubgroups( grp2 );
  ccss_grp := ConjugacyClassesSubgroups( grp );
  Print( "Done!\n\n\n" );


# ## Demo 1: Goursat info of a subgroup in S4xD3
  Print( "=== Demo 1 ===\n" );
  csubg := Random( ccss_grp );
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
  ccss_grp1_names := [ "Z1", "Z2", "D1", "Z3", "V4",
      "D2", "Z4", "D3", "D4", "A4", "S4" ];
  ListF( ccss_grp1, ccss_grp1_names, SetName );
  Print( "Done!\n" );

  # setup names of all CCSs of grp2 (D3)
  Print( "Setup names for CCSs of grp2 (D3).... " );
  ccss_grp2_names := [ "Z1", "D1", "Z3", "D3" ];
  ListF( ccss_grp2, ccss_grp2_names, SetName );
  Print( "Done!\n\n" );

  # show the amalgamation notation of the CCS
  Print( "The amalgamation symbol of csubg:\n" );
  Print( AmalgamationSymbol( csubg ) );
  Print( "\n\n" );


# ## Demo 6: LaTeX typesetting of a CCS of S4xD3
  Print( "=== Demo 6 ===\n" );

  # setup LaTeX names of all CCSs of grp1 (S4)
  Print( "Setup LaTeX names for CCSs of grp1 (S4).... " );
  ccss_grp1_latex_names := [ "\\mathbb{Z}_1", "\\mathbb{Z}_2", "D_1",
      "\\mathbb{Z}_3", "V_4", "D_2", "\\mathbb{Z}_4",
      "D_3", "D_4", "A_4", "S_4" ];
  ListF( ccss_grp1, ccss_grp1_latex_names, SetLaTeXString );
  Print( "Done!\n" );

  # setup LaTeX names of all CCSs of grp2 (D3)
  Print( "Setup LaTeX names for CCSs of grp2 (D3).... " );
  ccss_grp2_latex_names := [ "\\mathbb{Z}_1", "D_1", "\\mathbb{Z}_3", "D_3" ];
  ListF( ccss_grp2, ccss_grp2_latex_names, SetLaTeXString );
  Print( "Done!\n\n" );

  # show the amalgamation notation of the CCS
  Print( "The amalgamation symbol of csubg:\n" );
  Print( LaTeXTypesetting( csubg ) );
  Print( "\n\n" );

