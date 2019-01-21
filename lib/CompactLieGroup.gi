#############################################################################
##
#W  CompactLieGroup.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to
##  compact Lie group.
##
##  Todo:
##    1. The speed of current implementation of DimensionOfFixedSet
##       for finite subgroup is not satisfactory. Think about how to
##       improve it.
##

##  Part 1: Compact Lie Group (CLG)

#############################################################################
##
#O  PrintObj( <G> )
##
  InstallMethod( PrintObj,
    "print a compact Lie group",
    [ IsCompactLieGroup ],
    10,
    function( G )
      Print( String( G ) );
    end
  );

#############################################################################
##
#O  ViewObj( <G> )
##
  InstallMethod( ViewObj,
    "view a compact Lie group",
    [ IsCompactLieGroup ],
    10,
    function( G )
      Print( ViewString( G ) );
    end
  );

#############################################################################
##
#P  IsFinite( <G> )
##
  InstallImmediateMethod( IsFinite,
    "all considered compact Lie groups are infinite",
    IsCompactLieGroup,
    0,
    G -> false
  );

#############################################################################
##
#A  DimensionOfCompactLieGroup( <G> )
##
  InstallImmediateMethod( DimensionOfCompactLieGroup,
    "dimension of a finite group is zero",
    IsGroup and IsFinite,
    0,
    G -> 0
  );

#############################################################################
##
#A  Dimension( <G> )
##
  InstallMethod( Dimension,
    "synonym for DimensionOfCompactLieGroup",
    [ IsGroup ],
    G -> DimensionOfCompactLieGroup( G )
  );

#############################################################################
##
#A  RankOfCompactLieGroup( <G> )
##
  InstallImmediateMethod( RankOfCompactLieGroup,
    "rank of a finite group is zero",
    IsGroup and IsFinite,
    0,
    G -> 0
  );

#############################################################################
##
#O  Rank( <G> )
##
  InstallMethod( Rank,
    "synonym for RankOfCompactLieGroup",
    [ IsCompactLieGroup ],
    G -> RankOfCompactLieGroup( G )
  );


##  Part 2: CCS of CLG

#############################################################################
##
#U  NewCompactLieGroupConjugacyClassSubgroups(
#U      IsCompactLieGroupConjugacyClassSubgroupsRep, <G>, <attr> )
##
  InstallMethod( NewCompactLieGroupConjugacyClassSubgroups,
    "constructor of CCS of compact Lie group",
    [ IsGroup and IsMatrixGroup, IsGroup, IsRecord ],
    function( filt, G, attr )
      local fam,	# family of CCS
            cat,	# category of CCS
            rep,	# representation of CCS
            C;		# CCS

      # objectify the CCS
      fam := CollectionsFamily( FamilyObj( G ) );
      cat := CategoryCollections( filt );
      rep := IsCompactLieGroupConjugacyClassSubgroupsRep;
      C := Objectify( NewType( fam, cat and rep ), rec( ) );

      SetActingDomain( C, G );
      if IsBound( attr.order_of_weyl_group ) then
        SetOrderOfWeylGroup( C, attr.order_of_weyl_group );
      fi;

      if IsBound( attr.representative ) then
        SetRepresentative( C, attr.representative );
        SetParentAttr( attr.representative, G );

        if IsBound( attr.order_of_weyl_group ) then
          SetOrderOfWeylGroup( attr.representative, attr.order_of_weyl_group );
        fi;

        if IsBound( attr.normalizer ) then
          SetStabilizerOfExternalSet( C, attr.normalizer );
          SetNormalizerInParent( attr.representative, attr.normalizer );
        fi;
      fi;

      if IsBound( attr.goursat_info ) then
        SetGoursatInfo( C, attr.goursat_info );
      fi;

      if IsBound( attr.string ) then
        SetString( C, attr.string );
      fi;

      if IsBound( attr.abbrv ) then
        SetAbbrv( C, attr.abbrv );
      fi;

      if IsBound( attr.order_of_representative ) then
        SetOrderOfRepresentative( C, attr.order_of_representative );
      fi;

      return C;
    end
  );

