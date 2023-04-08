gap> START_TEST( "Group/setup abbreviation of CCSs" );

gap> g := SymmetricGroup( 4 );;
gap> ccss := ConjugacyClassesSubgroups( g );;
gap> abbrv_list := [ "Z1", "Z2", "D1", "Z3", "V4", "D2", "Z4", "D3",
> "D4", "A4", "S4" ];;
gap> ListA( ccss, abbrv_list, SetAbbrv );;

gap> View( ccss[1] );
(Z1)

gap> ccss[10];
(A4)

gap> ccss;
[ (Z1), (Z2), (D1), (Z3), (V4), (D2), (Z4), (D3), (D4), (A4), (S4) ]

gap> STOP_TEST( "test_ccss_abbrv.tst" );
