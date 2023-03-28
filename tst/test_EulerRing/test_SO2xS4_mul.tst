gap> START_TEST( "test_erng_SO2xZ2_mul.tst" );


# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> s4 := SymmetricGroup( 4 );;
gap> ccs_names := [ "Z1", "Z2", "D1", "Z3", "V4", "D2", "Z4", "D3", "D4", "A4", "S4" ];;
gap> SetCCSsAbbrv( s4, ccs_names );
gap> grp := DirectProduct( so2, s4 );;
gap> ccss := ConjugacyClassesSubgroups( grp );;
gap> erng := EulerRing( grp );;


# take some ring elements of degree zero
gap> erng_basis := Basis( erng );;
gap> a := erng_basis[ 0, 11 ];;

gap> for i in [ 1 .. 10 ] do
> b := erng_basis[ Random( [ 1 .. NumberOfNonzeroModeClasses( ccss ) ] ), Random( [ 1 .. 5 ] ) ];;
> Print( a * b = b, "\n" );
> od;
true
true
true
true
true
true
true
true
true
true