#############################################################################
##
#O  ViewObj( C )
##
  InstallMethod( ViewObj,
    "delegates to attribute Abbrv",
    [ IsCompactLieGroupConjugacyClassSubgroupsRep and HasAbbrv ],
    function( C )
      Print( Abbrv( C ) );
    end
  );

#############################################################################
##
#O  \=( C1, C2 )
##
  InstallMethod( \=,
    "equivalence relation of CCSs of compact Lie group",
    [ IsCompactLieGroupConjugacyClassSubgroupsRep,
      IsCompactLieGroupConjugacyClassSubgroupsRep  ],
    function( C1, C2 )
      return ( ActingDomain( C1 ) = ActingDomain( C2 ) ) and
             ( IdCCS( C1 ) = IdCCS( C2 ) );
    end
  );

#############################################################################
##
#U  NewCompactLieGroupConjugacyClassesSubgroups(
#U      IsGroup, <G> )
##
  InstallMethod( NewCompactLieGroupConjugacyClassesSubgroups,
    "constructs CCSs of a compact Lie group",
    [ IsMatrixGroup, IsGroup, IsRecord ],
    function( filt, G, data )
      local fam,
            cat,
            rep,
            CCSs;

      # objectify CCSs of the group
      fam := CollectionsFamily( CollectionsFamily( FamilyObj( G ) ) );
      cat := CategoryCollections( CategoryCollections( filt ) );
      rep := IsCompactLieGroupConjugacyClassesSubgroupsRep;
      CCSs := Objectify( NewType( fam, cat and rep ), data );

      # assign attributes to CCSs
      SetUnderlyingGroup( CCSs, G );
      SetString( CCSs, StringFormatted(
        "ConjugacyClassesSubgroups( {} )",
        String( G )
      ) );
      SetAbbrv( CCSs, StringFormatted(
        "ConjugacyClassesSubgroups( {} )",
        ViewString( G )
      ) );
      SetDetail( CCSs, StringFormatted(
        "<conjugacy classes of subgroups of {}, {} zero-mode classes and {} nonzero-mode classes>",
        String( G ),
        NumberOfZeroModeClasses( CCSs ),
        NumberOfNonzeroModeClasses( CCSs )
      ) ); 

      return CCSs;
    end
  );

#############################################################################
##
#P  IsFinite( <CCSs> )
##
  InstallImmediateMethod( IsFinite,
    "",
    IsCompactLieGroupConjugacyClassesSubgroupsRep,
    0,
    CCSs -> false
  );

#############################################################################
##
#O  \[\]( <CCSs>, <j>, <l> )
##
  InstallMethod( \[\],
    "CCS selector for compact Lie group",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep, IsInt, IsInt ],
    function( CCSs, l, j )
      local G,
            cl,
            attr,
            CCSs_ECLG,
            C1_proto,
            idC1,
            C1,
            H1,
            L,
            epi,
            cat_list,
            cat,
            C;

      if ( l = 0 ) and ( j in [ 1 .. NumberOfZeroModeClasses( CCSs ) ] ) then
        cl := Filtered( CCSs!.ccsClasses, cl -> cl.is_zero_mode )[ j ];
        C := cl.proto;
      elif ( l > 0 ) and ( j in [ 1 .. NumberOfNonzeroModeClasses( CCSs ) ] ) then
        cl := Filtered( CCSs!.ccsClasses, cl -> not cl.is_zero_mode )[ j ];
        attr := rec( );
        G := UnderlyingGroup( CCSs );

        if IsBound( cl.goursat_info ) then
          CCSs_ECLG := ConjugacyClassesSubgroups( DirectProductInfo( G ).groups[ 1 ] );
          C1_proto := cl.goursat_info.C1;
          idC1 := ShallowCopy( IdCCS( C1_proto ) );
          idC1[ 1 ] := l*idC1[ 1 ];
          C1 := CCSs_ECLG[ idC1 ];

          epi := GroupHomomorphismByImages(
            Representative( C1 ),
            Representative( C1_proto )
          );

          attr.goursat_info := rec(
            C1		:= C1,
            C2		:= cl.goursat_info.C2,
            epi1_list	:= epi*cl.goursat_info.epi1_list,
            epi2_list	:= cl.goursat_info.epi2_list,
            L		:= cl.goursat_info.L
          );
        fi;

        if IsBound( cl.representative ) then
          attr.representative := cl.representative( l );
        fi;

        if IsBound( cl.normalizer ) then
          attr.normalizer := cl.normalizer( l );
        fi;

        if IsBound( cl.abbrv ) then
          if IsBound( cl.goursat_info ) and ( Order( cl.goursat_info.L ) > 1 ) then
            attr.abbrv := StringFormatted( cl.abbrv, idC1[ 1 ], l );
          else
            attr.abbrv := StringFormatted( cl.abbrv, l );
          fi;
        fi;

        if IsBound( cl.order_of_representative ) then
          attr.order_of_representative := l*cl.order_of_representative;
        fi;

        if IsBound( cl.order_of_weyl_group ) then
          attr.order_of_weyl_group := cl.order_of_weyl_group;
        fi;

        cat_list := [ IsMatrixGroup, IsGroup ];
        cat := First( cat_list, filt -> filt( G ) );
        C := NewCompactLieGroupConjugacyClassSubgroups( cat, G, attr );
      else
        Error( "Invalid CCS id." );
      fi;

      SetIdCCS( C, [ l, j ] );
      return C;
    end
  );


