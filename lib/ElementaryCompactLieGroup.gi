#############################################################################
##
#W  ElementaryCompactLieGroup.gi	GAP Package `EquiDeg'	    Haopin Wu
##
#Y  Copyright (C) 2017-2023, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
#Y  Department of Mathematical Sciences, the University of Texas at Dallas, USA
##
##  This file contains declarations for procedures related to
##  elementary compact Lie group.
##

##  Part 1: Group and Subgroup

#############################################################################
##
#F  OrthogonalGroupOverReal( <n> )
##
InstallGlobalFunction( OrthogonalGroupOverReal,
  function( n )
    local G;		# the orthogonal group

    # objectify the group
    G := NewCompactLieGroup( IsCompactLieGroup and IsMatrixGroup, n );

    # setup property(s) and attribute(s) of the group
    SetIsAbelian( G, false );
    SetDimensionOfCompactLieGroup( G, n*(n-1)/2 );
    SetRankOfCompactLieGroup( G, Int( n/2 ) );
    SetIdOfElementaryCompactLieGroup( G, [ 2, n ] );
    SetString( G, StringFormatted( "OrthogonalGroupOverReal( {} )", n ) );
    SetAbbrv( G, StringFormatted( "O( {} ,R )", n ) );

    # the follow clause is an ad hoc approach for
    # comparing epimorphisms from O(2) to a finite group
    # certainly, the given set does not generate O(2)
    if ( n = 2 ) then
      SetGeneratorsOfGroup( G,
        [ [ [ 0, -1 ],[ 1, 0 ] ],
          [ [ 1, 0 ], [ 0, -1 ] ] ]
      );
    fi;

    return G;
  end
);

#############################################################################
##
#F  SpecialOrthogonalGroupOverReal( <n> )
##
InstallGlobalFunction( SpecialOrthogonalGroupOverReal,
  function( n )
    local G;		# the special orthogonal group

    # objectify the group
    G := NewCompactLieGroup( IsCompactLieGroup and IsMatrixGroup, n );

    # setup property(s) and attribute(s) of the group
    if ( n = 2 ) then
      SetIsAbelian( G, true );
    else
      SetIsAbelian( G, false );
    fi;
    SetDimensionOfCompactLieGroup( G, n*(n-1)/2 );
    SetRankOfCompactLieGroup( G, Int( n/2 ) );
    SetIdOfElementaryCompactLieGroup( G, [ 1, n ] );
    SetString( G,
      StringFormatted( "SpecialOrthogonalGroupOverReal( {} )", n )
    );
    SetAbbrv( G, StringFormatted( "SO( {} ,R )", n ) );

    # the follow clause is an ad hoc approach for
    # comparing epimorphisms from SO(2) to a finite group
    # certainly, the given set does not generate SO(2)
    if ( n = 2 ) then
      SetGeneratorsOfGroup( G, [ [ [ 0, -1 ], [ 1, 0 ] ] ] );
    fi;

    return G;
  end
);

#############################################################################
##
#F  ElementaryCompactLieGroupById( <id...> )
##
InstallGlobalFunction( ElementaryCompactLieGroupById,
  function( id... )
    if IsList( id[ 1 ] ) then
      id := id[ 1 ];
    fi;

    if ( id[ 1 ] = 1 ) then
      return SpecialOrthogonalGroupOverReal( id[ 2 ] );
    elif ( id[ 1 ] = 2 ) then
      return OrthogonalGroupOverReal( id[ 2 ] );
    else
      Info( InfoEquiDeg, INFO_LEVEL_EquiDeg, "Invalid ID." );
      return fail;
    fi;
  end
);

#############################################################################
##
#O  \=( <G>, <H> )
##
InstallMethod( \=,
  "equivalence relation of ECLGs",
  [ IsCompactLieGroup and HasIdOfElementaryCompactLieGroup,
    IsCompactLieGroup and HasIdOfElementaryCompactLieGroup ],
  function( G, H )
    return IdOfElementaryCompactLieGroup( G ) =
        IdOfElementaryCompactLieGroup( H );
  end
);

#############################################################################
##
#O  \in( <obj>, SO(n) )
##
InstallMethod( \in,
  "Membership test for SO(n)",
  [ IsObject, IsCompactLieGroup and HasIdOfElementaryCompactLieGroup ],
  function( obj, G )
    if not ( IdOfElementaryCompactLieGroup( G )[ 1 ] = 1 ) then
      TryNextMethod( );
    fi;
    
    if IsMatrix( obj ) and
        ( obj * TransposedMat( obj ) = One( G ) ) and
        ( TransposedMat( obj ) * obj = One( G ) ) and
        ( Determinant( obj ) = 1 ) then
      return true;
    else
      return false;
    fi;
  end
);

