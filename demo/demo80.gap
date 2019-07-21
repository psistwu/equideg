  LoadPackage( "EquiDeg" );

  # O(2)
  o2 := OrthogonalGroupOverReal( 2 );
  CCSs_o2 := ConjugacyClassesSubgroups( o2 );
  list_latexstring := [ "\\mathrm{SO}(2)", "\\mathrm{O}(2)", "\\bbZ_{}", "D_{}" ];
  SetCCSsLaTeXString( o2, list_latexstring );

  # S4
  s4 := SymmetricGroup( 4 );
  CCSs_s4 := ConjugacyClassesSubgroups( s4 );
  list_abbrv := [ "Z1", "Z2", "D1", "Z3", "V4", "D2", "Z4",
      "D3", "D4", "A4", "S4" ];
  SetCCSsAbbrv( s4, list_abbrv );
  list_latexstring := [ "\\bbZ_1", "\\bbZ_2", "D_1", "\\bbZ_3",
      "V_4", "D_2", "\\bbZ_4", "D_3", "D_4", "A_4", "S_4" ];
  SetCCSsLaTeXString( s4, list_latexstring );

  # O(2) x S4
  g := DirectProduct( o2, s4 );
  CCSs_g := ConjugacyClassesSubgroups( g );
  C := CCSs_g[ 1, 3 ];
