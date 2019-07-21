# # libSys demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  LoadPackage( "EquiDeg" );
  
# ## Demo 1: use ListA to install LaTeXString for CCSs of S4
  Print( "Take grp as group S4.... " );
  grp := SymmetricGroup( 4 );
  Print( "Done!\n" );

  Print( "Compute CCSs of S4.... " );
  ccss := ConjugacyClassesSubgroups( grp );
  Print( "Done!\n" );
  
  Print( "Setting up LaTeX string for CCSs.... " );
  name_list := [ "\\mathbb{Z}_1", "\\mathbb{Z}_2", "D_1", "\\mathbb{Z}_3",
      "V_4", "D_2", "\\mathbb{Z}_4", "D_3", "D_4", "A_4", "S_4" ];
  ListA( ccss, name_list, SetLaTeXString );
  Print( "Done!\n\n" );

  Print( List( ccss, LaTeXString ) );
