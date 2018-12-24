#############################################################################
##
#W  OrbitType.gi	GAP Package `EquiDeg' 			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations procedures related to orbit types.
##

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
#A  OrbitTypes( <chi> )
##
  InstallMethod( OrbitTypes,
    "return indices of orbit types of the representation",
    [ IsCharacter ],
    function( chi )
      local G,			# the group
            i, j,		# indices
            orbt_list,		# orbit types
            ccs_list,		# CCSs
            is_orbittype,	# flag
            fixeddim_list;	# dimensions of fixed spaces

      orbt_list := [ ];
      G := UnderlyingGroup( chi );
      ccs_list := ConjugacyClassesSubgroups( G );
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
          Add( orbt_list, ccs_list[ i ], 1 );
        fi;
      od;

      return orbt_list;
    end
  );

#############################################################################
##
#A  LatticeOrbitTypes( <chi> )
##
  InstallMethod( LatticeOrbitTypes,
    "return lattice of orbit types of the given character",
    [ IsCharacter ],
    function( chi )
      local G,
            ccs_list,
            orbt_list,
            orbt,
            node_label_list,
            node_shape_list,
            rank_list,
            lat;

      G := UnderlyingGroup( chi );
      ccs_list := ConjugacyClassesSubgroups( G );
      orbt_list := OrbitTypes( chi );

      node_label_list := [ ];
      node_shape_list := [ ];
      rank_list := [ ];
      for orbt in orbt_list do
        Add( node_label_list, Position( ccs_list, orbt ) );
        if ( Size( orbt ) = 1 ) then
          Add( node_shape_list, "square" );
        else
          Add( node_shape_list, "circle" );
        fi;
        Add( rank_list, DimensionOfFixedSet( chi, orbt ) );
      od;

      lat := NewLattice( IsLatticeOrbitTypesRep,
        rec(
          poset := orbt_list,
          node_labels := node_label_list,
          node_shapes := node_shape_list,
          rank_type := "Dim(Fixed Set)",
          ranks := rank_list,
          is_rank_reversed := false,
          group := G
        )
      );
      SetCharacter( lat, chi );
      SetOrbitTypes( lat, orbt_list );

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


##  Print, View and Display

#############################################################################
##
#O  PrintString( <lat> )
##
  InstallMethod( PrintString,
    "print string for lattice of orbit types",
    [ IsLatticeOrbitTypesRep ],
    function( lat )
      return Concatenation(
        "LatticeOrbitTypes( Character( ",
        "CharacterTable( ",
        String( lat!.group ),
        " ), ",
        String( Character( lat ) ),
        " ) )"
      );
    end
  );

#############################################################################
##
#O  ViewString( <lat> )
##
  InstallMethod( ViewString,
    "print string for lattice of orbit types",
    [ IsLatticeOrbitTypesRep ],
    function( lat )
      return Concatenation(
        "LatticeOrbitTypes( Character( ",
        "CharacterTable( ",
        ViewString( lat!.group ),
        " ), ",
        String( Character( lat ) ),
        " ) )"
      );
    end
  );


##  What follows are not needed now

#############################################################################
##
#A  AlphaCharacteristic( <chi> )
##
# InstallMethod( AlphaCharacteristic,
#   "return Alpha-characteristic of the representation",
#   [ IsCharacter ],
#   function( chi )
#     local orbittype_index_list,    # indices of orbit types
#           orbittype_order_list,    # orders of orbit types
#           G,                     # the group
#           ccs_list;                # CCSs

#     G := UnderlyingGroup( chi );
#     ccs_list := ConjugacyClassesSubgroups( G );
#     orbittype_index_list := OrbitTypes( chi );

#     # if the fixed set of the whole group is not 1-dimensional,
#     # then the alpha characteristic is 1
#     if ( DimensionOfFixedSet( chi, G ) > 0 ) then
#       return 1;
#     # otherwise the alpha characteristic is the order of the whole group
#     # divided by the LCM of orders of proper orbity types
#     else
#       orbittype_order_list := List( ccs_list{ orbittype_index_list },
#           o -> Order( Representative( o ) ) );
#       Remove( orbittype_order_list );
#       return Order( G ) / Lcm( orbittype_order_list );
#     fi;
#   end
# );

#############################################################################
##
#P  IsAGroup( <G> )
##
# InstallMethod( IsAGroup,
#   "check whether the given group is an A-group",
#   [ IsGroup ],
#   function( G )
#     local nontrep_list,
#           trep;

#     trep := TrivialCharacter( G );
#     nontrep_list := Filtered( Irr( G ), chi -> not ( chi = trep ) );

#     return not ( 1 in List( nontrep_list, chi -> AlphaCharacteristic( chi ) ) );
#   end
# );


#############################################################################
##
#E  OrbitType.gi . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
