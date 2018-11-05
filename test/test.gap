# # Lie Group Test
#
# Test of Lie group functions in libGroup
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "OrbitType", "BurnsideRing" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );

  grp := pDihedralGroup( 4 );
  ccs_list := ConjugacyClassesSubgroups( grp );
  cc_list := ConjugacyClasses( grp );
  chtbl := CharacterTable( grp );
  ccs_names := [ "Z1", "Z2", "D1", "T1", "D2", "Z4", "T2", "D4" ];
  ListF( ccs_list, ccs_names, SetName );
  bdeg_list := List( Irr( grp ), BasicDegree );
