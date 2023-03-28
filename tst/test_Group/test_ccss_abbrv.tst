gap> START_TEST( "abbrv.tst" );

gap> g := SymmetricGroup( 4 );;
gap> ccss := ConjugacyClassesSubgroups( g );;
gap> abbrv_list := [ "(Z1)", "(Z2)", "(D1)", "(Z3)", "(V4)", "(D2)",
> "(Z4)", "(D3)", "(D4)", "(A4)", "(S4)" ];;
gap> SetCCSsAbbrv( g, abbrv_list );;

gap> ccss[1];
(Z1)

gap> ccss[10];
(A4)

gap> ccss;
[ (Z1), (Z2), (D1), (Z3), (V4), (D2), (Z4), (D3), (D4), (A4), (S4) ]
