gap> START_TEST( "test_SchurIndicator.tst" );

# Test A: finite group (S4)
gap> s4 := SymmetricGroup( 4 );;
gap> irr := Irr( s4 );;

# Test A.1: 1st Schur indicator of (S4)-representations
gap> List( irr, chi -> SchurIndicator( chi, 1 ) );
[ 0, 0, 0, 0, 1 ]

# Test A.2: 2nd Schur indicator of (S4)-representations
gap> List( irr, chi -> SchurIndicator( chi, 2 ) );
[ 1, 1, 1, 1, 1 ]

# Test B: compact Lie group (SO(2))
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> irr2 := Irr( so2 );;

# Test B.1: trivial (SO(2)) irreducible is of real type
gap> SchurIndicator( irr2[ 0 ] );
1

# Test B.2: non-trivial SO(2) irreducibles are of complex type
gap> SchurIndicator( irr2[ 1 ] );
0
gap> SchurIndicator( irr2[ 2 ] );
0

# Test C: compact Lie group (O(2))
gap> o2 := OrthogonalGroupOverReal( 2 );;
gap> irr3 := Irr( o2 );;

# all O(2) irreducibles are of real type
gap> SchurIndicator( irr3[ 0 ] );
1
gap> SchurIndicator( irr3[ -1 ] );
1
gap> SchurIndicator( irr3[ 1 ] );
1
gap> SchurIndicator( irr3[ 2 ] );
1

# Test D: compact Lie group (SO(2)xG), G is a finite group

# Test E: compact Lie group (O(2)xG), G is a finite group