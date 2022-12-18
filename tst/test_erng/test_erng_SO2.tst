gap> START_TEST( "test_erng_SO2.tst" );

# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> erng := EulerRing( so2 );;


# Show the name of the ring
gap> Display( erng );
EulerRing( SpecialOrthogonalGroupOverReal( 2 ) )


# Show ring generators
gap> ring_gens := GeneratorsOfRing( erng );;
gap> Display( ring_gens[ 0, 1 ] );
Erng( <group with 1 generators> ) element:
1	(0,1)	SO(2)

gap> Display( ring_gens[ 1, 1 ] );
Erng( <group with 1 generators> ) element:
1	(1,1)	Z_1