#############################################################################
##
#O  \in( <obj>, O(n) )
##
InstallMethod( \in,
  "Membership test for O(n)",
  [ IsObject, IsCompactLieGroup and HasIdOfElementaryCompactLieGroup ],
  function( obj, G )
    if not ( IdOfElementaryCompactLieGroup( G )[ 1 ] = 2 ) then
      TryNextMethod( );
    fi;

    if IsMatrix( obj ) and
        ( obj * TransposedMat( obj ) = One( G ) ) and
        ( TransposedMat( obj ) * obj = One( G ) ) then
      return true;
    else
      return false;
    fi;
  end
);

#############################################################################
##
#O  IsSubset( <G>, <col> )
##
InstallMethod( IsSubset,
  "Test if a finite group is a subgroup of a CLG",
  [ IsCompactLieGroup, IsCollection ],
  function( G, col )
    local elmt;

    if IsFinite( col ) then
      TryNextMethod( );
    fi;

    for elmt in List( col ) do
      if not ( elmt in G ) then
        return false;
      fi;
    od;
    return true;
  end
);

#############################################################################
##
#O  IsSubset( <G>, <U> )
##
InstallMethod( IsSubset,
  "subset test of O(n) and SO(n)",
  [ IsCompactLieGroup and HasIdOfElementaryCompactLieGroup,
    IsCompactLieGroup and HasIdOfElementaryCompactLieGroup ],
  function( G, U )
    local type_G,	# type of G
          type_U,	# type of U
          d_G,	# matrix dimension of G
          d_U;	# matrix dimension of U

    type_G := IdOfElementaryCompactLieGroup( G )[ 1 ];
    type_U := IdOfElementaryCompactLieGroup( U )[ 1 ];
    d_G := IdOfElementaryCompactLieGroup( G )[ 2 ];
    d_U := IdOfElementaryCompactLieGroup( U )[ 2 ];

    if not ( ( type_G in [ 1, 2 ] ) and ( type_U in [ 1, 2 ] ) ) then
      TryNextMethod( );
    fi;

    if not ( d_G = d_U ) or 
        ( ( type_G = 1 ) and ( type_U = 2 ) ) then
      return false;
    else
      return true;
    fi;
  end
);


##  Part 2: Conjugacy Class of Subgroups

#############################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
InstallMethod( ConjugacyClassesSubgroups,
  "CCSs of SO(2)",
  [ IsCompactLieGroup and HasIdOfElementaryCompactLieGroup ],
  function( G )
    local data,	# CCSs data
          class,	# CCS classes
          x;		# indeterminate

    if not ( IdOfElementaryCompactLieGroup( G ) = [ 1, 2 ] ) then
      TryNextMethod( );
    fi;

    # generate CCS classes for SO(2)
    data := rec( );
    x := X( Integers, "x" );
    data.ccsClasses := [ ];

    # SO(2)
    class := rec(
      is_zero_mode			:= true,
      order_of_weyl_group		:= One( x ),
      representative			:= SpecialOrthogonalGroupOverReal( 2 ),
      normalizer			:= G,
      order_of_representative		:= x,
      abbrv				:= "SO(2)"			);
    class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                    IsMatrixGroup, G, class );
    Add( data.ccsClasses, class );

    # Z_l
    class := rec(
      is_zero_mode		:= false,
      order_of_weyl_group	:= x,
      representative		:= mCyclicGroup( 1 ),
      normalizer		:= G,
      order_of_representative	:= One( x ),
      abbrv			:= "Z_{}"			);
    class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                    IsMatrixGroup, G, class );
    class.representative	:= l -> mCyclicGroup( l );
    class.normalizer		:= l -> G;
    Add( data.ccsClasses, class );

    # return the CCSs object
    return NewCompactLieGroupConjugacyClassesSubgroups(
        IsMatrixGroup, G, data );
  end
);

