gap> START_TEST( "test_erng_SO2xZ2.tst" );


# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> z2 := pCyclicGroup( 2 );;
gap> ccs_names := [ "Z1", "Z2" ];;
gap> SetCCSsAbbrv( z2, ccs_names );
gap> grp := DirectProduct( so2, z2 );;
gap> erng := EulerRing( grp );;


# Show the name of the ring
gap> Display(erng);
EulerRing( DirectProduct( SpecialOrthogonalGroupOverReal( 2 ), Group( [ (1,2)
] ) ) )

# Show ring generators
gap> ring_gens := GeneratorsOfRing( erng );;
gap> Display( ring_gens[ 0, 1 ] );
Erng( <group> ) element:
1	(0,1)	SO(2) x Z1

gap> Display( ring_gens[ 0, 2 ] );
Erng( <group> ) element:
1	(0,2)	SO(2) x Z2

gap> Display( ring_gens[ 1, 1 ] );
Erng( <group> ) element:
1	(1,1)	Z_1 x Z1

gap> Display( ring_gens[ 1, 2 ] );
Erng( <group> ) element:
1	(1,2)	Z_2|Z_1 x Z1|Z2

gap> Display( ring_gens[ 1, 3 ] );
Erng( <group> ) element:
1	(1,3)	Z_1 x Z2
