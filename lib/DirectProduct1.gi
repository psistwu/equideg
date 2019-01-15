#############################################################################
##
#W  DirerctProduct1.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for procedures
##  related to direct product of finite groups.
##

#############################################################################
##
#O  DirectProductDecomposition( <G> )
##
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a group",
    [ IsGroup ],
    function( G )
      if HasDirectProductInfo( G ) then
        return DirectProductInfo( G ).groups;
      else
        return [ G ];
      fi;
    end
  );

#############################################################################
##
#O  DirectProductDecomposition( <C> )
##
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a CC of a group",
    [ IsConjugacyClassGroupRep ],
    function( C )
      local G,		# group
            G_decomp,	# list of direct product components of grp
            e,		# representative of C
            e_decomp,	# list of direct product components of elm
            comp,	# direct product component of cc
            C_decomp,	# list of direct product components of cc
            i;		# index

      G := ActingDomain( C );
      G_decomp := DirectProductDecomposition( G );
      e := Representative( C );
      e_decomp := DirectProductDecomposition( G, e );
      C_decomp := [ ];
      for i in [ 1 .. Size( G_decomp ) ] do
        comp := ConjugacyClass( G_decomp[ i ], e_decomp[ i ] );
        Add( C_decomp, comp );
      od;

      return C_decomp;
    end
  );

#############################################################################
##
#O  DirectProductDecomposition( <chi> )
##
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a irredicible character of a group",
    [ IsCharacter ],
    function( chi )
      local G,			# group
            G_comp,		# direct product component of G
            G_decomp,		# list of direct product components of G
            G_CCs,		# conjugacy classes of G
            d,			# number of direct product components
            embed,		# embedding from G to its direct product component
            G_comp_CCs,		# CCs of a direct product component of G
            G_CC_list,		# CC list in G corresponding to CCs of its direct product component
            res_chi,		# restricted character of chi
            psi,		# irreducible character of a direct product component of G
            chi_decomp,		# direct product decomposition of chi
            i;			# index

      if not IsIrreducibleCharacter( chi ) then
        Error( "It works only for irreducble character." );
      fi;

      G := UnderlyingGroup( chi );
      G_decomp := DirectProductDecomposition( G );
      d := Size( G_decomp );
      if ( d = 1 ) then
        return [ chi ];
      fi;
      G_CCs := ConjugacyClasses( G );

      chi_decomp := [ ];
      for i in [ 1 .. d ] do
        G_comp := G_decomp[ i ];
        embed := Embedding( G, i );
        G_comp_CCs := ConjugacyClasses( G_comp );
        G_CC_list := List( G_comp_CCs,
            c -> ConjugacyClass( G, Image( embed, Representative( c ) ) ) );
        res_chi := ClassFunction( G_comp, chi{ List( G_CC_list, IdCC ) } );

        for psi in Irr( G_comp ) do
          if ScalarProduct( res_chi, psi ) > 0 then
            Add( chi_decomp, psi );
            break;
          fi;
        od;
      od;

      return chi_decomp;
    end
  );

#############################################################################
##
#O  DirectProductDecomposition( <G>, <e> )
##
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a group element",
    [ IsGroup, IsMultiplicativeElementWithInverse ],
    function( G, e )
      local d,		# number of direct product components of <G>
            proj,	# projection
            i,		# index
            decomp;	# the direct product decomposition of <e>

      d := Size( DirectProductDecomposition( G ) );

      if ( d = 1 ) then
        decomp := [ e ];
      else
        decomp := [ ];
        for i in [ 1 .. d ] do
          proj := Projection( G, i );
          Add( decomp, Image( proj, e ) );
        od;
      fi;

      return decomp;
    end
  );

