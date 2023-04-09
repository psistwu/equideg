gap> START_TEST( "Group/elementary group" );

gap> g := pCyclicGroup( 10 );;
gap> Print( g );
pCyclicGroup( 10 )
gap> Order( g );
10

gap> g := pDihedralGroup( 10 );;
gap> Print( g );
pDihedralGroup( 10 )
gap> Order( g );
20

gap> g := mCyclicGroup( 10 );;
gap> Print( g );
mCyclicGroup( 10 )
gap> Order( g );
10

gap> g := mDihedralGroup( 10 );;
gap> Print( g );
mDihedralGroup( 10 )
gap> Order( g );
20

gap> STOP_TEST( "test_elementary_group.tst" );
