# # GAP: Direct Product Library
#
# Implementation file of libDirectProduct.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ## attribute(s)
# ***
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

# ***
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

# ***
# InstallMethod( AmalgamationQuadruple,
#   "return the amalgamation quadruple of a CCS of direct product of two groups",
#   [ IsConjugacyClassSubgroupsRep ],
#   function( c )
#     local subg,                                 # subgroup
#           grp,                                  # group
#           grp1, grp2,                           # direct product components of grp
#           ccs_list1, ccs_list2,                 # CCSs of grp1 and grp2
#           cH1, cH2, cZ1, cZ2,                   # CCS of H1, H2, Z1 and Z2
#           ind_cH1, ind_cH2, ind_cZ1, ind_cZ2;   # indices of cH1, cH2, cZ1, cZ2

#     subg := Representative( c );
#     grp := ParentAttr( subg );

#     if HasDirectProductInfo( grp ) then
#     elif ( Size( DirectProductInfo( grp ).groups ) = 2 ) then
#     else
#       Error( "It has to be a CCS of the direct product of TWO groups." );
#     fi;

#     if not ForAll( DirectProductInfo( grp ).groups, IsFinite ) then
#       TryNextMethod( );
#     fi;

#     grp1 := DirectProductInfo( grp ).groups[ 1 ];
#     grp2 := DirectProductInfo( grp ).groups[ 2 ];
#     ccs_list1 := ConjugacyClassesSubgroups( grp1 );
#     ccs_list2 := ConjugacyClassesSubgroups( grp2 );

#     cH1 := ConjugacyClassSubgroups( GoursatInfo( subg ).Quadruple[ 1 ] );
#     cZ1 := ConjugacyClassSubgroups( SubgroupDirectProductInfo( subg ).Quadruple[ 2 ] );
#     cZ2 := ConjugacyClassSubgroups( SubgroupDirectProductInfo( subg ).Quadruple[ 3 ] );
#     cH2 := ConjugacyClassSubgroups( SubgroupDirectProductInfo( subg ).Quadruple[ 4 ] );

#     ind_cH1 := Position( ccs_list1, cH1 );
#     ind_cZ1 := Position( ccs_list1, cZ1 );
#     ind_cZ2 := Position( ccs_list2, cZ2 );
#     ind_cH2 := Position( ccs_list2, cH2 );

#     return [ ind_cH1, ind_cZ1, ind_cZ2, ind_cH2 ];
#   end
# );

# ***
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a CC of a group",
    [ IsConjugacyClassGroupRep ],
    function( cc )
      local grp,                  # group
            grp_dpcpnts,          # list of direct product components of grp
            elmt,                 # representative of cc
            elmt_dpcpnts,         # list of direct product components of elm
            cc_dpcpnt,            # direct product component of cc
            cc_dpcpnts,           # list of direct product components of cc
            i;                    # index

      grp := ActingDomain( cc );
      grp_dpcpnts := DirectProductComponents( grp );
      elmt := Representative( cc );
      elmt_dpcpnts := DirectProductDecomposition( grp, elmt );
      cc_dpcpnts := [ ];
      for i in [ 1 .. Size( grp_dpcpnts ) ] do
        cc_dpcpnt := ConjugacyClass( grp_dpcpnts[ i ], elmt_dpcpnts[ i ] );
        Add( cc_dpcpnts, cc_dpcpnt );
      od;

      return cc_dpcpnts;
    end
  );

#
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


# ## operation(s)
# ***
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

# ***
  InstallMethod( AmalgamationSymbol,
    "return the amalgamation symbol of a CCS of direct product of two groups",
    [ IsConjugacyClassSubgroupsRep ],
    function( c )
      local grp,            # group
            subg,           # representative of c
            subg_ginfo,     # Goursat info of subg
            quad,           # Goursat quadruple of c
            symbol,         # the returning symbol
            cc,             # conjugacy class of subgroups
            ccs_name_list;  # name list of CCSs

      grp := ActingDomain( c );
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        Error( "It has to be a CCS of the direct product of TWO groups." );
      fi;

      subg := Representative( c );
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

      return Concatenation( "(", ccs_name_list[ 1 ], "[", ccs_name_list[ 2 ], "|", ccs_name_list[ 3 ], "]", ccs_name_list[ 4 ], ")\n" );
    end
  );

# ***
  InstallMethod( LaTeXAmalgamationSymbol,
    "return LaTeX amalgamation symbol of a CCS",
    [ IsConjugacyClassSubgroupsRep ],
    function( c )
      local grp,
            subg,
            subg_ginfo,
            ccs_latex_list;

      grp := ActingDomain( c );
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        Error( "This procedure only works for CCS of direct product of TWO groups!" );
      fi;

      subg := Representative( c );
      subg_ginfo := GoursatInfo( subg );
      ccs_latex_list := List( subg_ginfo.quadruple,
          s -> LaTeXString( ConjugacyClassSubgroups( s ) ) );

      return Concatenation( "\\amal{", ccs_latex_list[ 1 ], "}{", ccs_latex_list[ 2 ], "}{}{", ccs_latex_list[ 3 ], "}{", ccs_latex_list[ 4 ], "}" );
    end
  );