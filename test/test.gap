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

# ## Test 1: binary relation
  G := SymmetricGroup( 4 );
  H := Representative( ConjugacyClassesSubgroups( G )[ 11 ] );
  NH := NormalizerInParent( H );
  L := pDihedralGroup( 3 );
  NL := pDihedralGroup( 6 );
  L := Image( Representative( IsomorphicSubgroups( NL, L ) ) );
  NHxNL := DirectProduct( NH, NL );
  quos := GQuotients( H, L );
  auts := AllAutomorphisms( L );
  epis := Flat( List( quos, quo -> List( auts, aut -> quo*aut ) ) );
  OnSourceAndRange := function( epi, g )
    local dg;

    dg := DirectProductDecomposition( NHxNL, g );

    return ConjugatorAutomorphismNC( H, Inverse( dg[1] ) )*epi*ConjugatorAutomorphismNC( L, dg[2] );
  end;
  g := Random( NHxNL );
  epi := Random( epis );