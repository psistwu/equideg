gap> START_TEST( "test_erng_SO2xZ2_mul.tst" );


# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> z2 := pCyclicGroup( 2 );;
gap> ccs_names := [ "Z1", "Z2" ];;
gap> SetCCSsAbbrv( z2, ccs_names );
gap> grp := DirectProduct( so2, z2 );;
gap> erng := EulerRing( grp );;


# take some ring elements
gap> a := ring_gens[ 0, 1 ];;
gap> b := ring_gens[ 1, 1 ];;
