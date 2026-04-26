gap> START_TEST( "test_DimensionOfFixedSet.tst" );

# Definition
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> ccss_so2 := ConjugacyClassesSubgroups( so2 );;
gap> irrs_so2 := Irr( so2 );;
gap> o2 := OrthogonalGroupOverReal( 2 );;
gap> ccss_o2 := ConjugacyClassesSubgroups( o2 );;
gap> irrs_o2 := Irr( o2 );;
gap> z3 := CyclicGroup( 3 );;
gap> ccss_z3 := ConjugacyClassesSubgroups( z3 );;
gap> irrs_z3 := Irr( z3 );;
gap> q8 := QuaternionGroup( 8 );;
gap> ccss_q8 := ConjugacyClassesSubgroups( q8 );;
gap> irrs_q8 := Irr( q8 );;
gap> o2xz3 := DirectProduct( o2, z3 );;
gap> ccss_o2xz3 := ConjugacyClassesSubgroups( o2xz3 );;
gap> irrs_o2xz3 := Irr( o2xz3 );;

# Test A: Z3
gap> List( ccss_z3, c -> DimensionOfFixedSet( irrs_z3[ 1 ], c, "complex" ) );
[ 1, 1 ]
gap> List( ccss_z3, c -> DimensionOfFixedSet( irrs_z3[ 1 ], c, "real" ) );
[ 1, 1 ]
gap> List( ccss_z3, c -> DimensionOfFixedSet( irrs_z3[ 2 ], c, "complex" ) );
[ 1, 0 ]
gap> List( ccss_z3, c -> DimensionOfFixedSet( irrs_z3[ 2 ], c, "real" ) );
[ 2, 0 ]
gap> List( ccss_z3, c -> DimensionOfFixedSet( irrs_z3[ 3 ], c, "complex" ) );
[ 1, 0 ]
gap> List( ccss_z3, c -> DimensionOfFixedSet( irrs_z3[ 3 ], c, "real" ) );
[ 2, 0 ]

# Test B: SO(2)
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 0, 1 ], "real" ) );
[ 0, 1, 0 ]
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 0, 1 ], "complex" ) );
[ 0, 1, 0 ]
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 1, 1 ], "real" ) );
[ 2, 1, 2 ]
gap> List( [ -1, 0, 1 ], n -> DimensionOfFixedSet( irrs_so2[ n ], ccss_so2[ 1, 1 ], "complex" ) );
[ 1, 1, 1 ]

# Test C: O(2)
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 2 ], "real" ) );
[ 0, 1, 0 ]
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 2 ], "complex" ) );
[ 0, 1, 0 ]
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 1 ], "real" ) );
[ 1, 1, 0 ]
gap> List( [-1, 0, 1 ], n -> DimensionOfFixedSet( irrs_o2[ n ], ccss_o2[ 0, 1 ], "complex" ) );
[ 1, 1, 0 ]

# Test D: O2 x Z3
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 1 ], ccss_o2xz3[ 0, 1 ], "real" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 1 ], ccss_o2xz3[ 0, 2 ], "real" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 1 ], ccss_o2xz3[ 0, 3 ], "real" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 1 ], ccss_o2xz3[ 0, 4 ], "real" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 2 ], ccss_o2xz3[ 0, 1 ], "real" );
2
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 2 ], ccss_o2xz3[ 0, 2 ], "real" );
2
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 2 ], ccss_o2xz3[ 0, 1 ], "complex" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 2 ], ccss_o2xz3[ 0, 2 ], "complex" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 2 ], ccss_o2xz3[ 0, 3 ], "real" );
0
gap> DimensionOfFixedSet( irrs_o2xz3[ 0, 2 ], ccss_o2xz3[ 0, 4 ], "real" );
0
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 1 ], "real" );
4
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 1 ], "complex" );
2
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 2 ], "real" );
2
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 2 ], "complex" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 3 ], "real" );
2
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 3 ], "complex" );
1
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 4 ], "real" );
0
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 4 ], "complex" );
0
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 5 ], "real" );
0
gap> DimensionOfFixedSet( irrs_o2xz3[ 3, 2 ], ccss_o2xz3[ 3, 5 ], "complex" );
0