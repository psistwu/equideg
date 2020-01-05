# setup <gr1>=O(2)
# irreducible representations of <gr1> is indexed by -1, 0, 1, 2, ...
gap> gr1 := OrthogonalGroupOverReal(2);;
gap> ccs_gr1 := ConjugacyClassesSubgroups(gr1);
ConjugacyClassesSubgroups( OrthogonalGroupOverReal( 2 ) )
gap> irr_gr1_list := Irr(gr1);
Irr( OrthogonalGroupOverReal( 2 ) )

# setup <gr1>=O(2)
# irreducible representations of <gr2> is indexed by 1, 2, ..., 6
gap> gr2 := DirectProduct(pDihedralGroup(3),SymmetricGroup(2));;
gap> ccs_gr2 := ConjugacyClassesSubgroups(gr2);;
gap> ccs_gr2_names := ["Z1", "Z1p", "D1", "D1z", "Z3", "D1p", "Z3p",
> "D3" , "D3z", "D3p"];;
gap> SetCCSsAbbrv(gr2, ccs_gr2_names);;
gap> irr_gr2_list := Irr(gr2);;

# setup <G>=<gr1>x<gr2>
# irreducible representations of <G> is inedxed by [i,j]
# where i = -1, 0, 1, 2, ...
gap> G := DirectProduct(gr1, gr2);;
gap> ccs := ConjugacyClassesSubgroups(G);;
gap> irr_list := Irr(G);;

# Take two irreducible characters and find their maximal orbit types
gap> chi := irr_list[2, 4];;
gap> psi := irr_list[1, 2];;
gap> maxorbtyps_chi := MaximalOrbitTypes(chi);
[ (D_4|D_2 x Z3p|D3p) ]
gap> maxorbtyps_psi := MaximalOrbitTypes(psi);
[ (D_2|D_1 x D3z|D3p) ]

# Find maximal orbit types of chi+psi
gap> maxorbtyps := MaximalElements(Union(maxorbtyps_chi,maxorbtyps_psi));
[ (D_2|D_1 x D3z|D3p), (D_4|D_2 x Z3p|D3p) ]
