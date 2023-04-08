gap> START_TEST( "Group/nLHnumber" );

gap> g := SymmetricGroup( 4 );;
gap> ccss := ConjugacyClassesSubgroups( g );;
gap> List( ccss, OrderOfWeylGroup );
[ 24, 4, 2, 2, 6, 2, 2, 1, 1, 2, 1 ]

gap> STOP_TEST( "test_weyl_group.tst" );