#############################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
InstallMethod( ConjugacyClassesSubgroups,
  "CCSs of O(2)",
  [ IsCompactLieGroup and HasIdOfElementaryCompactLieGroup ],
  function( G )
    local data,	# CCSs data
          class,	# CCS classes
          x;		# indeterminate

    if not ( IdOfElementaryCompactLieGroup( G ) = [ 2, 2 ] ) then
      TryNextMethod( );
    fi;

    # generate CCS classes for O(2)
    data := rec( );
    x := X( Integers, "x" );
    data.ccsClasses := [ ];

    # SO(2)
    class := rec(
      is_zero_mode		:= true,
      order_of_weyl_group	:= 2*One( x ),
      representative		:= SpecialOrthogonalGroupOverReal( 2 ),
      normalizer		:= G,
      order_of_representative	:= x,
      abbrv			:= "SO(2)"				);
    class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                    IsMatrixGroup, G, class );
    Add( data.ccsClasses, class );

    # O(2)
    class := rec(
      is_zero_mode		:= true,
      order_of_weyl_group	:= One( x ),
      representative		:= OrthogonalGroupOverReal( 2 ),
      normalizer		:= G,
      order_of_representative	:= 2*x,
      abbrv			:= "O(2)"			);
    class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                    IsMatrixGroup, G, class );
    Add( data.ccsClasses, class );

    # Z_l
    class := rec(
      is_zero_mode		:= false,
      order_of_weyl_group	:= 2*x,
      representative		:= mCyclicGroup( 1 ),
      normalizer		:= G,
      order_of_representative	:= One( x ),
      abbrv			:= "Z_{}"		);
    class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                    IsMatrixGroup, G, class );
    class.representative	:= l -> mCyclicGroup( l );
    class.normalizer		:= l -> G;
    Add( data.ccsClasses, class );

    # D_l
    class := rec(
      is_zero_mode		:= false,
      order_of_weyl_group	:= 2*One( x ),
      representative		:= mDihedralGroup( 1 ),
      normalizer		:= mDihedralGroup( 2 ),
      order_of_representative	:= 2*One( x ),
      abbrv			:= "D_{}"		);
    class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                    IsMatrixGroup, G, class );
    class.representative	:= l -> mDihedralGroup( l );
    class.normalizer		:= l -> mDihedralGroup( 2*l );
    Add( data.ccsClasses, class );

    # objectify the CCSs object
    return NewCompactLieGroupConjugacyClassesSubgroups(
        IsMatrixGroup, G, data );
  end
);


#############################################################################
##
#O  nLHnumber( <CL>, <CH> )
##
InstallMethod( nLHnumber,
  "return n(L,H) number for CCSs of ECLG",
  IsIdenticalObj,
  [ IsCompactLieGroupConjugacyClassSubgroupsRep,
    IsCompactLieGroupConjugacyClassSubgroupsRep  ],
  function( CL, CH )
    local G,		# underlying group of ccs1 and ccs2
          L, H,	# representatives
          x,		# indeterminate
          k;		# the reflection

    G := ActingDomain( CL );
    if not ( G = ActingDomain( CH ) ) then
      Error( "CL and CH must be from the same group." );
    fi;

    if not HasIdOfElementaryCompactLieGroup( G ) or
        not ( IdOfElementaryCompactLieGroup( G ) in [ [ 1, 2 ], [ 2, 2 ] ] ) then
      TryNextMethod( );
    fi;

    x := X( Integers, "x" );
    L := Representative( CL );
    H := Representative( CH );

    k := [ [ 1, 0 ], [ 0, -1 ] ];
    if IsSubset( H, L ) then
      if ( IdCCS( CH )[ 1 ] = 0 ) then
        return One( x );
      elif ( k in H ) and not ( k in L ) then
        return x;
      else
        return One( x );
      fi;
    else
      return Zero( x );
    fi;
  end
);


##  Part 3: Representation and Character Theory

#############################################################################
##
#O  \[\]( <irrs>, <l> )
##
InstallMethod( \[\],
  "selects an irreducible SO(2)-representation",
  [ IsCompactLieGroupIrrCollection, IsInt ],
  function( irrs, l )
    local G,
          cat,
          rep,
          fun,
          chi,
          id,
          x;

    G := UnderlyingGroup( irrs );

    if not HasIdOfElementaryCompactLieGroup( G ) or
        not ( IdOfElementaryCompactLieGroup( G ) = [ 1, 2 ] ) then
      TryNextMethod( );
    fi;

    x := X( Rationals, "x" );
    cat := IsCompactLieGroupClassFunction;
    fun := M -> [ 1, E(4) ]*M^l*[ 1, 0 ];
    id := [ x^l ];
    chi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );
    
    SetIsIrreducibleCharacter( chi, true );
    SetIsGeneratorsOfSemigroup( chi, true );
    SetIdIrr( chi, l );
    SetIdCompactLieGroupClassFunction( chi, id );

    return chi;
  end
);