##  Part 3: Elementary Compact Lie Group (ECLG)

#############################################################################
##
#U  NewCompactLieGroup( IsCompactLieGroup and IsMatrixGroup and
#U      IsOrthogonalGroupOverReal and IsSpecialOrthogonalGroupOverReal, <r> )
##
  InstallMethod( NewCompactLieGroup,
    "construct a matrix-CLG",
    [ IsCompactLieGroup and
      IsMatrixGroup and
      IsOrthogonalGroupOverReal and
      IsSpecialOrthogonalGroupOverReal,
      IsRecord ],
    function( filt, r )
      local one,	# identity of the matrix-CLG
            fam,	# family of the matrix-CLG
            rep,	# representation of the matrix-CLG
            G;		# matrix-CLG

      # generate the identity of the ECLG (a d-by-d identity matrix)
      one := IdentityMat( r.dimensionMat );

      # define the family of the group
      fam := CollectionsFamily( FamilyObj( one ) );
      rep := IsComponentObjectRep and IsAttributeStoringRep;

      # objectify the (special) orthogonal group
      G := Objectify( NewType( fam, filt and rep ), rec( ) );

      # setup properties of the (special) orthogonal group
      SetOneImmutable( G, one );
      SetDimensionOfMatrixGroup( G, r.dimensionMat );

      return G;
    end
  );

