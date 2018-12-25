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
#A  DirectProductComponents( <G> )
##
  InstallMethod( DirectProductComponents,
    "return the list of direct product components of a group",
    [ IsGroup ],
    function( grp )
      if HasDirectProductInfo( grp ) then
        return DirectProductInfo( grp ).groups;
      else
        return [ grp ];
      fi;
    end
  );

#############################################################################
##
#A  GoursatInfo( <U> )
##
  InstallMethod( GoursatInfo,
    "return the Goursat info of a subgroup",
    [ IsGroup and HasParentAttr ],
    function( subg )
      local grp,		 # the parent group grp=grp1xgrp2
	        proj1,		 # projection to grp1
	        proj2,		 # projection to grp2
	        embed1,		 # embedding from grp1
	        embed2,		 # embedding from grp2
	        h1, h2,      # projection of the subg to grp1 and grp2
            z1, z2,      # kernels of the homomorphisms from H1 and H2 to L
            z,           # direct product of Z1 and Z2
            cosets,      # generators of H1 which determine the homomorphism
            sproj1;      # restricted projection1 to subg

      # take the parent group
      grp := ParentAttr( subg );

      # the procedure works only when
      # the parent group is direct product of two groups
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        Error( "It has to be a subgroup of the direct product of TWO groups!" );
      fi;

      # in addition, the procedure works only when
      # all direct product components of the parent group are finite
      if not ForAll( DirectProductInfo( grp ).groups, IsFinite ) then
        TryNextMethod( );
      fi;

      # take the projections and embeddings
      proj1 := Projection( grp, 1 );
      proj2 := Projection( grp, 2 );
      embed1 := Embedding( grp, 1 );
      embed2 := Embedding( grp, 2 );

      # take essential subgroups
      h1 := Image( proj1, subg );
      z1 := Image( proj1, Intersection( Image( embed1 ), subg ) );
      h2 := Image( proj2, subg );
      z2 := Image( proj2, Intersection( Image( embed2 ), subg ) );

      sproj1 := RestrictedMapping( proj1, subg );
      cosets := RightCosets( subg, PreImages( sproj1, z1 ) );

      return rec( quadruple := [ h1, z1, z2, h2 ],
                  cosets := cosets );
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
      local grp,		# group
            grp_dpcpnts,	# list of direct product components of grp
            elmt,		# representative of C
            elmt_dpcpnts,	# list of direct product components of elm
            C_dpcpnt,		# direct product component of cc
            C_dpcpnts,		# list of direct product components of cc
            i;			# index

      grp := ActingDomain( C );
      grp_dpcpnts := DirectProductComponents( grp );
      elmt := Representative( C );
      elmt_dpcpnts := DirectProductDecomposition( grp, elmt );
      C_dpcpnts := [ ];
      for i in [ 1 .. Size( grp_dpcpnts ) ] do
        C_dpcpnt := ConjugacyClass( grp_dpcpnts[ i ], elmt_dpcpnts[ i ] );
        Add( C_dpcpnts, C_dpcpnt );
      od;

      return C_dpcpnts;
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
      local grp,                # group
            grp_dpcpnt,         # direct product component of grp
            grp_dpcpnts,        # list of direct product components of grp
            grp_CCs,            # conjugacy classes of grp
            d,                  # number of direct product components
            embed,              # embedding from grp to its direct product component
            grp_dpcpnt_CCs,     # CCs of a direct product component of grp
            grp_dpcpnt_CCreps,  # CC representatives of the above
            grp_CC_list,        # CC list in grp corresponding to CCs of its direct product component
            grp_CCindex_list,   # CC index list of the above
            res_chi,            # restricted character of chi
            psi,                # irreducible character of a direct product component of grp
            chi_dpcpnts,        # direct product decomposition of chi
            i;                  # index

      if not IsIrreducibleCharacter( chi ) then
        Error( "char must be irreducible." );
      fi;

      grp := UnderlyingGroup( chi );
      grp_dpcpnts := DirectProductComponents( grp );
      d := Size( grp_dpcpnts );
      if ( d = 1 ) then
        return [ chi ];
      fi;
      grp_CCs := ConjugacyClasses( grp );

      chi_dpcpnts := [ ];
      for i in [ 1 .. d ] do
        grp_dpcpnt := grp_dpcpnts[ i ];
        embed := Embedding( grp, i );
        grp_dpcpnt_CCs := ConjugacyClasses( grp_dpcpnt );
        grp_dpcpnt_CCreps := List( grp_dpcpnt_CCs, cc -> Representative( cc ) );
        grp_CC_list := List( grp_dpcpnt_CCreps, e -> ConjugacyClass( grp, Image( embed, e ) ) );
        grp_CCindex_list := List( grp_CC_list, cc -> Position( grp_CCs, cc ) );
        res_chi := ClassFunction( grp_dpcpnt, chi{ grp_CCindex_list } );
        for psi in Irr( grp_dpcpnt ) do
          if ScalarProduct( res_chi, psi ) > 0 then
            Add( chi_dpcpnts, psi );
            break;
          fi;
        od;
      od;

      return chi_dpcpnts;
    end
  );

