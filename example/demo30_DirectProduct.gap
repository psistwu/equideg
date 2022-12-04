# # libDirectProduct demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  LoadPackage( "EquiDeg" );

# ## Setup
  Print( "=== Setup ===\n" );
  # setup direct product of S4 and D3 and compute the CCSs
  Print( "Take <G1> = S4, <G2> = D3 and <G> = S4xD3.... " );
  G1 := SymmetricGroup( 4 );
  G2 := pDihedralGroup( 3 );
  G := DirectProduct( G1, G2 );
  CCSs_G1 := ConjugacyClassesSubgroups( G1 );
  CCSs_G2 := ConjugacyClassesSubgroups( G2 );
  CCSs_G := ConjugacyClassesSubgroups( G );
  Print( "Done!\n\n\n" );


# ## Demo 1: Goursat info of a subgroup in S4xD3
  Print( "=== Demo 1 ===\n" );
  Print( "Take a subgroup <U>\n" );
  C := Random( CCSs_G );
  U := Representative( C );
  Print( U, "\n\n" );
  Print( "The Goursat info of <U>:\n" );
  U_ginfo := GoursatInfo( U );
  Print( U_ginfo, "\n\n\n" );


# ## Demo 2: direct product decomposition of a group element
  Print( "=== Demo 2 ===\n" );
  Print( "Take a group element <e>:\n" );
  e := Random( G );
  Print( e, "\n\n" );
  Print( "The direct product decomposition of <e>:\n" );
  Print( DirectProductDecomposition( G, e ), "\n\n\n" );


# ## Demo 3: direct product decomposition of a conjugacy class
  Print( "=== Demo 3 ===\n" );
  Print( "Take a conjugacy class <c>:\n" );
  c := ConjugacyClasses( G )[ 8 ];
  Print( c, "\n\n" );
  Print( "The direct product decomposition of <c>:\n" );
  Print( DirectProductDecomposition( c ), "\n\n\n" );


# ## Demo 4: tensor product decomposition of an irreducible character
  Print( "=== Demo 4 ===\n" );
  chi := Random( Irr( G ) );
  Print( "Take an irreducible character <chi>:\n" );
  Print( chi, "\n\n" );
  Print( "The direct product decomposition of <chi>:\n" );
  Print( TensorProductDecomposition( chi ), "\n\n\n" );
  

# ## Demo 5: print amalgamation symbol of a CCS of S4xD3
  Print( "=== Demo 5 ===\n" );

  # setup names of all CCSs of grp1 (S4)
  Print( "Setup abbrv for CCSs of <G1> = S4.... " );
  CCSs_G1_abbrv := [ "Z1", "Z2", "D1", "Z3", "V4",
      "D2", "Z4", "D3", "D4", "A4", "S4" ];
  SetCCSsAbbrv( G1, CCSs_G1_abbrv );
  Print( "Done!\n" );

  # setup names of all CCSs of grp2 (D3)
  Print( "Setup names for CCSs of <G2> = D3.... " );
  CCSs_G2_abbrv := [ "Z1", "D1", "Z3", "D3" ];
  SetCCSsAbbrv( G2, CCSs_G2_abbrv );
  Print( "Done!\n\n" );

  # show the amalgamation notation of the CCS
  Print( "The amalgamation symbol of C:\n" );
  Print( AmalgamationSymbol( C ) );
  Print( "\n\n" );


# ## Demo 6: LaTeX typesetting of a CCS of S4xD3
  Print( "=== Demo 6 ===\n" );

# # setup LaTeX symbols of all CCSs of grp1 (S4)
  Print( "Setup LaTeX symbols for CCSs of <G1> = S4.... " );
  CCSs_G1_latexsymbols := [ "\\bbZ_1", "\\bbZ_2", "D_1",
      "\\bbZ_3", "V_4", "D_2", "\\bbZ_4",
      "D_3", "D_4", "A_4", "S_4" ];
  SetCCSsLaTeXString( G1, CCSs_G1_latexsymbols );
  Print( "Done!\n" );

  # setup LaTeX names of all CCSs of grp2 (D3)
  Print( "Setup LaTeX symbols for CCSs of <G2> = D3.... " );
  CCSs_G2_latexsymbols := [ "\\bbZ_1", "D_1", "\\bbZ_3", "D_3" ];
  SetCCSsLaTeXString( G2, CCSs_G2_latexsymbols );
  Print( "Done!\n\n" );

  # show the amalgamation notation of the CCS
  Print( "The amalgamation LaTeX symbol of <C>:\n" );
  Print( LaTeXTypesetting( C, "" ) );
  Print( "\n\n" );

