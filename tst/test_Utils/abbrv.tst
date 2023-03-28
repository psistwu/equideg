gap> START_TEST("abbrv.tst");
gap> g := SymmetricGroup(4);;
gap> HasAbbrv( g );
false

gap> SetAbbrv( g, "S4" );;
gap> HasAbbrv( g );
true

gap> Abbrv( g );
"S4"

gap> ResetAbbrv( g );;
gap> HasAbbrv( g );
false
