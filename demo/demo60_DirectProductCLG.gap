# # Lie Group Test
#
# Test of Lie group functions in libGroup
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  LoadPackage( "EquiDeg" );

# ## Test 1
  Print( "---\n" );
  Print( "Test 1: basic operations for GxO(2) and GxSO(2).\n" );
  Print( "---\n" );

  # generate O(2), SO(2) and S4
  o2 := OrthogonalGroupOverReal( 2 );
  so2 := SpecialOrthogonalGroupOverReal( 2 );
  s4 := SymmetricGroup( 4 );

  # generate S4xO(2) and S4xSO(2)
  Print( "Generating S4xO(2).... " );
  g := DirectProduct( o2, s4 );
  Print( "Done!\n" );

  Print( "Finding projections and embeddings related to S4xO(2).... " );
  proj1_g := Projection( g, 1 );
  proj2_g := Projection( g, 2 );
  embed1_g := Embedding( g, 1 );
  embed2_g := Embedding( g, 2 );
  Print( "Done!\n" );

  Print( "\n" );

  Print( "Generating S4xSO(2)...." );
  h := DirectProduct( so2, s4 );
  Print( "Done!\n" );

  Print( "Finding projections and embeddings related to S4xO(2).... " );
  proj1_h := Projection( h, 1 );
  proj2_h := Projection( h, 2 );
  embed1_h := Embedding( h, 1 );
  embed2_h := Embedding( h, 2 );
  Print( "Done!\n" );
  Print( "\n" );


# ## Test 2
  Print( "---\n" );
  Print( "Test 2: CCS for GxO(2) and GxSO(2).\n" );
  Print( "---\n" );

  # S4xO(2)
  Print( "Generating CCSs of S4xO(2).... " );
  ccss_g := ConjugacyClassesSubgroups( g );
  Print( "Done!\n\n" );

  # S4xSO(2)
# Print( "Generating CCSs of S4xSO(2).... " );
# ccss_h := ConjugacyClassesSubgroups( h );
# Print( "Done!\n" );

  ccss_s4 := ConjugacyClassesSubgroups( s4 );
  ccss_s4_latexsymbols := [ "\\bbZ_1", "\\bbZ_2", "D_1",
      "\\bbZ_3", "V_4", "D_2", "\\bbZ_4",
      "D_3", "D_4", "A_4", "S_4" ];
  ListA( ccss_s4, ccss_s4_latexsymbols, SetLaTeXString );