#############################################################################
##
#A  GoursatInfo( <U> )
##
  InstallMethod( GoursatInfo,
    "return the Goursat info of a subgroup",
    [ IsGroup and HasParentAttr ],
    function( U )
      local G,		# the parent group G=G1xG2
	    proj1,	# projection to G1
	    proj2,	# projection to G2
	    embed1,	# embedding from G1
	    embed2,	# embedding from G2
	    H1, H2,	# projection of the subg to G1 and G2
            Z1, Z2,	# kernels of the homomorphisms from H1 and H2 to L
            L,		# generators of H1 which determine the homomorphism
            proj1_U;	# restricted projection1 to subg

      # take the parent group
      G := ParentAttr( U );

      # the procedure works only when
      # the parent group is direct product of two groups
      if not ( Size( DirectProductDecomposition( G ) ) = 2 ) then
        Error( "It has to be a subgroup of the direct product of TWO groups!" );
      fi;

      # in addition, this procedure works only when <G> is finite
      if not IsFinite( G ) then
        TryNextMethod( );
      fi;

      # take the projections and embeddings
      proj1 := Projection( G, 1 );
      proj2 := Projection( G, 2 );
      embed1 := Embedding( G, 1 );
      embed2 := Embedding( G, 2 );

      # take essential subgroups
      H1 := Image( proj1, U );
      Z1 := Image( proj1, Intersection( Image( embed1 ), U ) );
      H2 := Image( proj2, U );
      Z2 := Image( proj2, Intersection( Image( embed2 ), U ) );

      proj1_U := RestrictedMapping( proj1, U );
      L := RightCosets( U, PreImages( proj1_U, Z1 ) );

      return [ H1, Z1, Z2, H2, L ];
    end
  );

#############################################################################
##
#O  AmalgamationSymbol( <C> )
##
  InstallMethod( AmalgamationSymbol,
    "return the amalgamation symbol of a CCS of direct product of two groups",
    [ IsConjugacyClassSubgroupsRep ],
    function( C )
      local G,			# group
            U,			# representative of C
            U_ginfo,		# Goursat info of subg
            quad,
            symbol,		# the returning symbol
            C2,			# conjugacy class of subgroups
            name_list;	# name list of CCSs

      G := ActingDomain( C );
      if not ( Size( DirectProductDecomposition( G ) ) = 2 ) then
        Error( "It has to be a CCS of the direct product of TWO groups." );
      fi;

      U := Representative( C );
      U_ginfo := GoursatInfo( U );
      quad := List( U_ginfo{ [ 1 .. 4 ] }, ConjugacyClassSubgroups );

      name_list := [ ];
      for C2 in quad do
        if HasName( C2 ) then
          Add( name_list, Name( C2 ) );
        else
          Add( name_list, String( IdCCS( C2 ) ) );
        fi;
      od;

      return StringFormatted( "[{}|{}|{}|{}]",
          name_list[ 1 ],
          name_list[ 2 ],
          name_list[ 3 ],
          name_list[ 4 ]  );
    end
  );

#############################################################################
##
#O  LaTeXTypesetting( <C>, <str> )
##
  InstallOtherMethod( LaTeXTypesetting,
    "return LaTeX typesetting of a CCS",
    [ IsConjugacyClassSubgroupsRep, IsString ],
    1,
    function( C, str )
      local G,
            U,
            U_ginfo,
            latex_list;

      G := ActingDomain( C );
      if not ( Size( DirectProductDecomposition( G ) ) = 2 ) then
        TryNextMethod( );
      fi;

      U := Representative( C );
      U_ginfo := GoursatInfo( U );
      latex_list := List( U_ginfo{ [ 1 .. 4 ] },
          S -> LaTeXString( ConjugacyClassSubgroups( S ) ) );

      return StringFormatted( "\\amal{{{}}}{{{}}}{{{}}}{{{}}}{{{}}}",
        latex_list[ 1 ],
        latex_list[ 2 ],
        str,
        latex_list[ 3 ],
        latex_list[ 4 ]  );
    end
  );

#############################################################################
##
#O  LaTeXTypesetting( <C> )
##
  InstallMethod( LaTeXTypesetting,
    "return LaTeX typesetting of a CCS",
    [ IsConjugacyClassSubgroupsRep ],
    1,
    function( C )
      local G;

      if HasLaTeXString( C ) then
        return LaTeXString( C );
      fi;

      G := ActingDomain( C );
      if not ( Size( DirectProductDecomposition( G ) ) = 2 ) then
        TryNextMethod( );
      fi;

      return LaTeXTypesetting( C, "" );
    end
  );


#############################################################################
##
#E  DirectProduct1.gi . . . . . . . . . . . . . . . . . . . . . . . ends here
