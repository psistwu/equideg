# # Lie Group Test
#
# Test of Lie group functions in libGroup
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "Basic", "Group", "CompactLieGroup", "DirectProduct", "CompactLieGroupDirectProduct" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


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
  Print( "Generating S4xSO(2)...." );
  h := DirectProduct( so2, s4 );
  Print( "Done!\n" );

  Print( "Finding projections and embeddings related to S4xO(2).... " );
  proj1_g := Projection( g, 1 );
  proj2_g := Projection( g, 2 );
  embed1_g := Embedding( g, 1 );
  embed2_g := Embedding( g, 2 );
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
  Print( "Done!\n" );

# idccs1_g := [ Random( 1, 33 ), 0 ];
  idccs1_g := [ 31, 0 ];
  Print( "Generating CCS ", idccs1_g, " of S4xO(2).... ");
  ccs1_g := CCSId( ccss_g )( idccs1_g );
  subg1_g := Representative( ccs1_g );
  Print( "Done!\n" );

# idccs2_g := [ Random( 1, 67 ), 3 ];
  idccs2_g := [ 21, 3 ];
  Print( "Generating CCS ", idccs2_g, " of S4xO(2).... ");
  ccs2_g := CCSId( ccss_g )( idccs2_g );
  subg2_g := Representative( ccs2_g );
  Print( "Done!\n" );

# idccs3_g := [ Random( 1, 67 ), 1 ];
  idccs3_g := [ 1, 1 ];
  Print( "Generating CCS ", idccs3_g, " of S4xO(2).... ");
  ccs3_g := CCSId( ccss_g )( idccs3_g );
  subg3_g := Representative( ccs3_g );
  Print( "Done!\n" );

  idccs4_g := [ 28, 0 ];
  Print( "Generating CCS ", idccs4_g, " of S4xO(2).... ");
  ccs4_g := CCSId( ccss_g )( idccs4_g );
  subg4_g := Representative( ccs4_g );
  Print( "Done!\n" );

  Print( "\n" );

  # S4xSO(2)
  Print( "Generating CCSs of S4xSO(2).... " );
  ccss_h := ConjugacyClassesSubgroups( h );
  Print( "Done!\n" );
  idccs1_h := [ Random( 1, 11 ), 0 ];
  Print( "Generating CCS ", idccs1_h, " of S4xSO(2).... " );
  ccs1_h := CCSId( ccss_h )( idccs1_h );
  subg1_h := Representative( ccs1_h );
  Print( "Done!\n" );

  idccs2_h := [ Random( 1, 25 ), 3 ];
  Print( "Generating CCS ", idccs2_h, " of S4xSO(2).... " );
  ccs2_h := CCSId( ccss_h )( idccs2_h );
  subg2_h := Representative( ccs2_h );
  Print( "Done!\n" );
