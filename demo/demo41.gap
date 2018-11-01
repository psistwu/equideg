# # demo41
# Create latex file about CCSs of D3xD3xZ2
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

  # preload
  LIB_LIST := [ "Sys", "BasicMath", "Group", "DirectProduct" , "OrbitType", "BurnsideRing" ];
  MakeReadOnlyGlobal( "LIB_LIST" );
  Read( "../preload.gap" );


# ## Setup
  Print( "=== Setup ===\n" );
  Print( "Take grp1 = D3, grp2 = Z2, grp3 = D3xZ2, grp = D3x(D3xZ2).... " );
  grp1 := SymmetricGroup( 3 );
  grp2 := SymmetricGroup( 2 );
  grp3 := DirectProduct( grp1, grp2 );
  grp := DirectProduct( grp1, grp3 );
  Print( "Done!\n" );
  Print( "Compute CCSs of grp1, grp2, grp3 and grp.... " );
  ccss_grp1 := ConjugacyClassesSubgroups( grp1 );
  ccss_grp2 := ConjugacyClassesSubgroups( grp2 );
  ccss_grp3 := ConjugacyClassesSubgroups( grp3 );
  ccss_grp := ConjugacyClassesSubgroups( grp );
  Print( "Done!\n\n\n" );


# ## Demo 1: setup names and LaTeX typesettings
  Print( "=== Demo 1 ===\n" );

  # setup names for CCSs of grp1 (D3)
  Print( "Setup names for CCSs of grp1 (D3).... " );
  ccss_grp1_names := [ "Z_1", "D_1", "Z_3", "D_3" ];
  ListF( ccss_grp1, ccss_grp1_names, SetName );
  Print( "Done!\n" );

  # setup LaTeX typesettings for CCSs of grp1 (D3)
  Print( "Setup LaTeX typesettings for CCSs of grp1 (D3).... " );
  ccss_grp1_latex := [ "\\mathbb{Z}_1", "D_1", "\\mathbb{Z}_3", "D_3" ];
  ListF( ccss_grp1, ccss_grp1_latex, SetLaTeXString );
  Print( "Done!\n" );

  # setup names for CCSs of grp3 (D3xZ2)
  Print( "Setup names for CCSs of grp4 (D3xZ2).... " );
  ccss_grp3_names := [ "Z_1", "Z_1^p", "D_1", "D_1^z", "Z_3",
      "D_1^p", "Z_3^p", "D_3", "D_3^z", "D_3^p" ];
  ListF( ccss_grp3, ccss_grp3_names, SetName );
  Print( "Done!\n" );

  # setup LaTeX typesettings for CCSs of grp3 (D3xZ2)
  Print( "Setup LaTeX typesettings for CCSs of grp4 (D3xZ2).... " );
  ccss_grp3_latex := [ "\\mathbb{Z}_1", "\\mathbb{Z}_1^p", "D_1", "D_1^z",
      "\\mathbb{Z}_3", "D_1^p", "\\mathbb{Z}_3^p", "D_3", "D_3^z", "D_3^p" ];
  ListF( ccss_grp3, ccss_grp3_latex, SetLaTeXString );
  Print( "Done!\n" );

  # setup names for CCSs of grp (D3x(D3xZ2))
  Print( "Setup names for CCSs of grp (D3x(D3xZ2)).... " );
  ccss_grp_names := List( ccss_grp, AmalgamationSymbol );
  ListF( ccss_grp, ccss_grp_names, SetName );
  Print( "Done!\n" );

  # setup LaTeX typesettings for CCSs of grp (D3x(D3xZ2))
  Print( "Setup LaTeX typesettings for CCSs of grp (D3x(D3xZ2)).... " );
  ccss_grp_latex := List( ccss_grp, LaTeXTypesetting );
  ListF( ccss_grp, ccss_grp_latex, SetLaTeXString );
  Print( "Done!\n\n\n" );