#############################################################################
##
#F  OrthogonalGroupOverReal( <n> )
##
  InstallGlobalFunction( OrthogonalGroupOverReal,
    function( n )
      local G;		# the orthogonal group

      # objectify the group
      G := NewCompactLieGroup(
        IsOrthogonalGroupOverReal,
        rec( dimensionMat := n )
      );

      # setup property(s) and attribute(s) of the group
      SetIsAbelian( G, false );
      SetDimensionOfCompactLieGroup( G, n*(n-1)/2 );
      SetRankOfCompactLieGroup( G, Int( n/2 ) );
      SetIdElementaryCompactLieGroup( G, [ 2, n ] );
      SetString( G, StringFormatted( "OrthogonalGroupOverReal( {} )", n ) );
      SetAbbrv( G, StringFormatted( "O({},R)", n ) );
      SetDetail( G, StringFormatted(
        "<group of {1}x{1} orthogonal matrices over R>",
        DimensionOfMatrixGroup( G )
      ) );

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
      G := NewCompactLieGroup(
        IsSpecialOrthogonalGroupOverReal,
        rec( dimensionMat := n )
      );

      # setup property(s) and attribute(s) of the group
      if ( n = 2 ) then
        SetIsAbelian( G, true );
      else
        SetIsAbelian( G, false );
      fi;
      SetDimensionOfCompactLieGroup( G, n*(n-1)/2 );
      SetRankOfCompactLieGroup( G, Int( n/2 ) );
      SetIdElementaryCompactLieGroup( G, [ 1, n ] );
      SetString( G,
        StringFormatted( "SpecialOrthogonalGroupOverReal( {} )", n )
      );
      SetAbbrv( G, StringFormatted( "SO({},R)", n ) );
      SetDetail( G, StringFormatted(
        "<group of {1}x{1} special orthogonal matrices over R>",
        DimensionOfMatrixGroup( G )
      ) );

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
#F  ElementaryCompactLieGroupId( <id...> )
##
  InstallGlobalFunction( ElementaryCompactLieGroupId,
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
#A  IdGroup( <G> )
##
  InstallImmediateMethod( IdGroup,
    "synonym for IdElementaryCompactLieGroup for ECLG",
    IsCompactLieGroup and HasIdElementaryCompactLieGroup,
    0,
    G -> IdElementaryCompactLieGroup( G )
  );


#############################################################################
##
#O  \=( <G>, <H> )
##
  InstallMethod( \=,
    "equivalence relation of ECLGs",
    [ IsCompactLieGroup and HasIdElementaryCompactLieGroup,
      IsCompactLieGroup and HasIdElementaryCompactLieGroup ],
    function( G, H )
      return IdElementaryCompactLieGroup( G ) = IdElementaryCompactLieGroup( H );
    end
  );

#############################################################################
##
#O  \in( <obj>, SO(n) )
##
  InstallMethod( \in,
    "Membership test for SO(n)",
    [ IsObject, IsSpecialOrthogonalGroupOverReal ],
    function( obj, G )
      if  ( TransposedMat( obj ) * obj = One( G ) ) and
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
    [ IsObject, IsOrthogonalGroupOverReal ],
    function( obj, G )
      if ( TransposedMat( obj ) * obj = One( G ) ) then
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

      if not IsFinite( col ) then
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
#O  IsSubset( <col>, <G> )
##
  InstallMethod( IsSubset,
    "Test if an ECLG is a subgroup of a finite group",
    [ IsCollection, IsCompactLieGroup ],
    function( col, G )
      if IsFinite( col ) then
        return false;
      else
        TryNextMethod( );
      fi;
    end
  );

#############################################################################
##
#O  IsSubset( <G>, <U> )
##
  InstallMethod( IsSubset,
    "Test if an ECLG is a subset of another ECLG",
    [ IsOrthogonalGroupOverReal,
      IsOrthogonalGroupOverReal ],
    function( G, U )
      return ( DimensionOfMatrixGroup( G ) = DimensionOfMatrixGroup( U ) );
    end
  );

#############################################################################
##
#O  IsSubset( <G>, <U> )
##
  InstallMethod( IsSubset,
    "Test if an ECLG is a subset of another ECLG",
    [ IsSpecialOrthogonalGroupOverReal,
      IsSpecialOrthogonalGroupOverReal ],
    function( G, U )
      return ( DimensionOfMatrixGroup( G ) = DimensionOfMatrixGroup( U ) );
    end
  );

#############################################################################
##
#O  IsSubset( <G>, <U> )
##
  InstallMethod( IsSubset,
    "Test if an ECLG is a subset of another ECLG",
    [ IsOrthogonalGroupOverReal,
      IsSpecialOrthogonalGroupOverReal ],
    function( G, U )
      return ( DimensionOfMatrixGroup( G ) = DimensionOfMatrixGroup( U ) );
    end
  );

#############################################################################
##
#O  IsSubset( <G>, <U> )
##
  InstallMethod( IsSubset,
    "Test if an ECLG is a subset of another ECLG",
    [ IsSpecialOrthogonalGroupOverReal,
      IsOrthogonalGroupOverReal ],
    function( G, U )
      return false;
    end
  );


##  Part 4: CCS of ECLG

#############################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
  InstallMethod( ConjugacyClassesSubgroups,
    "CCSs of SO(n)",
    [ IsSpecialOrthogonalGroupOverReal ],
    function( G )
      local n,				# dimension of matrices
            data,			#
            class,
            x;

      # generate CCS classes for SO(2)
      data := rec( );
      n := DimensionOfMatrixGroup( G );
      if ( n = 2 ) then
        x := X( Integers, "x" );
        data.ccsClasses := [ ];

        # SO(2)
        class := rec(
          is_zero_mode			:= true,
          order_of_weyl_group		:= One( x ),
          representative		:= SpecialOrthogonalGroupOverReal( 2 ),
          normalizer			:= G,
          order_of_representative	:= x,
          abbrv				:= "(SO(2))"			);
        class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                       IsMatrixGroup, G, class );
        Add( data.ccsClasses, class );

        # Z_l
        class := rec(
          is_zero_mode			:= false,
          order_of_weyl_group		:= x,
          representative		:= mCyclicGroup( 1 ),
          normalizer			:= G,
          order_of_representative	:= One( x ),
          abbrv				:= "(Z_{})"			);
        class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                       IsMatrixGroup, G, class );
        class.representative	:= l -> mCyclicGroup( l );
        class.normalizer	:= l -> G;
        Add( data.ccsClasses, class );
      fi;

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
    "CCSs of O(n)",
    [ IsOrthogonalGroupOverReal ],
    function( G )
      local n,		# dimension of matrices
            data,
            class,
            x;

      # generate CCS classes for O(2)
      data := rec( );
      n := DimensionOfMatrixGroup( G );
      if ( n = 2 ) then
        x := X( Integers, "x" );
        data.ccsClasses := [ ];

        # SO(2)
        class := rec(
          is_zero_mode			:= true,
          order_of_weyl_group		:= 2*One( x ),
          representative		:= SpecialOrthogonalGroupOverReal( 2 ),
          normalizer			:= G,
          order_of_representative	:= x,
          abbrv				:= "(SO(2))"				);
        class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                       IsMatrixGroup, G, class );
        Add( data.ccsClasses, class );

        # O(2)
        class := rec(
          is_zero_mode			:= true,
          order_of_weyl_group		:= One( x ),
          representative		:= OrthogonalGroupOverReal( 2 ),
          normalizer			:= G,
          order_of_representative	:= 2*x,
          abbrv				:= "(O(2))"			);
        class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                       IsMatrixGroup, G, class );
        Add( data.ccsClasses, class );

        # Z_l
        class := rec(
          is_zero_mode			:= false,
          order_of_weyl_group		:= 2*x,
          representative		:= mCyclicGroup( 1 ),
          normalizer			:= G,
          order_of_representative	:= One( x ),
          abbrv				:= "(Z_{})"			);
        class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                       IsMatrixGroup, G, class );
        class.representative	:= l -> mCyclicGroup( l );
        class.normalizer	:= l -> G;
        Add( data.ccsClasses, class );

        # D_l
        class := rec(
          is_zero_mode			:= false,
          order_of_weyl_group		:= 2*One( x ),
          representative		:= mDihedralGroup( 1 ),
          normalizer			:= mDihedralGroup( 2 ),
          order_of_representative	:= 2*One( x ),
          abbrv				:= "(D_{})"			);
        class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                       IsMatrixGroup, G, class );
        class.representative	:= l -> mDihedralGroup( l );
        class.normalizer	:= l -> mDihedralGroup( 2*l );
        Add( data.ccsClasses, class );
      fi;

      # objectify the CCSs object
      return NewCompactLieGroupConjugacyClassesSubgroups(
          IsMatrixGroup, G, data );
    end
  );

