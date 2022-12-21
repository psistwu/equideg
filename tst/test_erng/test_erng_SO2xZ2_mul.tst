gap> START_TEST( "test_erng_SO2xZ2_mul.tst" );


# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> z2 := pCyclicGroup( 2 );;
gap> ccs_names := [ "Z1", "Z2" ];;
gap> SetCCSsAbbrv( z2, ccs_names );
gap> grp := DirectProduct( so2, z2 );;
gap> erng := EulerRing( grp );;


# take some ring elements of degree zero
gap> erng_basis := Basis( erng );;
gap> a := erng_basis[ 0, 1 ];;
gap> b := erng_basis[ 0, 2 ];;

# Verify multiplication
gap> Display( a*a );
Erng( <group> ) element:
2	(0,1)	SO(2) x Z1

gap> Display( a*b );
Erng( <group> ) element:
1	(0,1)	SO(2) x Z1

gap> Display( b*a );
Erng( <group> ) element:
1	(0,1)	SO(2) x Z1

gap> Display( b*b );
Erng( <group> ) element:
1	(0,2)	SO(2) x Z2
