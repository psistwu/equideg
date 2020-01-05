gap> START_TEST("test1.tst");
gap> g := SymmetricGroup(4);;
gap> ccs := ConjugacyClassesSubgroups(g);;

# test setup ccs names
gap> ccs_names := ["Z1", "Z2", "D1", "Z3", "V4", "D2",
> "Z4", "D3", "D4", "A4", "S4"];;
gap> SetCCSsAbbrv(g, ccs_names);
gap> ccs;
[ (Z1), (Z2), (D1), (Z3), (V4), (D2), (Z4), (D3), (D4), (A4), (S4) ]

# find maximal orbit types
gap> chi := Irr(g)[2] + Irr(g)[3];;
gap> MaximalOrbitTypes(chi);
[ (Z3), (D4) ]
gap> STOP_TEST("test1.tst");
