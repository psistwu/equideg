# # libSys demo
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );

  
# ## Demo 1: use ListF to install LaTeXString for CCSs of S4
  Print( "Take grp as group S4.... " );
  grp := SymmetricGroup( 4 );
  Print( "Done!\n" );

  Print( "Compute CCSs of S4.... " );
  ccss := ConjugacyClassesSubgroups( grp );
  Print( "Done!\n" );
  
  Print( "Setting up LaTeX string for CCSs.... " );
  name_list := [ "\\mathbb{Z}_1", "\\mathbb{Z}_2", "D_1", "\\mathbb{Z}_3",
      "V_4", "D_2", "\\mathbb{Z}_4", "D_3", "D_4", "A_4", "S_4" ];
  ListF( ccss, name_list, SetLaTeXString );
  Print( "Done!\n\n" );

  Print( List( ccss, LaTeXString ) );