#############################################################################
##
#O  NumberOfZeroModeClasses( <CCSs> )
##
  InstallMethod( NumberOfZeroModeClasses,
    "length of nonzero mode CCS classes",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep ],
    function( CCSs )
      if IsBound( CCSs!.ccsClasses ) then
        return Number( CCSs!.ccsClasses, cl -> cl.is_zero_mode );
      else
        return "unknown";
      fi;
    end
  );

#############################################################################
##
#O  NumberOfNonzeroModeClasses( <CCSs> )
##
  InstallMethod( NumberOfNonzeroModeClasses,
    "length of nonzero mode CCS classes",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep ],
    function( CCSs )
      if IsBound( CCSs!.ccsClasses ) then
        return Number( CCSs!.ccsClasses, cl -> not cl.is_zero_mode );
      else
        return "unknown";
      fi;
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

      if not HasIdElementaryCompactLieGroup( G ) or
          not ( IdElementaryCompactLieGroup( G ) in [ [ 1, 2 ], [ 2, 2 ] ] ) then
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


##  Part 5: Representation and Character Theory for ECLG

#############################################################################
##
#A  CharacterTable( <G> )
##
  InstallMethod( CharacterTable,
    "contains character table of an ECLG",
    [ IsCompactLieGroup ],
    function( G )
      local tbl,
            fam,
            cat,
            rep;

      fam := NearlyCharacterTablesFamily;
      cat := IsCompactLieGroupCharacterTable;
      rep := IsComponentObjectRep and IsAttributeStoringRep;

      tbl := Objectify( NewType( fam, cat and rep ), rec( ) );
      SetUnderlyingGroup( tbl, G );
      SetUnderlyingCharacteristic( tbl, 0 );
      SetString( tbl, StringFormatted( "CharacterTable( {} )", String( G ) ) );
      SetAbbrv( tbl, StringFormatted( "CharacterTable( {} )", ViewString( G ) ) );

      return tbl;
    end
  );

