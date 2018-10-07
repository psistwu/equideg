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
    "return list of direct product components",
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
  InstallMethod( SubgroupDirectProductInfo,
    "return the direct product info of a subgroup, i.e., subg=H1(Z1,L,Z2)H2",
    [ IsGroup and HasParentAttr ],
    function( subg )
      local grp,		 # the parent group grp=grp1xgrp2
	        proj1,		 # projection to grp1
	        proj2,		 # projection to grp2
	        embed1,		 # embedding from grp1
	        embed2,		 # embedding from grp2
	        H1, H2,      # projection of the subg to grp1 and grp2
            Z1, Z2,      # kernels of the homomorphisms from H1 and H2 to L
            dis_gens_h1, # generators of H1 which determine the homomorphism
            i, j,        # indices
            sproj1,      # restricted projection1 to subg
            dis_elms;    # elements in subg which determin the homomorphism

      grp := ParentAttr( subg );

      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        Error( "It has to be a subgroup of the direct product of TWO groups!" );
      fi;

      proj1 := Projection( grp, 1 );
      proj2 := Projection( grp, 2 );
      embed1 := Embedding( grp, 1 );
      embed2 := Embedding( grp, 2 );

      H1 := Image( proj1, subg );
      Z1 := Image( proj1, Intersection( Image( embed1 ), subg ) );
      H2 := Image( proj2, subg );
      Z2 := Image( proj2, Intersection( Image( embed2 ), subg ) );

      dis_gens_h1 := Difference( GeneratorsOfGroup( H1 ), Z1 );
      i := 1;
      while ( i <= Size( dis_gens_h1 ) ) do
        j := i+1;
        while ( j <= Size( dis_gens_h1 ) ) do
          if ( dis_gens_h1[ i ]/dis_gens_h1[ j ] in Z1 ) then
            Remove( dis_gens_h1, j );
          else
            j := j+1;
          fi;
        od;
        i := i+1;
      od;

      sproj1 := RestrictedMapping( proj1, subg );
      dis_elms := List( dis_gens_h1, e -> Representative( PreImages( sproj1, e ) ) );

      return rec( Quadruple := [ H1, Z1, Z2, H2 ],
                  DiscriminantElements := dis_elms );
    end
  );

# ***
  InstallMethod( AmalgamationQuadruple,
    "return the amalgamation quadruple of a CCS of direct product of two groups",
    [ IsConjugacyClassSubgroupsRep ],
    function( c )
      local subg,                                 # subgroup
            grp,                                  # group
            grp1, grp2,                           # direct product components of grp
            ccs_list1, ccs_list2,                 # CCSs of grp1 and grp2
            cH1, cH2, cZ1, cZ2,                   # CCS of H1, H2, Z1 and Z2
            ind_cH1, ind_cH2, ind_cZ1, ind_cZ2;   # indices of cH1, cH2, cZ1, cZ2

      subg := Representative( c );
      grp := ParentAttr( subg );
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        Error( "It has to be a CCS of the direct product of TWO groups." );
      fi;

      grp1 := DirectProductInfo( grp ).groups[ 1 ];
      grp2 := DirectProductInfo( grp ).groups[ 2 ];
      ccs_list1 := ConjugacyClassesSubgroups( grp1 );
      ccs_list2 := ConjugacyClassesSubgroups( grp2 );

      cH1 := ConjugacyClassSubgroups( SubgroupDirectProductInfo( subg ).Quadruple[ 1 ] );
      cZ1 := ConjugacyClassSubgroups( SubgroupDirectProductInfo( subg ).Quadruple[ 2 ] );
      cZ2 := ConjugacyClassSubgroups( SubgroupDirectProductInfo( subg ).Quadruple[ 3 ] );
      cH2 := ConjugacyClassSubgroups( SubgroupDirectProductInfo( subg ).Quadruple[ 4 ] );

      ind_cH1 := Position( ccs_list1, cH1 );
      ind_cZ1 := Position( ccs_list1, cZ1 );
      ind_cZ2 := Position( ccs_list2, cZ2 );
      ind_cH2 := Position( ccs_list2, cH2 );

      return [ ind_cH1, ind_cZ1, ind_cZ2, ind_cH2 ];
    end
  );

# ***
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a CC of a group",
    [ IsConjugacyClassGroupRep ],
    function( cc )
      local grp,                  # group
            grp_comp,             # direct product component of grp
            grp_comp_list,        # list of direct product components of grp
            elm,                  # representative of cc
            elm_comp,             # direct product component of elm
            elm_comp_list,        # list of direct product components of elm
            cc_comp,              # direct product component of cc
            cc_comp_list,         # list of direct product components of cc
            i;                    # index

      grp := ActingDomain( cc );
      grp_comp_list := DirectProductComponents( grp );
      elm := Representative( cc );
      elm_comp_list := DirectProductDecomposition( grp, elm );
      cc_comp_list := [ ];
      for i in [ 1 .. Size( grp_comp_list ) ] do
        cc_comp := ConjugacyClass( grp_comp_list[ i ], elm_comp_list[ i ] );
        Add( cc_comp_list, cc_comp );
      od;

      return cc_comp_list;
    end
  );

