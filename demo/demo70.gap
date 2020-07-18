  # load the package
  LoadPackage( "equideg" );

  # create group O(2)
  o2 := OrthogonalGroupOverReal( 2 );

  # create group S_4 and name its CCSs
  s4 := SymmetricGroup( 4 );
  CCSs_s4 := ConjugacyClassesSubgroups( s4 );
  names := [ "Z_1", "Z_2", "D_1", "Z_3", "V_4",
             "D_2", "Z_4", "D_3", "D_4", "A_4", "S_4" ];
  ListA( CCSs_s4, names, SetAbbrv );

  # create group G = O(2)xS_4
  G := DirectProduct( o2, s4 );
  CCSs_G := ConjugacyClassesSubgroups( G );

  # create irreducible G-representations with index [ 2, 3 ],
  # which is the tensor product of
  # irreducible O(2)-representation with index 2
  # (for O(2), the index is ranging from -1 to infinity) and
  # irreducible S_4-representation with index 3
  # (for S_4, the index is ranging from 1 to 5)
  chi := Irr( G )[ 2 , 3 ];
  
  # compute the basic degree of chi
  bdeg_chi := BasicDegree( chi );
  View( bdeg_chi );
  Print( "\n" );

  # compute the basic degree of another irreducible G-representation
  psi := Irr( G )[ -1, 2 ];
  bdeg_psi := BasicDegree( psi );
  View( bdeg_psi );
  Print( "\n" );

  # compute the product of basic degrees
  prod := bdeg_chi * bdeg_psi;
  View( prod );
  Print( "\n" );

  # One can use "Print" to obtain a detail formatting
  # for Burnside ring elements
  Print( bdeg_psi );

  # find maximal orbit types of the product
  max_orbts := MaximalCCSs( prod );
  View( max_orbts );
  Print( "\n" );
