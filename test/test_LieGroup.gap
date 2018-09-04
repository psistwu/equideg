# # Lie Group Test
#
# Test of Lie group functions in libGroup
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "Basic", "Group", "CompactLieGroup" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


# ## Test 1: generate O(2)
  Print( "=== Test 1 ===\n" );

  # S_4
  s4 := SymmetricGroup( 4 );
  ccs_s4_list := ConjugacyClassesSubgroups( s4 );
  ccs_s4 := ccs_s4_list[ 4 ];
  cc_s4_list := ConjugacyClasses( s4 );
  cc_s4 := cc_s4_list[ 4 ];

  # O(2)
  o2 := OrthogonalGroupOverReal( 2 );
  ccs_o2_list := ConjugacyClassesSubgroups( o2 );
  enum_ccs_o2_list := Enumerator( ccs_o2_list );
  ccs1_o2 := enum_ccs_o2_list[ 1 ];
  ccs2_o2 := enum_ccs_o2_list[ 2 ];
  ccs3_o2 := enum_ccs_o2_list[ 3 ];
  ccs4_o2 := enum_ccs_o2_list[ 4 ];
  ccs5_o2 := enum_ccs_o2_list[ 4 ];

  # SO(2)
  so2 := SpecialOrthogonalGroupOverReal( 2 );
  ccs_so2_list := ConjugacyClassesSubgroups( so2 );
  enum_ccs_so2_list := Enumerator( ccs_so2_list );
  ccs1_so2 := enum_ccs_so2_list[ 1 ];
  ccs2_so2 := enum_ccs_so2_list[ 2 ];
  ccs3_so2 := enum_ccs_so2_list[ 3 ];
  ccs4_so2 := enum_ccs_so2_list[ 4 ];
  ccs5_so2 := enum_ccs_so2_list[ 4 ];

  # Z_5 < O(2)
  z5 := mCyclicGroup( 5 );
  ccs_z5_list := ConjugacyClassesSubgroups( z5 );