#############################################################################
##
#C  Irr( <G> )
##
  InstallMethod( Irr,
    "irreducible representations of compact Lie group",
    [ IsCompactLieGroup ],
    function( G )
      local fam,	# family of irrs
            cat,	# category of irrs
            rep,	# representation of irrs
            irrs;	# irreducible representations of O(2)

      fam := CollectionsFamily( CollectionsFamily( CyclotomicsFamily ) );
      cat := IsCompactLieGroupIrrCollection;
      rep := IsComponentObjectRep and IsAttributeStoringRep;

      irrs := Objectify( NewType( fam, cat and rep ), rec( ) );
      SetUnderlyingGroup( irrs, G );
      SetUnderlyingCharacterTable( irrs, CharacterTable( G ) );
      SetString( irrs, StringFormatted( "Irr( {} )", String( G ) ) );
      SetAbbrv( irrs, StringFormatted( "Irr( {} )", ViewString( G ) ) );

      return irrs;
    end
  );

#############################################################################
##
#C  Irr( <tbl> )
##
  InstallMethod( Irr,
    "irreducible representations of compact Lie group",
    [ IsCompactLieGroupCharacterTable ],
    tbl -> Irr( UnderlyingGroup( tbl ) )
  );

#############################################################################
##
#U  NewCompactLieGroupClassFunction(
#U      IsCompactLieGroupClassFunction, <r> )
##
  InstallMethod( NewCompactLieGroupClassFunction,
    "constructs class function of a compact Lie group",
    [ IsCompactLieGroupClassFunction, IsCompactLieGroup, IsRecord ],
    function( filt, G, data )
      local tbl,
            fam,
            cat,
            rep,
            phi;

      tbl := CharacterTable( G );

      fam := GeneralMappingsFamily(
        ElementsFamily( FamilyObj( G ) ),
        CyclotomicsFamily
      );
      cat := filt;
      rep := IsMappingByFunctionRep;

      phi := Objectify( NewType( fam, cat and rep ), data );

      SetSource( phi, G );
      SetRange( phi, Cyclotomics );
      SetUnderlyingCharacterTable( phi, tbl );
      SetUnderlyingGroup( phi, G );
      SetString( phi, StringFormatted(
        "Character( CharacterTable( {1} ), Mapping( {1}, {2} ) )",
        String( G ),
        ViewString( Cyclotomics )
      ) );
      SetAbbrv( phi, StringFormatted(
        "Character( CharacterTable( {1} ), Mapping( {1}, {2} ) )",
        ViewString( G ),
        ViewString( Cyclotomics )
      ) );

      return phi;
    end
  );

#############################################################################
##
#O  ViewObj
##
  InstallMethod( ViewObj,
    "",
    [ IsCompactLieGroupClassFunction and IsGeneralMapping ],
    20,
    function( chi )
      if HasIdIrr( chi ) then
        PrintFormatted( "Irr( {} ){}",
            UnderlyingGroup( chi ), Flat( [ IdIrr( chi ) ] ) );
      else
        Print( ViewString( chi ) );
      fi;
    end
  );

