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
  Print( "Done!\n" );

  ccs_g_list0 := [ ];
  for c in CCSClasses( ccss_g ) do
    Add( ccs_g_list0, NewCCS( IsDirectProductWithECLGCCSsRep, c ) );
  od;

  ccs_g_list1 := [ ];
  for i in [ 1 .. Size( CCSClassesFiltered( ccss_g )( "nonzero_mode" ) ) ] do
    Add( ccs_g_list1, CCSId( ccss_g )( [ i, 1 ] ) );
  od;

  ccs_g_list2 := [ ];
  for i in [ 1 .. Size( CCSClassesFiltered( ccss_g )( "zero_mode" ) ) ] do
    Add( ccs_g_list2, CCSId( ccss_g )( [ i, 0 ] ) );
  od;

  Print( "\n" );

  # S4xSO(2)
  Print( "Generating CCSs of S4xSO(2).... " );
  ccss_h := ConjugacyClassesSubgroups( h );
  Print( "Done!\n" );

  ccs_h_list0 := [ ];
  for c in CCSClasses( ccss_h ) do
    Add( ccs_h_list0, NewCCS( IsDirectProductWithECLGCCSsRep, c ) );
  od;

  ccs_h_list1 := [ ];
  for i in [ 1 .. Size( CCSClassesFiltered( ccss_h )( "nonzero_mode" ) ) ] do
    Add( ccs_h_list1, CCSId( ccss_h )( [ i, 1 ] ) );
  od;

  ccs_h_list2 := [ ];
  for i in [ 1 .. Size( CCSClassesFiltered( ccss_h )( "zero_mode" ) ) ] do
    Add( ccs_h_list2, CCSId( ccss_h )( [ i, 0 ] ) );
  od;

