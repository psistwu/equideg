gap> START_TEST("test_erng_SO2_mul.tst");


# Create Euler ring of SO2
gap> so2 := SpecialOrthogonalGroupOverReal(2);;
gap> erng := EulerRing(so2);;
gap> ring_gens := GeneratorsOfRing(erng);;


# take some ring elements
gap> a := ring_gens[0,1];;
gap> b := ring_gens[1,1];;


# test addition and scalar multiplication
gap> Display(a * a);
Erng( <group with 1 generators> ) element:
1	(0,1)	SO(2)

gap> Display(a * b);
Erng( <group with 1 generators> ) element:
1	(1,1)	Z_1

gap> Display(b * a);
Erng( <group with 1 generators> ) element:
1	(1,1)	Z_1

gap> b*b;
<> in Erng( <group with 1 generators> )
gap> IsZero(b*b);
true
