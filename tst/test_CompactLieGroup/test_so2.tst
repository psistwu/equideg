gap> START_TEST( "abbrv.tst" );

gap> so2 := SpecialOrthogonalGroupOverReal( 2 );;
gap> Print( so2 );
SpecialOrthogonalGroupOverReal( 2 )
gap> so2;
SO(2;R)

gap> ccss := ConjugacyClassesSubgroups( g );;
gap> View( ccss );
<Conjugacy Classes of Subgroups of SO(2;R)>
gap> Print( ccss );
ConjugacyClassesSubgroups( SpecialOrthogonalGroupOverReal( 2 ) )

gap> HasPrototypes( ccss );
true
gap> Prototypes( ccss );
[ [ <SO(2;R)> ], [ <Z_n> ] ]
gap> Prototypes( ccss, 0 );
[ <SO(2)> ]
gap> Prototypes( ccss, 1 );
[ <Z_n> ]

gap> Display( ccss );
Conjugacy Classes of Subgroups of SO(2;R)
-----------------------------------------
Zero Mode           (SO(2;R))
Nonzero Mode        (Z_n)   (n>0)
-----------------------------------------
