LoadPackage("EquiDeg");

a := [ 1, 2 ];
r := rec( poset := a,
          node_labels := [ "x", "y" ],
          node_shapes := [ "circle", "square" ],
          rank_label := "what",
          ranks := [ 1, 2 ],
          is_rank_reversed := false );
lat := NewLattice( IsLatticeRep, r );

g := SymmetricGroup( 4 );
lat2 := LatticeCCSs( g );

chi := Irr( g )[ 2 ];
lat3 := LatticeOrbitTypes( chi );

o2 := OrthogonalGroupOverReal( 2 );
G := DirectProduct( o2, g );
psi := Irr( G )[ 0, 2 ];
lat4 := LatticeOrbitTypes( psi );
