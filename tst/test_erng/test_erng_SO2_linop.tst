gap> START_TEST( "test_erng_SO2_linop.tst" );


# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> erng := EulerRing( so2 );;
gap> ring_gens := GeneratorsOfRing( erng );;


# take elements of the Euler ring
gap> a := ring_gens[ 0, 1 ];;
gap> b := ring_gens[ 1, 1 ];;


gap> Display( a + b );
Erng( <group with 1 generators> ) element:
1	(1,1)	Z_1
1	(0,1)	SO(2)

gap> Display( 2*a + b );
Erng( <group with 1 generators> ) element:
1	(1,1)	Z_1
2	(0,1)	SO(2)

gap> Display( 2*(a + b) );
Erng( <group with 1 generators> ) element:
2	(1,1)	Z_1
2	(0,1)	SO(2)

gap> Display( -a );
Erng( <group with 1 generators> ) element:
-1	(0,1)	SO(2)

gap> Display( a - b );
Erng( <group with 1 generators> ) element:
-1	(1,1)	Z_1
1	(0,1)	SO(2)