#############################################################################
##
#O  PrintObj
##
  InstallMethod( PrintObj,
    "",
    [ IsCompactLieGroupClassFunction and IsGeneralMapping ],
    20,
    function( chi )
      if HasIdCompactLieGroupClassFunction( chi ) then
        PrintFormatted( "Character( {}, id = {} )",
            String( UnderlyingCharacterTable( chi ) ),
            IdCompactLieGroupClassFunction( chi ) );
      else
        Print( String( chi ) );
      fi;
    end
  );

#############################################################################
##
#O  \[\]( <irrs>, <l> )
##
  InstallMethod( \[\],
    "returns an irreducible SO(2)-representation",
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

      if not HasIdElementaryCompactLieGroup( G ) or
          not ( IdElementaryCompactLieGroup( G ) = [ 1, 2 ] ) then
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

      if not HasIdElementaryCompactLieGroup( G ) or
          not ( IdElementaryCompactLieGroup( G ) = [ 2, 2 ] ) then
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
#O  \+( <chi>, <psi> )
##
  InstallOtherMethod( \+,
    "addition of class functions of compact Lie group",
    IsIdenticalObj,
    [ IsCompactLieGroupClassFunction and IsGeneralMapping,
      IsCompactLieGroupClassFunction and IsGeneralMapping  ],
    function( chi, psi )
      local G,
            cat,
            fun,
            phi,
            id_chi,
            id_psi,
            id;

      G := UnderlyingGroup( chi );
      cat := IsCompactLieGroupClassFunction;
      fun := x -> chi!.fun( x ) + psi!.fun( x );
      phi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );
      if HasIdCompactLieGroupClassFunction( chi ) and
          HasIdCompactLieGroupClassFunction( psi ) then
        id_chi := IdCompactLieGroupClassFunction( chi );
        id_psi := IdCompactLieGroupClassFunction( psi );
        SetIdCompactLieGroupClassFunction( phi, ListN( id_chi, id_psi, \+ ) );
      fi;

      if IsCompactLieGroupCharacter( chi ) and
          IsCompactLieGroupCharacter( psi ) then
        SetIsCompactLieGroupCharacter( phi, true );
      elif IsCompactLieGroupVirtualCharacter( chi ) and
          IsCompactLieGroupVirtualCharacter( psi ) then
        SetIsCompactLieGroupVirtualCharacter( phi, true );
      fi;

      return phi;
    end
  );

#############################################################################
##
#O  AdditiveInverseOp( <chi> )
##
  InstallOtherMethod( AdditiveInverseOp,
    "addition of class functions of compact Lie group",
    [ IsCompactLieGroupClassFunction and IsGeneralMapping ],
    function( chi )
      local G,
            cat,
            fun,
            phi,
            id_chi;

      G := UnderlyingGroup( chi );
      cat := IsCompactLieGroupClassFunction;
      fun := x -> -chi!.fun( x );
      phi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );
      if HasIdCompactLieGroupClassFunction( chi ) then
        id_chi := IdCompactLieGroupClassFunction( chi );
        SetIdCompactLieGroupClassFunction( phi, -id_chi );
      fi;

      if IsCompactLieGroupVirtualCharacter( chi ) then
        SetIsCompactLieGroupVirtualCharacter( phi, true );
      fi;

      return phi;
    end
  );

