# # Lie Group Test
#
# Test of Lie group functions in libGroup
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  LoadPackage( "EquiDeg" );

# ## Test 1: generate O(2) and SO(2)
  Print( "=== Test 1 ===\n" );

# # O(2)
  Print( "Generate O(2) and select CCSs of O(2).... " );
  o2 := OrthogonalGroupOverReal( 2 );
  ccss_o2 := ConjugacyClassesSubgroups( o2 );
  ccs1_o2 := ccss_o2[ 0, 1 ];
  ccs2_o2 := ccss_o2[ 1, 1 ];
  ccs3_o2 := ccss_o2[ 2, 2 ];
  Print( "Done!\n" );

# # SO(2)
  Print( "Generate SO(2) and select CCSs of SO(2).... " );
  so2 := SpecialOrthogonalGroupOverReal( 2 );
  ccss_so2 := ConjugacyClassesSubgroups( so2 );
  ccs_so2 := ccss_so2[ 3, 1 ];
  Print( "Done!\n" );
