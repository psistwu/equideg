gap> START_TEST( "test_SchurIndicator.tst" );

# Test method `SchurIndicator'

# Preparation
gap> s4 := SymmetricGroup( 4 );;
gap> q8 := QuaternionGroup( 8 );;
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> o2 := OrthogonalGroupOverReal( 2 );;
gap> so2xs4 := DirectProduct( so2, s4 );;
gap> so2xq8 := DirectProduct( so2, q8 );;
gap> o2xs4 := DirectProduct( o2, s4 );;
gap> o2xq8 := DirectProduct( o2, q8 );;

# Test A: Finite Groups
# Test A.1: S4
gap> List( Irr( s4 ), SchurIndicator );
[ 1, 1, 1, 1, 1 ]

# Test A.1: Q8
gap> List( Irr( q8 ), SchurIndicator );
[ 1, 1, 1, 1, -1 ]

# Test B: Elementary Compact Lie Groups
# Test B.1: SO(2)
gap> List( [ 0 .. 2 ], n -> SchurIndicator( Irr( so2 )[ n ] ) );
[ 1, 0, 0 ]

# Test B.2: O(2)
gap> List( [ -1 .. 2 ], n -> SchurIndicator( Irr( o2 )[ n ] ) );
[ 1, 1, 1, 1 ]

# Test C: Direct Product of ECLG and Finite Group
# Test C.1: SO(2)xS4
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( so2xs4 )[ 0, n ] ) );
[ 1, 1, 1, 1, 1 ]
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( so2xs4 )[ 1, n ] ) );
[ 0, 0, 0, 0, 0 ]

# Test C.2: SO(2)xQ8
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( so2xq8 )[ 0, n ] ) );
[ 1, 1, 1, 1, -1 ]
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( so2xq8 )[ 1, n ] ) );
[ 0, 0, 0, 0, 0 ]

# Test C.3: O(2)xS4
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( o2xs4 )[ -1, n ] ) );
[ 1, 1, 1, 1, 1 ]
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( o2xs4 )[ 0, n ] ) );
[ 1, 1, 1, 1, 1 ]
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( o2xs4 )[ 1, n ] ) );
[ 1, 1, 1, 1, 1 ]

# Test C.4: O(2)xQ8
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( o2xq8 )[ -1, n ] ) );
[ 1, 1, 1, 1, -1 ]
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( o2xq8 )[ 0, n ] ) );
[ 1, 1, 1, 1, -1 ]
gap> List( [ 1 .. 5 ], n -> SchurIndicator( Irr( o2xq8 )[ 1, n ] ) );
[ 1, 1, 1, 1, -1 ]
