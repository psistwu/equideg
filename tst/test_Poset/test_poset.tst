gap> START_TEST( "Poset" );

gap> a := [ 2, 3, 1, 1, ];;
gap> IsPoset( a );
false
gap> b := Poset( a );
[ 1, 2, 3 ]
gap> IsPoset( b );
true

gap> c := Poset( a, {i,j} -> i>j );
[ 3, 2, 1 ]
gap> IsPoset( c, {i,j} -> i>j );
true

gap> STOP_TEST( "test_poset.tst" );
