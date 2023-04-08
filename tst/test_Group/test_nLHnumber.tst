gap> START_TEST( "Group/nLHnumber" );

gap> g := SymmetricGroup( 4 );;
gap> ccss := ConjugacyClassesSubgroups( g );;
gap> result1 := ListX( ccss, ccss, nLHnumber );;
gap> result2 := ListX( List( ccss, Representative ),
> List( ccss, Representative), nLHnumber );;

gap> result1 = result2;
true

gap> STOP_TEST( "test_nLHnumber.tst" );