#############################################################################
##
#O  \[\]( <irrs>, <l> )
##
InstallMethod( \[\],
  "returns an irreducible O(2)-representation",
  [ IsCompactLieGroupIrrCollection, IsInt ],
  function( irrs, l )
    local G,
          cat,
          fun,
          chi,
          id,
          x;

    G := UnderlyingGroup( irrs );

    if not HasIdOfElementaryCompactLieGroup( G ) or
        not ( IdOfElementaryCompactLieGroup( G ) = [ 2, 2 ] ) then
      TryNextMethod( );
    fi;

    x := X( Rationals, "x" );
    cat := IsCompactLieGroupClassFunction;
    if ( l = -1 ) then
      fun := M -> DeterminantMat( M );
      id := [ One( x ), -1 ];
    elif ( l = 0 ) then
      fun := M -> 1;
      id := [ One( x ), 1 ];
    elif ( l = 1 ) then
      fun := M -> TraceMat( M );
      id := [ x+x^(-1), 0 ];
    elif ( l > 0 ) then
      fun := M -> ( 1 + DeterminantMat( M ) )/2 * TraceMat( M^l );
      id := [ x^l+x^(-l), 0 ];
    else
      Error( StringFormatted( "{} admits no such irreducible representation.\n",
          ViewString( G ) ) );
    fi;
    chi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );
    
    SetIsIrreducibleCharacter( chi, true );
    SetIsGeneratorsOfSemigroup( chi, true );
    SetIdIrr( chi, l );
    SetIdCompactLieGroupClassFunction( chi, id );

    return chi;
  end
);

#############################################################################
##
#O  Refolded( <chi>, <l> )
##
  InstallMethod( Refolded,
    "returns refolded character of SO(2)",
    [ IsCompactLieGroupClassFunction and IsIrreducibleCharacter, IsInt ],
    function( chi, l )
      local G,
            G1,
            id;

      G := UnderlyingGroup( chi );
      G1 := DirectProductDecomposition( G )[ 1 ];
      id := Flat( [ ShallowCopy( IdIrr( chi ) ) ] );

      if not HasIdOfElementaryCompactLieGroup( G1 ) or
         not ( IdOfElementaryCompactLieGroup( G1 ) = [ 1, 2 ] ) then
        TryNextMethod( );
      fi;

      if not IsZero( id[ 1 ] ) and not IsZero( l ) then
        id[ 1 ] := l;
        return Irr( G )[ id ];
      else
        return chi;
      fi;
    end
  );

#############################################################################
##
#O  Refolded( <chi>, <l> )
##
  InstallMethod( Refolded,
    "returns refolded character of O(2)",
    [ IsCompactLieGroupClassFunction and IsIrreducibleCharacter, IsInt ],
    function( chi, l )
      local G,
            G1,
            id;

      G := UnderlyingGroup( chi );
      G1 := DirectProductDecomposition( G )[ 1 ];
      id := Flat( [ ShallowCopy( IdIrr( chi ) ) ] );

      if not HasIdOfElementaryCompactLieGroup( G1 ) or
         not ( IdOfElementaryCompactLieGroup( G1 ) = [ 2, 2 ] ) then
      fi;

      if IsPosInt( id[ 1 ] ) and IsPosInt( l ) then
        id[ 1 ] := l;
        return Irr( G )[ id ];
      else
        return chi;
      fi;
    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <H> );
##
  InstallMethod( DimensionOfFixedSet,
    "dimension of fixed set of <H>; H = O(2) or SO(2)",
    [ IsCompactLieGroupCharacter and HasIdCompactLieGroupClassFunction,
      IsGroup ],
    function( chi, H )
      local G,
            c,
            id;

      G := UnderlyingGroup( chi );
      id := IdCompactLieGroupClassFunction( chi );

      if not IsSubgroup( G, H ) then
        Error( "<H> must be a subgroup of <G>." );
      fi;

      if not HasIdOfElementaryCompactLieGroup( G ) or
         not IdOfElementaryCompactLieGroup( G ) in [ [ 1, 2 ], [ 2, 2 ] ] then
        TryNextMethod( );
      fi;

      if ( IdOfElementaryCompactLieGroup( G ) = SpecialOrthogonalGroupOverReal( 2 ) ) then
        if ( H = G ) then
          return Coefficient( id[ 1 ], 0 );
        fi;
      elif ( G = OrthogonalGroupOverReal( 2 ) ) then
        if ( H = G ) then
          return ( Coefficient( id[ 1 ], 0 ) + id[ 2 ] )/2;
        elif ( H = SpecialOrthogonalGroupOverReal( 2 ) ) then
          return Coefficient( id[ 1 ], 0 );
        fi;
      fi;
    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <C> );
