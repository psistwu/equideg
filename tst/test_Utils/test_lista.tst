gap> START_TEST("abbrv.tst");
gap> a := [ 1, 2, 3 ];;
gap> b := [ "a", "aa", "aa" ];;
gap> my_func := function(i, s) return Length( s ) = i; end;;
gap> ListA( a, b, my_func );
[ [ true ], [ true ], [ false ] ]