# ## Demo 2: generate the lattice of CCSs of grp (D3x(D3xZ2))
  Print( "=== Demo 2 ===\n" );

  # generate CCS lattice of grp
  latccs_grp := LatticeCCSs( grp );
  Print( "Generating dot file for CCS lattice of D3xD3xZ2.... " );
  DotFileLattice( latccs_grp, "demo41/latccs_d3xd3xz2.dot" );
  Print( "Done!\n" );
  Print( "(Please check folder ./demo41)\n" );

  # take V as a representation of grp
  Print( "Take V as a representation of D3xD3xZ2.... " );
  irr_grp := Irr( grp );
  chiV := irr_grp[ 18 ] + irr_grp[ 5 ] + irr_grp[ 10 ] + irr_grp[ 14 ];
  Print( "Done!\n" );

  # generate orbit type lattice of V
  Print( "Generating dot file for orbit types lattice of D3xD3xZ2.... " );
  latOrbitTypesV := LatticeOrbitTypes( chiV );
  DotFileLattice( latOrbitTypesV, "./demo41/latorbittypesV.dot" );
  Print( "Done!\n" );
  Print( "(Please check folder ./demo41)\n\n\n" );

# ## Demo 2: compute basic degrees of all irreducible G:=D3xD3xZ2-representations
  Print( "=== Demo 2 ===\n" );

  # generate A(D3x(D3xZ2))
  Print( "Generating Burnside ring A(D3xD3xZ2).... " );
  brng := BurnsideRing( grp );
  basis := Basis( brng );
  Print( "Done!\n\n" );

  # compute basic degrees of all irreducible representations of grp
  Print( "Compute basic degrees of all irreducible representations of grp.... " );
  irr_list := Irr( grp );
  bdeg_list := List( irr_list, irr -> BasicDegree( irr ) );
  Print( "Done!\n\n" );

  Print( "All basic degrees:\n" );
  for bdeg in bdeg_list do
    Print( bdeg, "\n" );
  od;
  Print( "\n\n" );


# ## Demo 3: create LaTeX file for grp
  Print( "=== Demo 3 ===\n" );

  Print( "Creating LaTeX file for D3xD3xZ2.... " );
  texfile := "./demo41/D3D3Z2_test.tex";

  # preamble
  PrintTo( texfile, "  \\documentclass[11pt]{article}\n\n" );
  AppendTo( texfile, "  \\usepackage{amssymb,amsmath,amsfonts}\n" );
  AppendTo( texfile, "  \\usepackage[top=1cm,bottom=1cm,left=2cm,right=2cm]{geometry}\n" );
  AppendTo( texfile, "  \\usepackage{tabularx}\n" );
  AppendTo( texfile, "  \\usepackage{mathtools}\n" );
  AppendTo( texfile, "  \\usepackage{booktabs}\n" );
  AppendTo( texfile, "  \\usepackage{graphicx}\n\n" );

  # macro
  AppendTo( texfile, "  \\newcommand{\\amal}[5]{#1\\prescript{#2}{}{\\underset{#3}{\\times}}^{#4}#5}\n" );
  AppendTo( texfile, "  \\newcolumntype{C}{>{\\centering\\arraybackslash}X}\n\n" );

  # enviroment
  AppendTo( texfile, "  \\pagestyle{empty}\n\n" );

  # main body
  AppendTo( texfile, "  \\begin{document}\n" );
  AppendTo( texfile, "  \\begin{table}\n" );
  AppendTo( texfile, "    \\centering\n" );
  AppendTo( texfile, "    \\begin{tabularx}{.6\\textwidth}{@{}|c|C||c|C|@{}}\n" );
  AppendTo( texfile, "      \\toprule\n" );
  AppendTo( texfile, "      Number & Name & Number & Name \\\\\n" );
  AppendTo( texfile, "      \\midrule\n" );

  # table content
  for k in [ 1 .. 35 ] do
    AppendTo( texfile, "      " );
    AppendTo( texfile, "$", 2*k-1, "$ & " );
    AppendTo( texfile, "$", LaTeXTypesetting( ccss_grp[2*k-1]), "$ & " );
    if ( k < 35 ) then
      AppendTo( texfile, "$", 2*k, "$ & " );
      AppendTo( texfile, "$", LaTeXTypesetting( ccss_grp[2*k] ), "$ " );
    else
      AppendTo( texfile, "& " );
    fi;
    AppendTo( texfile, "\\\\\n" );
  od;

  AppendTo( texfile, "      \\bottomrule\n" );
  AppendTo( texfile, "    \\end{tabularx}\n" );
  AppendTo( texfile, "  \\end{table}\n" );
  AppendTo( texfile, "  \\end{document}\n" );
  Unbind( texfile );
  Print( "Done!\n\n\n" );