##
  InstallMethod( DimensionOfFixedSet,
    "returns dimension of fixed set of <C> w.r.t. SO(2)-character <chi>",
    [ IsCompactLieGroupCharacter and HasIdCompactLieGroupClassFunction,
      IsCompactLieGroupConjugacyClassSubgroupsRep ],
    20,
    function( chi, C )
      local G,
            idchi,
	    l, h,
            idC,
	    degs;

      G := UnderlyingGroup( chi );
      if not ( G = SpecialOrthogonalGroupOverReal( 2 ) ) then
        TryNextMethod( );
      fi;
      
      idchi := IdCompactLieGroupClassFunction( chi );
      if IsZero( idchi[ 1 ] ) then
        return 0;
      fi;

      l := LowestDegree( idchi[ 1 ] );
      h := DegreeOfLaurentPolynomial( idchi[ 1 ] );
      idC := IdCCS( C );

      degs := Filtered( [ l .. h ], d -> Divides( idC[ 1 ], d ) );
      return Sum( List( degs, d -> Coefficient( idchi[ 1 ], d ) ) );
    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <C> );
##
  InstallMethod( DimensionOfFixedSet,
    "returns dimension of fixed set of <C> w.r.t. O(2)-character <chi>",
    [ IsCompactLieGroupCharacter and HasIdCompactLieGroupClassFunction,
      IsCompactLieGroupConjugacyClassSubgroupsRep ],
    20,
    function( chi, C )
      local G,
            idchi,
	    l, h,
            idC,
	    degs,
	    dim;

      G := UnderlyingGroup( chi );
      if not ( G = OrthogonalGroupOverReal( 2 ) ) then
        TryNextMethod( );
      fi;
      
      idchi := IdCompactLieGroupClassFunction( chi );
      if IsZero( idchi[ 1 ] ) then
        return 0;
      fi;

      l := LowestDegree( idchi[ 1 ] );
      h := DegreeOfLaurentPolynomial( idchi[ 1 ] );
      idC := IdCCS( C );

      if ( idC[ 2 ] = 1 ) then
        degs := Filtered( [ l .. h ], d -> Divides( idC[ 1 ], d ) );
        return Sum( List( degs, d -> Coefficient( idchi[ 1 ], d ) ) );
      elif ( idC[ 2 ] = 2 ) then
        degs := Filtered( [ 1 .. h ], d -> Divides( idC[ 1 ], d ) );
        return Sum( List( degs, d -> Coefficient( idchi[ 1 ], d ) ) ) +
	       ( Coefficient( idchi[ 1 ], 0 ) + idchi[ 2 ] )/2;
      else
        Error( "Invalid CCS." );
      fi;
    end
  );

#############################################################################
##
#A  OrbitTypes( <chi> )
##

  # For SO(2)
  InstallMethod( OrbitTypes,
    "orbit types of character of an elementary compact Lie group",
    [ IsCompactLieGroupCharacter ],
    function( chi )
      local G,
            CCSs,
            l;

      G := UnderlyingGroup( chi );
      if not HasIdOfElementaryCompactLieGroup( G ) or
          not ( IdOfElementaryCompactLieGroup( G ) = [ 1, 2 ] ) then
        TryNextMethod( );
      fi;

      CCSs := ConjugacyClassesSubgroups( G );
      l := IdIrr( chi );

      if ( l = 0 ) then
        return [ CCSs[ 0, 1 ] ];
      else
        return [ CCSs[ l, 1 ], CCSs[ 0, 1 ] ];
      fi;
    end
  );

  # For O(2)
  InstallMethod( OrbitTypes,
    "orbit types of character of an elementary compact Lie group",
    [ IsCompactLieGroupCharacter ],
    function( chi )
      local G,
            CCSs,
            l;

      G := UnderlyingGroup( chi );
      if not HasIdOfElementaryCompactLieGroup( G ) and
          not ( IdOfElementaryCompactLieGroup( G ) = [ 2, 2 ] ) then
        TryNextMethod( );
      fi;

      CCSs := ConjugacyClassesSubgroups( G );
      l := IdIrr( chi );

      if ( l = -1 ) then
        return [ CCSs[ 0, 1 ], CCSs[ 0, 2 ] ];
      elif ( l = 0 ) then
        return [ CCSs[ 0, 2 ] ];
      else
        return [ CCSs[ l, 1 ], CCSs[ l, 2 ], CCSs[ 0, 2 ] ];
      fi;
    end
  );


#############################################################################
##
#E  ElementaryCompactLieGroup.gi . . . . . . . . . . . . . . . . . . . . . . .  ends here