#############################################################################
##
#O  \*( <chi>, <psi> )
##
  InstallOtherMethod( \*,
    "addition of class functions of compact Lie group",
    IsIdenticalObj,
    [ IsCompactLieGroupClassFunction and IsGeneralMapping,
      IsCompactLieGroupClassFunction and IsGeneralMapping  ],
    function( chi, psi )
      local G,
            cat,
            fun,
            phi,
            id_chi,
            id_psi;

      G := UnderlyingGroup( chi );
      cat := IsCompactLieGroupClassFunction;
      fun := x -> chi!.fun( x ) * psi!.fun( x );
      phi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );
      if HasIdCompactLieGroupClassFunction( chi ) and
          HasIdCompactLieGroupClassFunction( psi ) then
        id_chi := IdCompactLieGroupClassFunction( chi );
        id_psi := IdCompactLieGroupClassFunction( psi );
        SetIdCompactLieGroupClassFunction( phi, ListN( id_chi, id_psi, \* ) );
      fi;

      if IsCompactLieGroupCharacter( chi ) and
          IsCompactLieGroupCharacter( psi ) then
        SetIsCompactLieGroupCharacter( phi, true );
      elif IsCompactLieGroupVirtualCharacter( chi ) and
          IsCompactLieGroupVirtualCharacter( psi ) then
        SetIsCompactLieGroupVirtualCharacter( phi, true );
      fi;

      return phi;
    end
  );

#############################################################################
##
#O  \*( <r>, <psi> )
##
  InstallOtherMethod( \*,
    "addition of class functions of compact Lie group",
    [ IsRat,
      IsCompactLieGroupClassFunction and IsGeneralMapping  ],
    function( r, chi )
      local G,
            cat,
            fun,
            phi,
            id_chi;

      G := UnderlyingGroup( chi );
      cat := IsCompactLieGroupClassFunction;
      fun := x -> r*chi!.fun( x );
      phi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );
      if HasIdCompactLieGroupClassFunction( chi ) then
        id_chi := IdCompactLieGroupClassFunction( chi );
        SetIdCompactLieGroupClassFunction( phi, r*id_chi );
      fi;

      if IsCompactLieGroupCharacter( chi ) and IsPosInt( r ) then
        SetIsCompactLieGroupCharacter( phi, true );
      elif IsCompactLieGroupVirtualCharacter( chi ) and IsInt( r ) then
        SetIsCompactLieGroupVirtualCharacter( phi, true );
      fi;

      return phi;
    end
  );

#############################################################################
##
#A  DegreeOfCharacter( <chi> )
##
  InstallMethod( DegreeOfCharacter,
    "",
    [ IsCompactLieGroupVirtualCharacter ],
    function( chi )
      local G;

      G := UnderlyingGroup( chi );

      return Image( chi, One( G ) );
    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <H> );
##

  # for finite subgroup
  InstallMethod( DimensionOfFixedSet,
    "dimension of fixed set of <H>",
    [ IsCompactLieGroupCharacter, IsGroup ],
    function( chi, H )
      local G;

      G := UnderlyingGroup( chi );

      if not IsSubgroup( G, H ) then
        Error( "<H> must be a subgroup of <G>." );
      fi;

      if IsFinite( H ) then
        return Sum( List( H ), x -> Image( chi, x ) )/Order( H );
      fi;

      TryNextMethod( );
    end
  );

  # for infinite subgroup of SO(2) and O(2)
  InstallMethod( DimensionOfFixedSet,
    "dimension of fixed set of <H>",
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

      if ( G = SpecialOrthogonalGroupOverReal( 2 ) ) then
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

      TryNextMethod( );
    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <C> );
##

  # for CCS of SO(2)
  InstallMethod( DimensionOfFixedSet,
    "returns dimension of fixed set of a CCS",
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

  # for CCS of O(2)
  InstallMethod( DimensionOfFixedSet,
    "returns dimension of fixed set of a CCS",
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

  # for CCS of finite order
  InstallMethod( DimensionOfFixedSet,
    "",
    [ IsCompactLieGroupCharacter,
      IsCompactLieGroupConjugacyClassSubgroupsRep ],
    function( chi, C )
      if not ( Degree( OrderOfRepresentative( C ) ) = 0 ) then
        TryNextMethod( );
      fi;

      return DimensionOfFixedSet( chi, Representative( C ) );
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
      if not HasIdElementaryCompactLieGroup( G ) or
          not ( IdElementaryCompactLieGroup( G ) = [ 1, 2 ] ) then
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
      if not HasIdElementaryCompactLieGroup( G ) and
          not ( IdElementaryCompactLieGroup( G ) = [ 2, 2 ] ) then
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
#E  CompactLieGroup.gi . . . . . . . . . . . . . . . . . . . . . .  ends here
