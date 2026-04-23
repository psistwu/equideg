gap> START_TEST( "test_DimensionOfFixedSet.tst" );

# Definition
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> ccss_so2 := ConjugacyClassesSubgroups( so2 );;
gap> irrs_so2 := Irr( so2 );;
gap> o2 := OrthogonalGroupOverReal( 2 );;
gap> ccss_o2 := ConjugacyClassesSubgroups( o2 );;
gap> irrs_o2 := Irr( o2 );;

# Test A: SO(2)
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 0, 1 ], "real" ) );
[ 0, 1, 0 ]
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 0, 1 ], "complex" ) );
[ 0, 1, 0 ]
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 1, 1 ], "real" ) );
[ 2, 1, 2 ]
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 1, 1 ], "complex" ) );
[ 1, 1, 1 ]

# Test B: O(2)
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 2 ], "real" ) );
[ 0, 1, 0 ]
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 2 ], "complex" ) );
[ 0, 1, 0 ]
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 1 ], "real" ) );
[ 1, 1, 0 ]
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 1 ], "complex" ) );
[ 1, 1, 0 ]