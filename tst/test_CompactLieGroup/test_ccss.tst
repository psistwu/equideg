gap> START_TEST( "abbrv.tst" );

gap> g := OrthogonalGroupOverReal( 2 );;
gap> ccss := ConjugacyClassesSubgroups( g );;

gap> View( ccss );
<Conjugacy Classes of Subgroups of O( 2 )>

gap> Print( ccss );
ConjugacyClassesSubgroups( OrthogonalGroupOverReal( 2 ) )

gap> Display( ccss );
Conjugacy Classes of Subgroups of O( 2 )
----------------------------------------
Zero Mode           (SO(2))
                    (O(2))
Nonzero Mode        (Z_n)   (n>0)
                    (D_n)   (n>0)
----------------------------------------

gap> HasPrototypes( ccss );
true

gap> Prototypes( ccss );
[ [ <SO(2)>, <O(2)> ], [ <Z_n>, <D_n> ] ]

gap> Prototypes( ccss, 0 );
[ <SO(2)>, <O(2)> ]

gap> Prototypes( ccss, 1 );
[ <Z_n>, <D_n> ]
