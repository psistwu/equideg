# # libBurnsideRing demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "OrbitType", "BurnsideRing" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


# ## Demo 1: compute basic degrees of all irreducible (S_4)-representations
  Print( "=== Demo 1 ===\n" );
  Print( "Generating Burnside ring A(S4)...." );
  grp := SymmetricGroup( 4 );
  ccss := ConjugacyClassesSubgroups( grp );
  brng := BurnsideRing( grp );
  basis := Basis( brng );
  Print( "Done!\n\n" );

  # setup names of all CCSs of grp (S4)
  Print( "Setup names for CCSs of grp (S4).... " );
  ccss_names := [ "Z1", "Z2", "D1", "Z3", "V4", "D2",
      "Z4", "D3", "D4", "A4", "S4" ];
  ListF( ccss, ccss_names, SetName );
  Print( "Done!\n" );

  Print( "Compute Basic degree of each S4-irreducible representation.... " );
  irr_list := Irr( grp );
  bdeg_list := List( irr_list, irr -> BasicDegree( irr ) );
  Print( "Done!\n\n" );

  Print( "All basic degrees:\n");
  for bdeg in bdeg_list do
    Print( bdeg, "\n" );
  od;
  Print( "\n" );

  Print( "Squares of all basic degrees (follow the same order):\n" );
  for bdeg in bdeg_list do
    Print( bdeg^2, "\n" );
  od;
  Print( "\n\n" );

# ## Demo 2: generate LaTeX typesetting for Burnside ring elements
  Print( "=== Demo 2 ===\n" );

  # setup LaTeX names of all CCSs of grp1 (S4)
  Print( "Setup LaTeX typesettings for CCSs of grp1 (S4).... " );
  latex_names := [ "\\mathbb{Z}_1", "\\mathbb{Z}_2", "D_1", "\\mathbb{Z}_3",
      "V_4", "D_2", "\\mathbb{Z}_4", "D_3", "D_4", "A_4", "S_4" ];
  ListF( ccss, latex_names, SetLaTeXString );
  Print( "Done!\n" );

  # print LaTeX Typesettings for all basic degrees
  Print( "LaTeX Typesettings for all basic degrees:\n" );
  Print( List( bdeg_list, LaTeXTypesetting ) );


