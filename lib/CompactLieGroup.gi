#############################################################################
##
#W  CompactLieGroup.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to
##  compact Lie group.
##

##  Part 1: Compact Lie Group (CLG)

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
#A  Dimension( <G> )
##
  InstallOtherMethod( Dimension,
    "synonym for DimensionOfCompactLieGroup",
    [ IsCompactLieGroup ],
    G -> DimensionOfCompactLieGroup( G )
  );

#############################################################################
##
#A  Rank( <G> )
##
  InstallMethod( Rank,
    "synonym for RankOfCompactLieGroup",
    [ IsCompactLieGroup ],
    G -> RankOfCompactLieGroup( G )
  );

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


##  Part 2: CCS of CLG

#############################################################################
##
#U  NewCompactLieGroupConjugacyClassSubgroups(
#U      IsCompactLieGroupConjugacyClassSubgroupsRep, <G>, <r> )
##
  InstallMethod( NewCompactLieGroupConjugacyClassSubgroups,
    "constructor of CCS of compact Lie group",
    [ IsMatrixGroup, IsGroup, IsRecord ],
    function( filt, G, r )
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
      if IsBound( r.order_of_weyl_group ) then
        SetOrderOfWeylGroup( C, r.order_of_weyl_group );
      fi;

      if IsBound( r.representative ) then
        SetRepresentative( C, r.representative );
        SetParentAttr( r.representative, G );

        if IsBound( r.order_of_weyl_group ) then
          SetOrderOfWeylGroup( r.representative, r.order_of_weyl_group );
        fi;

        if IsBound( r.normalizer ) then
          SetStabilizerOfExternalSet( C, r.normalizer );
          SetNormalizerInParent( r.representative, r.normalizer );
        fi;
      fi;

      return C;
    end
  );

#############################################################################
##
#U  NewCCSClass( IsGroup, <cat>, <r> )
##
# InstallMethod( NewCCSClass,
#   "constructs a ccs class of a compact Lie group",
#   [ IsCompactLieGroup, IsOperation, IsRecord ],
#   function( filt, cat, r )
#     local G,
#           ccs_class,
#           C,
#           CC;

#     G := r.group;

#     ccs_class := rec( );
#     ccs_class.is_zero_mode := r.is_zero_mode;
#     ccs_class.order_of_weyl_group := r.order_of_weyl_group;

#     if r.is_zero_mode then
#       C := NewCompactLieGroupConjugacyClassSubgroups( cat, G );
#       SetOrderOfWeylGroup( C, r.order_of_weyl_group );

#       if IsBound( r.normalizer ) then
#         SetStabilizerOfExternalSet( C, r.normalizer );
#       fi;

#       if IsBound( r.representative ) then
#         SetRepresentative( C, r.representative );
#         SetParentAttr( r.representative, G );
#         SetOrderOfWeylGroup( r.representative, r.order_of_weyl_group );
#         if IsBound( r.normalizer ) then
#           SetNormalizerInParent( r.representative, r.normalizer );
#         fi;
#       fi;
#       ccs_class.ccs := C;
#     else
#       CC := function( l )
#         local C,
#               H,
#               NH;

#         C := NewCompactLieGroupConjugacyClassSubgroups( cat, G );
#         SetOrderOfWeylGroup( C, r.order_of_weyl_group );

#         if IsBound( r.normalizer ) then
#           NH := r.normalizer( l );
#           SetStabilizerOfExternalSet( C, NH );
#         fi;
#       
#         if IsBound( r.representative ) then
#           H := r.representative( l );
#           SetRepresentative( C, H );
#           SetParentAttr( H, G );
#           SetOrderOfWeylGroup( H, r.order_of_weyl_group );
#           if IsBound( r.normalizer ) then
#             SetNormalizerInParent( H, NH );
#           fi;
#         fi;

#         return C;
#       end;
#       ccs_class.ccs := CC;
#     fi;

#     return ccs_class;
#   end
# );

