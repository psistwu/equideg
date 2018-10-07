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

# universal setup
  g := SymmetricGroup( 4 );
  ccss := ConjugacyClassesSubgroups( g );

# ## test 2
  ccs1 := ccss[ 5 ];
  ccs2 := ccss[ 2 ];

# ## test 1 (archived)
# for i in [ 1 .. Size( ccss ) ] do
#   ccs1 := ccss[ i ];
#   subg1 := Representative( ccs1 );
#   for j in [ 1 .. i-1 ] do
#     ccs2 := ccss[ j ];
#     subg2 := Representative( ccs2 );
#     flag := ( ( ccs1 > ccs2 ) and IsSubgroup( subg1, subg2 ) ) or
#             not ( ( ccs1 > ccs2 ) or IsSubgroup( subg1, subg2 ) );
#     Print( flag, "\n" );
#   od;
# od;