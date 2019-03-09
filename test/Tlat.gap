LoadPackage("EquiDeg");

a := [ 1, 2 ];
r := rec( poset := a,
          node_labels := [ "x", "y" ],
          node_shapes := [ "circle", "square" ],
          rank_legend := "what",
          ranks := [ 1, 2 ],
          is_rank_reversed := false );
lat := NewLattice( IsLatticeRep, r );
