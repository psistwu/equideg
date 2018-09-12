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

# ## Test 1: generate O(2) and SO(2)
  Print( "=== Test 1 ===\n" );

  # O(2)
  Print( "Generate O(2) and select several CCSs of O(2).... " );
  o2 := OrthogonalGroupOverReal( 2 );
  ccs_o2_list := ConjugacyClassesSubgroups( o2 );
  ccs1_o2 := ccs_o2_list[ 1 ];
  ccs2_o2 := ccs_o2_list[ 2 ];
  ccs3_o2 := ccs_o2_list[ 3 ];
  ccs4_o2 := ccs_o2_list[ 4 ];
  Print( "Done!\n");

  # SO(2)
  Print( "Generate SO(2) and select several CCSs of SO(2).... " );
  so2 := SpecialOrthogonalGroupOverReal( 2 );
  ccs_so2_list := ConjugacyClassesSubgroups( so2 );
  ccs1_so2 := ccs_so2_list[ 1 ];
  ccs2_so2 := ccs_so2_list[ 2 ];
  ccs3_so2 := ccs_so2_list[ 3 ];
  ccs4_so2 := ccs_so2_list[ 4 ];
  Print( "Done!\n" );

  Print( "\n" );

  # Test 2: Direct Product of a finite group and O(2)
  Print( "=== Test 2 ===\n" );

  # S4
  Print( "Generate S4.... " );
  s4 := SymmetricGroup( 4 );
  ccs_s4_list := ConjugacyClassesSubgroups( s4 );
  Print( "Done!\n" );

  # Z2
  Print( "Generate Z2.... " );
  z2 := CyclicGroup( 2 );
  ccs_z2_list := ConjugacyClassesSubgroups( z2 );
  Print( "Done!\n" );

  # S4xZ2
  Print( "Generate S4xZ2.... " );
  s4xz2 := DirectProduct( s4, z2 );
  ccs_s4xz2_list := ConjugacyClassesSubgroups( s4xz2 );
  Print( "Done!\n" );

  # S4xO(2)
  Print( "Generate S4xO(2)...." );
  s4xo2 := DirectProduct( o2, s4 );
  Print( "Done!\n" );