# !!!
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a irredicible character of a group",
    [ IsCharacter ],
    function( char )
      local grp,                  # group
            grp_comp,             # direct product component of grp
            grp_comp_list,        # list of direct product components of grp
            grp_cc_list,
            grp_comps_irr_list,
            grp_Cgen_list,
            grp_Cgens_comp_list,
            grp_Cgens_comp_ind_list,
            grp_Cgen_ind_list,
            grp_comps_cc_list,
            char_comp1,
            char_comp2,
            flag,
            d,
            i, j, k;              # index

      if not IsIrreducibleCharacter( char ) then
        Error( "char must be irreducible." );
      fi;
      grp := UnderlyingGroup( char );
      grp_comp_list := DirectProductComponents( grp );
      d := Size( grp_comp_list );
      if ( d = 1 ) then
        return [ char ];
      fi;

      grp_cc_list := ConjugacyClasses( grp );
      grp_Cgen_list := List( GeneratorsOfGroup( grp ), elm -> ConjugacyClass( grp, elm ) );
      grp_Cgen_ind_list := List( grp_Cgen_list, c -> Position( grp_cc_list, c ) );
      grp_comps_cc_list := List( grp_comp_list, grp_comp -> ConjugacyClasses( grp_comp ) );
      grp_Cgens_comp_list := List( grp_Cgen_list, c -> DirectProductDecomposition( c ) );
      grp_Cgens_comp_ind_list := List( grp_Cgens_comp_list,
          grp_Ccomp_list -> List( [ 1 .. d ], i -> Position( grp_comps_cc_list[ i ], grp_Ccomp_list[ i ] ) ) );
      grp_comps_irr_list := List( grp_comp_list, grp_comp -> Irr( grp_comp ) );
      for char_comp1 in grp_comps_irr_list[ 1 ] do
        for char_comp2 in grp_comps_irr_list[ 2 ] do
          flag := true;
          for k in [ 1 .. Size( grp_Cgen_list ) ] do
            if not ( List( char )[ grp_Cgen_ind_list[ k ] ] = List( char_comp1 )[ grp_Cgens_comp_ind_list[ k ][ 1 ] ] * List( char_comp2 )[ grp_Cgens_comp_ind_list[ k ][ 2 ] ] ) then
              flag := false;
              break;
            fi;
          od;
          if flag then
            return [ char_comp1, char_comp2 ];
          fi;
        od;
      od;
    end
  );


# ## operation(s)
# ***
  InstallMethod( DirectProductDecomposition,
    "direct product decomposition of a group element",
    [ IsGroup, IsMultiplicativeElementWithInverse ],
    function( grp, elm )
      local d,        # number of groups involved in the direct product
            proj,     # projection
            i,        # index
            decomp;   # the decomposition

      if not ( elm in grp ) then
        Error( "The given element has to be in the given group.");
      fi;

      d := Size( DirectProductComponents( grp ) );

      if ( d = 1 ) then
        decomp := [ elm ];
      else
        decomp := [ ];
        for i in [ 1 .. d ] do
          proj := Projection( grp, i );
          Add( decomp, Image( proj, elm ) );
        od;
      fi;

      return decomp;
    end
  );

# ***
  InstallMethod( AmalgamationNotation,
    "return the amalgamation notation of a CCS of direct product of two groups",
    [ IsConjugacyClassSubgroupsRep ],
    function( c )
      local grp,                    # group
            quadruple,              # amalgamation quadruple
            grp1, grp2,             # direct product components of grp
            ccs_list1, ccs_list2,   # CCSs of grp1 and grp2
            cH1_name, cH2_name,     # names of cH1 and cH2
            cZ1_name, cZ2_name;     # names of cZ1 and cZ2

      grp := ParentAttr( Representative( c ) );
      if not ( Size( DirectProductComponents( grp ) ) = 2 ) then
        Error( "It has to be a CCS of the direct product of TWO groups." );
      fi;

      quadruple := AmalgamationQuadruple( c );
      grp1 := DirectProductInfo( grp ).groups[ 1 ];
      grp2 := DirectProductInfo( grp ).groups[ 2 ];
      ccs_list1 := ConjugacyClassesSubgroups( grp1 );
      ccs_list2 := ConjugacyClassesSubgroups( grp2 );

      if HasName( ccs_list1[ quadruple[ 1 ] ] ) then
        cH1_name := Name( ccs_list1[ quadruple[ 1 ] ] );
      else
        cH1_name := String( quadruple[ 1 ] );
      fi;

      if HasName( ccs_list1[ quadruple[ 2 ] ] ) then
        cZ1_name := Name( ccs_list1[ quadruple[ 2 ] ] );
      else
        cZ1_name := String( quadruple[ 2 ] );
      fi;

      if HasName( ccs_list2[ quadruple[ 3 ] ] ) then
        cZ2_name := Name( ccs_list2[ quadruple[ 3 ] ] );
      else
        cZ2_name := String( quadruple[ 3 ] );
      fi;

      if HasName( ccs_list2[ quadruple[ 4 ] ] ) then
        cH2_name := Name( ccs_list2[ quadruple[ 4 ] ] );
      else
        cH2_name := String( quadruple[ 4 ] );
      fi;

      return Concatenation( "(", cH1_name, "[", cZ1_name, ",", cZ2_name, "]", cH2_name, ")" );
    end
  );

