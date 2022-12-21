gap> START_TEST( "test_erng_SO2xZ2_linop.tst" );


# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> z2 := pCyclicGroup( 2 );;
gap> ccs_names := [ "Z1", "Z2" ];;
gap> SetCCSsAbbrv( z2, ccs_names );
gap> grp := DirectProduct( so2, z2 );;
gap> erng := EulerRing( grp );;


# take elements of the Euler ring
gap> a := ring_gens[ 0, 1 ];;
gap> b := ring_gens[ 1, 2 ];;


gap> Display( a + b );
Erng( <group> ) element:
1	(1,2)	Z_2|Z_1 x Z1|Z2
1	(0,1)	SO(2) x Z1

gap> Display( 2*a + b );
Erng( <group> ) element:
1	(1,2)	Z_2|Z_1 x Z1|Z2
2	(0,1)	SO(2) x Z1

gap> Display( 2*(a + b) );
Erng( <group> ) element:
2	(1,2)	Z_2|Z_1 x Z1|Z2
2	(0,1)	SO(2) x Z1

gap> Display( -a );
Erng( <group> ) element:
-1	(0,1)	SO(2) x Z1

gap> Display( a - b );
Erng( <group> ) element:
-1	(1,2)	Z_2|Z_1 x Z1|Z2
1	(0,1)	SO(2) x Z1
