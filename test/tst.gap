  LoadPackage( "EquiDeg" );

  # Group S4
  s4 := SymmetricGroup( 4 );
  CCSs_s4 := ConjugacyClassesSubgroups( s4 );
  names := [ "Z1", "Z2", "D1", "Z3", "V4",
             "D2", "Z4", "D3", "D4", "A4", "S4" ];
  ListA( CCSs_s4, names, SetAbbrv );

  tbls4 := CharacterTable( s4 );
  irrs_s4 := Irr( s4 );
# chi := irrs_s4[ 2 ];

  # Group O(2)
  o2 := OrthogonalGroupOverReal( 2 );
  CCSs_o2 := ConjugacyClassesSubgroups( o2 );

  tblo2 := CharacterTable( o2 );
  irrs_o2 := Irr( o2 );
# psi := irrs_o2[ 2 ];

  # Group SO(2)
  so2 := SpecialOrthogonalGroupOverReal( 2 );
  CCSs_so2 := ConjugacyClassesSubgroups( so2 );

  tblso2 := CharacterTable( so2 );
  irrs_so2 := Irr( tblso2 );
# phi := irrs_so2[ -1 ];

  # Group O(2)xS4
  o2xs4 := DirectProduct( o2, s4 );
  CCSs_o2xs4 := ConjugacyClassesSubgroups( o2xs4 );

  tblo2xs4 := CharacterTable( o2xs4 );
  irrs_o2xs4 := Irr( o2xs4 );
