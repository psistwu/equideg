  LoadPackage( "EquiDeg" );

  x := X( Integers, "x" );

  # O(2)
  o2 := OrthogonalGroupOverReal( 2 );

  # S_4
  s4 := SymmetricGroup( 4 );
  CCSs_s4 := ConjugacyClassesSubgroups( s4 );
  names := [ "Z1", "Z2", "D1", "Z3", "V4",
             "D2", "Z4", "D3", "D4", "A4", "S4" ];
  ListA( CCSs_s4, names, SetAbbrv );

  # S_3
  s3 := SymmetricGroup( 3 );

  # S_2
  s2 := SymmetricGroup( 2 );

  # S_3xS_2
  Ga := DirectProduct( s3, s2 );

  # O(2) x S_4
  G := DirectProduct( o2, s4 );
  CCSs_G := ConjugacyClassesSubgroups( G );