#############################################################################
##
#U  NewCompactLieGroupConjugacyClassesSubgroups(
#U      IsGroup, <G> )
##
  InstallMethod( NewCompactLieGroupConjugacyClassesSubgroups,
    "constructs CCSs of a compact Lie group",
    [ IsMatrixGroup, IsGroup, IsRecord ],
    function( filt, G, r )
      local fam,
            cat,
            rep,
            CCSs;

      # objectify CCSs of the group
      fam := CollectionsFamily( CollectionsFamily( FamilyObj( G ) ) );
      cat := CategoryCollections( CategoryCollections( filt ) );
      rep := IsCompactLieGroupConjugacyClassesSubgroupsRep;
      CCSs := Objectify( NewType( fam, cat and rep ), r );

      # assign attributes to CCSs
      SetUnderlyingGroup( CCSs, G );
      SetString( CCSs,
        StringFormatted( "ConjugacyClassesSubgroups( {} )",
        String( G ) )
      );
#     SetIsFinite( CCSs, false );

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
#O  ViewString( <CCSs> )
##
  InstallMethod( ViewString,
    "view string of CCS list of CLG",
    [ IsCollection and IsCompactLieGroupConjugacyClassesSubgroupsRep ],
    function( CCSs )
      local G;

      G := UnderlyingGroup( CCSs );
      return StringFormatted( "ConjugacyClassesSubgroups( {} )",
          ViewString( G ) );
    end
  );

#############################################################################
##
#A  DisplayString( <CCSs> )
##
  InstallMethod( DisplayString,
    "Display CCSs of CLG",
    [ IsCollection and IsCompactLieGroupConjugacyClassesSubgroupsRep ],
    function( CCSs )
      local G,
            str;

      G := UnderlyingGroup( CCSs );

      return StringFormatted(
        "<conjugacy classes of subgroups of {}, {} zero-mode classes and {} nonzero-mode classes>",
        DisplayString( G ),
        NumberOfZeroModeClasses( CCSs ),
        NumberOfNonzeroModeClasses( CCSs )
      );
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

#############################################################################
##
#O  ViewString( <G> )
##
  InstallMethod( ViewString,
    "view string of SO(n)",
    [ IsSpecialOrthogonalGroupOverReal ],
    G -> StringFormatted( "SO({},R)", DimensionOfMatrixGroup( G ) )
  );

#############################################################################
##
#O  ViewString( <G> )
##
  InstallMethod( ViewString,
    "view string of O(n)",
    [ IsOrthogonalGroupOverReal ],
    G -> StringFormatted( "O({},R)", DimensionOfMatrixGroup( G ) )
  );

#############################################################################
##
#O  DisplayString( <G> )
##
  InstallMethod( DisplayString,
    "display string of SO(n)",
    [ IsSpecialOrthogonalGroupOverReal ],
    G -> StringFormatted(
      "<group of {1}x{1} special orthogonal matrices over R>",
      DimensionOfMatrixGroup( G )
    )
  );

#############################################################################
##
#O  DisplayString( <G> )
##
  InstallMethod( DisplayString,
    "display string of O(n)",
    [ IsOrthogonalGroupOverReal ],
    G -> StringFormatted(
      "<group of {1}x{1} orthogonal matrices over R>",
      DimensionOfMatrixGroup( G )
    )
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
            r,				#
            x,
            ord,
            H,
            NH;

      # generate CCS classes for SO(2)
      r := rec( );
      n := DimensionOfMatrixGroup( G );
      if ( n = 2 ) then
        x := X( Integers, "x" );
        r.ccsClasses := [ ];

        # SO(2)
        ord := One( x );
        H := SpecialOrthogonalGroupOverReal( 2 );
        NH := G;
        Add( r.ccsClasses, rec(
          is_zero_mode := true,
          ord_of_weyl_group := ord,
          ccs := NewCompactLieGroupConjugacyClassSubgroups(
            IsMatrixGroup,
            G,
            rec( order_of_weyl_group	:= ord,
                 representative		:= H,
                 normalizer		:= NH	)
          )
        ) );

        # Z_l
        ord:= x;
        Add( r.ccsClasses, rec(
          is_zero_mode := false,
          order_of_weyl_group := ord,
          ccs := function( l )
            local H,
                  NH;

            H := mCyclicGroup( l );
            NH := G;
            return NewCompactLieGroupConjugacyClassSubgroups(
              IsMatrixGroup,
              G,
              rec( order_of_weyl_group	:= ord,
                   representative	:= H,
                   normalizer		:= NH	)
            );
          end
        ) );
      fi;

      # return the CCSs object
      return NewCompactLieGroupConjugacyClassesSubgroups(
          IsMatrixGroup, G, r );
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
            r,		# procedure generating CCS classes
            x,
            ord,
            H,
            NH;

      # generate CCS classes for O(2)
      r := rec( );
      n := DimensionOfMatrixGroup( G );
      if ( n = 2 ) then
        x := X( Integers, "x" );
        r.ccsClasses := [ ];

        # SO(2)
        ord := 2*One( x );
        H := SpecialOrthogonalGroupOverReal( 2 );
        NH := G;
        Add( r.ccsClasses, rec(
          is_zero_mode := true,
          ord_of_weyl_group := ord,
          ccs := NewCompactLieGroupConjugacyClassSubgroups(
            IsMatrixGroup,
            G,
            rec( order_of_weyl_group	:= ord,
                 representative		:= H,
                 normalizer		:= NH	)
          )
        ) );

        # O(2)
        ord := One( x );
        H := OrthogonalGroupOverReal( 2 );
        NH := G;
        Add( r.ccsClasses, rec(
          is_zero_mode := true,
          ord_of_weyl_group := ord,
          ccs := NewCompactLieGroupConjugacyClassSubgroups(
            IsMatrixGroup,
            G,
            rec( order_of_weyl_group	:= ord,
                 representative		:= H,
                 normalizer		:= NH	)
          )
        ) );

        # Z_l
        ord:= 2*x;
        Add( r.ccsClasses, rec(
          is_zero_mode := false,
          order_of_weyl_group := ord,
          ccs := function( l )
            local H,
                  NH;

            H := mCyclicGroup( l );
            NH := G;
            return NewCompactLieGroupConjugacyClassSubgroups(
              IsMatrixGroup,
              G,
              rec( order_of_weyl_group	:= ord,
                   representative	:= H,
                   normalizer		:= NH	)
            );
          end
        ) );

        # D_l
        ord:= 2*One( x );
        Add( r.ccsClasses, rec(
          is_zero_mode := false,
          order_of_weyl_group := ord,
          ccs := function( l )
            local H,
                  NH;

            H := mDihedralGroup( l );
            NH := mDihedralGroup( 2*l );
            return NewCompactLieGroupConjugacyClassSubgroups(
              IsMatrixGroup,
              G,
              rec( order_of_weyl_group	:= ord,
                   representative	:= H,
                   normalizer		:= NH	)
            );
          end
        ) );
      fi;

      # objectify the CCSs object
      return NewCompactLieGroupConjugacyClassesSubgroups(
          IsMatrixGroup, G, r );
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
#A  NumberOfNonzeroModeClasses( <CCSs> )
##
  InstallMethod( NumberOfNonzeroModeClasses,
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
#O  \[\]( <CCSs>, <j>, <l> )
##
  InstallMethod( \[\],
    "CCS selector for SO(2) and O(2)",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep, IsInt, IsInt ],
    function( CCSs, l, j )
      local C;

      if ( l = 0 ) and ( j in [ 1 .. NumberOfZeroModeClasses( CCSs ) ] ) then
        C := Filtered( CCSs!.ccsClasses, cl -> cl.is_zero_mode )[ j ].ccs;
      elif ( l > 0 ) and ( j in [ 1 .. NumberOfNonzeroModeClasses( CCSs ) ] ) then
        C := Filtered( CCSs!.ccsClasses, cl -> not cl.is_zero_mode )[ j ].ccs( l );
      else
        Error( "Invalid CCS id." );
      fi;

      SetIdCCS( C, [ l, j ] );

      return C;
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

      return tbl;
    end
  );

#############################################################################
##
#O  PrintString( <G> )
##
  InstallMethod( PrintString,
    "print string of the character table of a compact Lie group",
    [ IsCompactLieGroupCharacterTable ],
    tbl -> StringFormatted( "CharacterTable( {} )",
        String( UnderlyingGroup( tbl ) ) )
  );

#############################################################################
##
#O  ViewString( <G> )
##
  InstallMethod( ViewString,
    "print string of the character table of a compact Lie group",
    [ IsCompactLieGroupCharacterTable ],
    tbl -> StringFormatted( "CharacterTable( {} )",
        ViewString( UnderlyingGroup( tbl ) ) )
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
#O  ViewString( <irrs> )
##
  InstallMethod( ViewString,
    "view string of irreducible representations of compact Lie group",
    [ IsCompactLieGroupIrrCollection ],
    irrs -> StringFormatted( "Irr( {} ) ",
        ViewString( UnderlyingGroup( irrs ) ) )
  );

#############################################################################
##
#U  NewCompactLieGroupClassFunction(
#U      IsCompactLieGroupClassFunction and IsMappingByFunctionRep, <r> )
##
  InstallMethod( NewCompactLieGroupClassFunction,
    "constructs class function of a compact Lie group",
    [ IsCompactLieGroupClassFunction, IsRecord ],
    function( filt, r )
      local G,
            tbl,
            fam,
            cat,
            rep,
            phi;

      G := r.group;
      tbl := CharacterTable( G );

      fam := GeneralMappingsFamily(
        ElementsFamily( FamilyObj( G ) ),
        CyclotomicsFamily
      );
      cat := filt;
      rep := IsMappingByFunctionRep;

      phi := Objectify(
        NewType( fam, cat and rep ),
        rec( fun := r.fun )
      );

      SetSource( phi, G );
      SetRange( phi, Cyclotomics );
      SetUnderlyingCharacterTable( phi, tbl );
      SetString( phi,
        StringFormatted( "Character( CharacterTable( {1} ), Mapping( {1}, {2} ) )",
            ViewString( G ), ViewString( Cyclotomics ) )
      );

      return phi;
    end
  );

#############################################################################
##
#O  ViewObj( <chi> )
##
  InstallMethod( ViewObj,
    "view string of a class function of a compact Lie group",
    [ IsCompactLieGroupClassFunction ],
    20,
    function( chi )
      Print( String( chi ) );
    end
  );

#############################################################################
##
#O  \[\]( <irrs>, <l> )
##
  InstallOtherMethod( \[\],
    "returns an irreducible representation of the irr list",
    [ IsCompactLieGroupIrrCollection, IsInt ],
    function( irrs, l )
      local G,
            cat,
            fun,
            chi;

      G := UnderlyingGroup( irrs );

      if not IsOrthogonalGroupOverReal( G ) or
          not ( DimensionOfMatrixGroup( G ) = 2 ) then
        TryNextMethod( );
      fi;

      cat := IsCompactLieGroupClassFunction;
      if ( l = -1 ) then
        fun := x -> DeterminantMat( x );
      elif ( l = 0 ) then
        fun := x -> 1;
      elif ( l = 1 ) then
        fun := x -> TraceMat( x );
      elif ( l > 0 ) then
        fun := x -> ( 1 + DeterminantMat( x ) )/2 * TraceMat( x^l );
      else
        Error( StringFormatted( "{} admits no such irreducible representation.\n",
            ViewString( G ) ) );
      fi;
      chi := NewCompactLieGroupClassFunction(
        cat,
        rec( group := G,
             fun := fun  )
      );
      
      SetIsCompactLieGroupCharacter( chi, true );
      SetIsGeneratorsOfSemigroup( chi, true );
      SetIdIrr( chi, l );

      return chi;
    end
  );

#############################################################################
##
#O  \[\]( <irrs>, <l> )
##
  InstallOtherMethod( \[\],
    "returns an irreducible representation of the irr list",
    [ IsCompactLieGroupIrrCollection, IsInt ],
    function( irrs, l )
      local G,
            cat,
            rep,
            fun,
            chi;

      G := UnderlyingGroup( irrs );

      if not IsSpecialOrthogonalGroupOverReal( G ) or
          not ( DimensionOfMatrixGroup( G ) = 2 ) then
        TryNextMethod( );
      fi;

      cat := IsCompactLieGroupClassFunction;
      fun := x -> [ 1, E(4) ]*x^l*[ 1, 0 ];
      chi := NewCompactLieGroupClassFunction( cat,
          rec( group := G, fun := fun ) );
      
      SetIsCompactLieGroupCharacter( chi, true );
      SetIsGeneratorsOfSemigroup( chi, true );
      SetIdIrr( chi, l );

      return chi;
    end
  );

#############################################################################
##
#A  UnderlyingGroup( <chi> )
##
  InstallOtherMethod( UnderlyingGroup,
    "underlying group of a class function of a compact Lie group",
    [ IsCompactLieGroupClassFunction ],
    chi -> UnderlyingGroup( UnderlyingCharacterTable( chi ) )
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
            phi;

      G := UnderlyingGroup( chi );

      phi := NewCompactLieGroupClassFunction(
         IsCompactLieGroupClassFunction, G );
      phi!.fun := x -> chi!.fun( x ) + psi!.fun( x );

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
            phi;

      G := UnderlyingGroup( chi );

      phi := NewCompactLieGroupClassFunction(
         IsCompactLieGroupClassFunction, G );
      phi!.fun := x -> -chi!.fun( x );

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
            phi;

      G := UnderlyingGroup( chi );

      phi := NewCompactLieGroupClassFunction(
         IsCompactLieGroupClassFunction, G );
      phi!.fun := x -> chi!.fun( x ) * psi!.fun( x );

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
#O  DimensionOfFixedSet( <chi>, <H> );
##
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
      else
        TryNextMethod( );
      fi;
    end
  );

  InstallMethod( DimensionOfFixedSet,
    "dimension of fixed set of <H>",
    [ IsCompactLieGroupCharacter, IsGroup ],
    function( chi, H )
      local G;

      G := UnderlyingGroup( chi );

      if not IsSubgroup( G, H ) then
        Error( "<H> must be a subgroup of <G>." );
      fi;

      if HasIdElementaryCompactLieGroup( G ) and
          ( IdElementaryCompactLieGroup( G ) = [ 1, 2 ] ) and
          not IsFinite( H ) then
        if ( IdIrr( chi ) = 0 ) then
          return 1;
        else
          return 0;
        fi;
      else
        TryNextMethod( );
      fi;
    end
  );

  InstallMethod( DimensionOfFixedSet,
    "dimension of fixed set of <H>",
    [ IsCompactLieGroupCharacter, IsGroup ],
    function( chi, H )
      local G;

      G := UnderlyingGroup( chi );

      if not IsSubgroup( G, H ) then
        Error( "<H> must be a subgroup of <G>." );
      fi;

      if HasIdElementaryCompactLieGroup( G ) and
          ( IdElementaryCompactLieGroup( G ) = [ 2, 2 ] ) and
          not IsFinite( H ) then
        if ( IdIrr( chi ) = -1 ) then
          if ( IdElementaryCompactLieGroup( H ) = [ 2, 2 ] ) then
            return 0;
          elif ( IdElementaryCompactLieGroup( H ) = [ 1, 2 ] ) then
            return 1;
          fi;
        elif ( IdIrr( chi ) = 0 ) then
          return 1;
        else
          return 0;
        fi;
      else
        TryNextMethod( );
      fi;
    end
  );

  InstallOtherMethod( DimensionOfFixedSet,
    "",
    [ IsCompactLieGroupCharacter,
      IsCompactLieGroupConjugacyClassSubgroupsRep ],
    { chi, C } -> DimensionOfFixedSet( chi, Representative( C ) )
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
      CCSs := ConjugacyClassesSubgroups( G );
      l := IdIrr( chi );

      if HasIdElementaryCompactLieGroup( G ) and
          IdElementaryCompactLieGroup( G ) = [ 1, 2 ] then
        if ( l = 0 ) then
          return [ CCSs[ 0, 1 ] ];
        else
          return [ CCSs[ l, 1 ], CCSs[ 0, 1 ] ];
        fi;
      else
        TryNextMethod( );
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
      CCSs := ConjugacyClassesSubgroups( G );
      l := IdIrr( chi );

      if HasIdElementaryCompactLieGroup( G ) and
          IdElementaryCompactLieGroup( G ) = [ 2, 2 ] then
        if ( l = -1 ) then
          return [ CCSs[ 0, 1 ], CCSs[ 0, 2 ] ];
        elif ( l = 0 ) then
          return [ CCSs[ 0, 2 ] ];
        else
          return [ CCSs[ l, 1 ], CCSs[ l, 2 ], CCSs[ 0, 2 ] ];
        fi;
      else
        TryNextMethod( );
      fi;
    end
  );


#############################################################################
##
#E  CompactLieGroup.gi . . . . . . . . . . . . . . . . . . . . . .  ends here
