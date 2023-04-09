gap> START_TEST( "Utils/Abbrv" );

gap> g := SymmetricGroup(4);;
gap> HasAbbrv( g );
false

gap> SetAbbrv( g, "S4" );;
gap> HasAbbrv( g );
true

gap> Abbrv( g );
"S4"

gap> SetAbbrv( g, "S_4" );;
gap> Abbrv( g );
"S_4"

gap> STOP_TEST( "test_abbrv.tst" );
