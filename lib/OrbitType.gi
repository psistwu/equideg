#############################################################################
##
#W  OrbitType.gi	GAP Package `EquiDeg' 			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for procedure related to orbit types.
##

#############################################################################
##
#A  OrbitTypes( <chi> )
##
  InstallMethod( OrbitTypes,
    "return indices of orbit types of the representation",
    [ IsCharacter ],
    function( chi )
      local grp,                    # the group
            i, j,                   # indices
            orbittype_index_list,   # indices of orbit types
            ccs_list,               # CCSs
            is_orbittype,           # flag
            fixeddim_list;          # dimensions of fixed spaces

      orbittype_index_list := [ ];
      grp := UnderlyingGroup( chi );
      ccs_list := ConjugacyClassesSubgroups( grp );
      fixeddim_list := List( ccs_list, c -> DimensionOfFixedSet( chi, c ) );

      for i in Reversed( [ 1 .. Size( ccs_list ) ] ) do
        is_orbittype := true;
        for j in [ i+1 .. Size( ccs_list ) ] do
          if ( fixeddim_list[ i ] = fixeddim_list[ j ] ) and ( ccs_list[ i ] < ccs_list[ j ] ) then
            is_orbittype := false;
            break;
          fi;
        od;
        if is_orbittype then
          Add( orbittype_index_list, i, 1 );
        fi;
      od;

      return orbittype_index_list;
    end
  );

#############################################################################
##
#U  NewLattice( <filter>, <list> )
##
# InstallMethod( NewLattice,
#   "constructing the lattice of a sorted list",
#   [ IsLatticeOrbitTypesRep, IsHomogeneousList ],
#   function( filter, orbittype_list )
#     local c,                # a conjugacy class of subgroups
#           node_shape_list;  # define the node shape of
#                             # each CCS in the lattice diagram
#                             # normal subgroups -> squares
#                             # other subgroups -> circles

#     node_shape_list := [ ];
#     for c in orbittype_list do
#       if ( Size( c ) = 1 ) then
#         Add( node_shape_list, "square" );
#       else
#         Add( node_shape_list, "circle" );
#       fi;
#     od;

#     return Objectify(
#       NewType( FamilyObj( orbittype_list ), IsCollection and filter ),
#       rec(
#         sortedList := orbittype_list,
#         rankType := "Dim",
#         nodeShapes := node_shape_list,
#         isRankReversed := false
#       )
#     );
#   end
# );

#############################################################################
##
#A  LatticeOrbitTypes( <chi> )
##
  InstallMethod( LatticeOrbitTypes,
    "return lattice of orbit types of the given character",
    [ IsCharacter ],
    function( chi )
      local grp,
            ccs_list,
            rank_list,
            orbittype_index_list,
            orbittype_list,
            lat;

      grp := UnderlyingGroup( chi );
      ccs_list := ConjugacyClassesSubgroups( grp );
      orbittype_index_list := OrbitTypes( chi );
      orbittype_list := ccs_list{ orbittype_index_list };
      lat := NewLattice( IsLatticeOrbitTypesRep, orbittype_list );
      lat!.ranks := List( orbittype_list, o -> DimensionOfFixedSet( chi, o ) );
      lat!.nodeLabels := orbittype_index_list;

      return lat;
    end
  );

#############################################################################
##
#A  MaximalOrbitTypes( <chi> )
##
  InstallMethod( MaximalOrbitTypes,
    "return ccs indices of maximal orbit types of the given representation",
    [ IsCharacter ],
    function( chi )
      local maxsub;

      maxsub := ShallowCopy( MaximalSubElementsLattice( LatticeOrbitTypes( chi ) ) );

      return OrbitTypes( chi ){ Remove( maxsub ) };
    end
  );

#############################################################################
##
#A  AlphaCharacteristic( <chi> )
##
  InstallMethod( AlphaCharacteristic,
    "return Alpha-characteristic of the representation",
    [ IsCharacter ],
    function( chi )
      local orbittype_index_list,    # indices of orbit types
            orbittype_order_list,    # orders of orbit types
            grp,                     # the group
            ccs_list;                # CCSs

      grp := UnderlyingGroup( chi );
      ccs_list := ConjugacyClassesSubgroups( grp );
      orbittype_index_list := OrbitTypes( chi );

      # if the fixed set of the whole group is not 1-dimensional,
      # then the alpha characteristic is 1
      if ( DimensionOfFixedSet( chi, grp ) > 0 ) then
        return 1;
      # otherwise the alpha characteristic is the order of the whole group
      # divided by the LCM of orders of proper orbity types
      else
        orbittype_order_list := List( ccs_list{ orbittype_index_list }, o -> Order( Representative( o ) ) );
        Remove( orbittype_order_list );
        return Order( grp ) / Lcm( orbittype_order_list );
      fi;
    end
  );

#############################################################################
##
#P  IsAGroup( <grp> )
##
  InstallMethod( IsAGroup,
    "check whether the given group is an A-group",
    [ IsGroup ],
    function( grp )
      local nontrep_list,
            trep;

      trep := TrivialCharacter( grp );
      nontrep_list := Filtered( Irr( grp ), chi -> not ( chi = trep ) );

      return not ( 1 in List( nontrep_list, chi -> AlphaCharacteristic( chi ) ) );
    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <subg> )
##
  InstallMethod( DimensionOfFixedSet,
    "return the dimension of fixed set for given character and subgroup",
    [ IsCharacter, IsGroup and IsFinite ],
    function( chi, U )
      # local variable(s)
      local G,		# the parent group
            chi_U;	# restriction of chi on U

      G := UnderlyingGroup( chi );

      if not IsSubgroup( G, U ) then
        Error( "U is not a subgroup of the underlying group of chi." );
      fi;

      chi_U := RestrictedClassFunction( chi, U );

      return ScalarProduct( chi_U, TrivialCharacter( U ) );
    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <ccsubg> )
##
  InstallMethod( DimensionOfFixedSet,
    "return the dimension of fixed set for given character and CCS",
    [ IsCharacter, IsConjugacyClassSubgroupsRep ],
    function( chi, C )
      return DimensionOfFixedSet( chi, Representative( C ) );
    end
  );


#############################################################################
##
#E  OrbitType.gi . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
