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


  # Test 1: Direct Product of a finite group and O(2)
  Print( "=== Test 1 ===\n" );

  # generate O(2), SO(2) and S4
  o2 := OrthogonalGroupOverReal( 2 );
  so2 := SpecialOrthogonalGroupOverReal( 2 );
  s4 := SymmetricGroup( 4 );

  # S4xO(2)
  Print( "Generate S4xO(2)...." );
  g1 := DirectProduct( o2, s4 );
  ccss_g1 := ConjugacyClassesSubgroups( g1 );
  ccsid_g1 := CCSId( ccss_g1 );
  ccs1_g1 := ccsid_g1( [ 2, 2 ] );
  subg1_g1 := Representative( ccs1_g1 );
  ccs2_g1 := ccsid_g1( [ 2, 0 ] );
  subg2_g1 := Representative( ccs2_g1 );
  Print( "Done!\n" );
  Print( "\n" );

  # S4xSO(2)
  Print( "Generate S4xSO(2)...." );
  g2 := DirectProduct( so2, s4 );
  Print( "Done!\n" );