#############################################################################
##
#O  DirectProductDecomposition( <G>, <e> )
##
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a group element",
    [ IsGroup, IsMultiplicativeElementWithInverse ],
    function( grp, elmt )
      local d,        # number of groups involved in the direct product
            proj,     # projection
            i,        # index
            decomp;   # the decomposition

      if not ( elmt in grp ) then
        Error( "The given element has to be in the given group.");
      fi;

      d := Size( DirectProductComponents( grp ) );

      if ( d = 1 ) then
        decomp := [ elmt ];
      else
        decomp := [ ];
        for i in [ 1 .. d ] do
          proj := Projection( grp, i );
          Add( decomp, Image( proj, elmt ) );
        od;
      fi;

      return decomp;
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
      local grp,            # group
            subg,           # representative of C
            subg_ginfo,     # Goursat info of subg
            quad,           # Goursat quadruple of C
            symbol,         # the returning symbol
            cc,             # conjugacy class of subgroups
            ccs_name_list;  # name list of CCSs

      grp := ActingDomain( C );
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        Error( "It has to be a CCS of the direct product of TWO groups." );
      fi;

      subg := Representative( C );
      subg_ginfo := GoursatInfo( subg );
      quad := List( subg_ginfo.quadruple, s -> ConjugacyClassSubgroups( s ) );

      ccs_name_list := [ ];
      for cc in quad do
        if HasName( cc ) then
          Add( ccs_name_list, Name( cc ) );
        else
          Add( ccs_name_list, String( Position( ConjugacyClassesSubgroups( ActingDomain( cc ) ), cc ) ) );
        fi;
      od;

      return Concatenation( ccs_name_list[ 1 ], "[", ccs_name_list[ 2 ], "|", ccs_name_list[ 3 ], "]", ccs_name_list[ 4 ] );
    end
  );

#############################################################################
##
#O  LaTeXTypesetting( <C>, <subscript> )
##
  InstallOtherMethod( LaTeXTypesetting,
    "return LaTeX typesetting of a CCS",
    [ IsConjugacyClassSubgroupsRep, IsString ],
    1,
    function( C, subscript )
      local grp,
            subg,
            subg_ginfo,
            ccs_latex_list;

      grp := ActingDomain( C );
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        TryNextMethod( );
      fi;

      subg := Representative( C );
      subg_ginfo := GoursatInfo( subg );
      ccs_latex_list := List( subg_ginfo.quadruple,
          s -> LaTeXString( ConjugacyClassSubgroups( s ) ) );

      return Concatenation( "\\amal{", ccs_latex_list[ 1 ], "}{", ccs_latex_list[ 2 ], "}{", subscript, "}{", ccs_latex_list[ 3 ], "}{", ccs_latex_list[ 4 ], "}" );
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
      local grp;

      if HasLaTeXString( C ) then
        return LaTeXString( C );
      fi;

      grp := ActingDomain( C );
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        TryNextMethod( );
      fi;

      return LaTeXTypesetting( C, "" );
    end
  );


#############################################################################
##
#E  DirectProduct1.gi . . . . . . . . . . . . . . . . . . . . . . . ends here
