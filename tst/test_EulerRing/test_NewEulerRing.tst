gap> START_TEST("test_NewEulerRing.tst");
gap> so2 := SpecialOrthogonalGroupOverReal(2);;

# find maximal orbit types
gap> erng := EulerRing(so2);;
gap> ring_gens := GeneratorsOfRing(erng);;
gap> Display(ring_gens[1,1]);
Erng( <group with 1 generators> ) element:
1	(1,1)	Z_1
