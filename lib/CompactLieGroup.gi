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
#A  IsFinite( <CCSs> )
##
  InstallImmediateMethod( IsFinite,
    "compact Lie group admits infinite CCSs",
    IsCompactLieGroupConjugacyClassesSubgroupsRep,
    0,
    CCSs -> false
  );

#############################################################################
##
#F  CCSClasses( <CCSs>, args... )
##
  InstallGlobalFunction( CCSClasses,
    function( args... )
      local CCSs,
            count,
            term,
            m,
            ccs_classes;

      CCSs := Remove( args, 1 );

      if not IsCompactLieGroupConjugacyClassesSubgroupsRep( CCSs ) then
        Error( "The first argument should satisfy IsCompactLieGroupConjugacyClassesSubgroupsRep." );
      fi;

      ccs_classes := CCSs!.ccsClasses;
      count := 1;

      while not IsEmpty( args ) do
        term := Remove( args, 1 );
        count := count+1;

        if ( term = "nonzero_mode" ) then
          ccs_classes := Filtered( ccs_classes, cl -> not cl.is_zero_mode );
        elif ( term = "zero_mode" ) then
          ccs_classes := Filtered( ccs_classes, cl -> cl.is_zero_mode );
        elif ( term = "with_m-dim_weyl_group" ) then
          m := Remove( args, 1 );
          if not IsInt( m ) or ( m < 0 ) then
            Error( StringFormatted(
                "{}-th and {}-th arguments are invalid.", count, count+1 ) );
          fi;
          ccs_classes := Filtered( ccs_classes,
              cl -> ( cl.order_of_weyl_group[ 2 ] = m ) );
          count := count+1;
        else
          Error( StringFormatted( "{}-th argument is invalid.", count ) );
        fi;
      od;

      return ccs_classes;
    end
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
      return StringFormatted( "ConjugacyClassesSubgroups( {} )", ViewString( G ) );
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
        "<conjugacy classes of subgroups of {}>",
        DisplayString( G )
      );
    end
  );


##  Part 3: Elementary Compact Lie Group (ECLG)

#############################################################################
##
#U  NewCompactLieGroup( IsCompactLieGroup and IsMatrixGroup, <r> )
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
  InstallMethod( IdGroup,
    "synonym for IdElementaryCompactLieGroup",
    [ IsCompactLieGroup and HasIdElementaryCompactLieGroup ],
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
#U  NewCompactLieGroupConjugacyClassSubgroups(
#U      IsSpecialOrthogonalGroupOverReal and IsOrthogonalGroupOverReal, <r> )
##
  InstallMethod( NewCompactLieGroupConjugacyClassSubgroups,
    "constructor of CCS for SO(2) and O(2)",
    [ IsSpecialOrthogonalGroupOverReal and
      IsOrthogonalGroupOverReal,
      IsRecord ],
    function( filt, r )
      local G,		# the ECLG
            n,		# dimension of matrices
            fam,	# family of CCS
            cat,	# category of CCS
            rep,	# representation of CCS
            C,		# CCS
            U,		# representative of CCS
            N;		# normalizer of U in G

      G := r.ccs_class.group;
      n := DimensionOfMatrixGroup( G );

      if not filt( G ) or not ( n = 2 ) then
        TryNextMethod( );
      fi;

      if ( r.ccs_class.is_zero_mode <> ( r.ccs_id[ 2 ] = 0 ) ) then
        Error( "Invalid mode for the selected CCS class." );
      fi;

      # objectify the CCS
      fam := CollectionsFamily( FamilyObj( G ) );
      cat := CategoryCollections( IsMatrixGroup );
      rep := IsCompactLieGroupConjugacyClassSubgroupsRep;
      C := Objectify( NewType( fam, cat and rep ), rec( ) );

      # find representative subgroup and its normalizer
      if ( r.ccs_id = [ 1, 0 ] ) then
        U := SpecialOrthogonalGroupOverReal( 2 );
        N := G;
      elif ( r.ccs_id = [ 2, 0 ] ) then
        U := OrthogonalGroupOverReal( 2 );
        N := G;
      elif ( r.ccs_id[ 1 ] = 1 ) then
        U := mCyclicGroup( r.ccs_id[ 2 ] );
        N := G;
      elif ( r.ccs_id[ 1 ] = 2 ) then
        U := mDihedralGroup( r.ccs_id[ 2 ] );
        N := mDihedralGroup( 2*r.ccs_id[ 2 ] );
      fi;

      # setup attributes of U and C
      SetParentAttr( U, G );
      SetNormalizerInParent( U, N );
      SetOrderOfWeylGroup( U, r.ccs_class.order_of_weyl_group );
      SetRepresentative( C, U );
      SetActingDomain( C, G );
      SetIsZeroModeCCS( C, r.ccs_class.is_zero_mode );
      SetStabilizerOfExternalSet( C, N );
      SetOrderOfWeylGroup( C, r.ccs_class.order_of_weyl_group );
      SetIdCCS( C, r.ccs_id );

      return C;
    end
  );

#############################################################################
##
#U  NewCompactLieGroupConjugacyClassesSubgroups(
#U      IsSpecialOrthogonalGroupOverReal and IsOrthogonalGroupOverReal, <G> )
##
  InstallMethod( NewCompactLieGroupConjugacyClassesSubgroups,
    "constructor of CCSs for O(2) and SO(2)",
    [ IsSpecialOrthogonalGroupOverReal and IsOrthogonalGroupOverReal,
      IsCompactLieGroup ],
    function( filt, G )
      local n,
            fam,
            cat,
            rep,
            CCSs;

      n := DimensionOfMatrixGroup( G );

      # <G> must satisfy <filt>
      if not filt( G ) then
        Error( "<G> must satisfy <filt>." );
      fi;

      # define family, collection and representation of CCSs
      fam := CollectionsFamily( CollectionsFamily( FamilyObj( G ) ) );
      cat := CategoryCollections( CategoryCollections( IsMatrixGroup ) );
      rep := IsCompactLieGroupConjugacyClassesSubgroupsRep;

      # objectify CCSs of the group
      CCSs := Objectify( NewType( fam, cat and rep ), rec( ) );
      SetUnderlyingGroup( CCSs, G );
      SetString( CCSs,
        StringFormatted( "ConjugacyClassesSubgroups( {} )",
        String( G ) )
      );

      return CCSs;
    end
  );

#############################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
  InstallMethod( ConjugacyClassesSubgroups,
    "CCSs of SO(n)",
    [ IsSpecialOrthogonalGroupOverReal ],
    function( G )
      local n,			# dimension of matrices
            CCSs,		# CCSs
            ccs_classes;	# procedure generating CCS classes

      # objectify the CCSs object
      CCSs := NewCompactLieGroupConjugacyClassesSubgroups(
          IsSpecialOrthogonalGroupOverReal, G );

      # generate CCS classes for SO(2)
      n := DimensionOfMatrixGroup( G );
      if ( n = 2 ) then
        ccs_classes := [
          rec(
            group := G,
            is_zero_mode := true,
            note := "SO(2)",
            order_of_weyl_group := [ 1, 0 ]
          ),
          rec(
            group := G,
            is_zero_mode := false,
            note := "Z_n",
            order_of_weyl_group := [ 1, 1 ]
          )
        ];
        CCSs!.ccsClasses := ccs_classes;
      fi;

      return CCSs;
    end
  );

#############################################################################
##
#O  \[\]( <CCSs>, <j>, <l> )
##
  InstallOtherMethod( \[\],
    "CCS selector for SO(2) and O(2)",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep, IsInt, IsInt ],
    function( CCSs, j, l )
      local G,
            cat,
            ccs_class;

      G := UnderlyingGroup( CCSs );
      cat := EvalString( First( Reversed( CategoriesOfObject( G ) ), IsString ) );

      if ( l = 0 ) then
        ccs_class := CCSClasses( CCSs, "zero_mode" )[ j ];
      else
        ccs_class := CCSClasses( CCSs, "nonzero_mode" )[ j ];
      fi;

      return NewCompactLieGroupConjugacyClassSubgroups(
        cat,
        rec( ccs_class := ccs_class,
             ccs_id := [ j, l ] )
      );
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
      local n,			# dimension of matrices
            CCSs,		# CCSs
            ccs_classes;	# procedure generating CCS classes

      # objectify the CCSs object
      CCSs := NewCompactLieGroupConjugacyClassesSubgroups(
          IsOrthogonalGroupOverReal, G );

      # generate CCS classes for O(2)
      n := DimensionOfMatrixGroup( G );
      if ( n = 2 ) then
        ccs_classes := [
          rec(
            group := G,
            is_zero_mode := true,
            note := "SO(2)",
            order_of_weyl_group := [ 2, 0 ]
          ),
          rec(
            group := G,
            is_zero_mode := true,
            note := "O(2)",
            order_of_weyl_group := [ 1, 0 ],
          ),
          rec(
            group := G,
            is_zero_mode := false,
            note := "Z_n",
            order_of_weyl_group := [ 2, 1 ]
          ),
          rec(
            group := G,
            is_zero_mode := false,
            note := "D_n",
            order_of_weyl_group := [ 2, 0 ],
          )
        ];
        CCSs!.ccsClasses := ccs_classes;
      fi;

      return CCSs;
    end
  );

#############################################################################
##
#O  CCSId( <CCSs>, <ccs_id> )
##
# InstallMethod( CCSId,
#   "return CCS in CCSs object of a compact Lie group",
#   [ IsCompactLieGroupCCSsRep, IsList ],
#   function( CCSs, ccs_id )
#     local G,
#           cat,
#           ccs_class;

#     G := UnderlyingGroup( CCSs );

#     if ( ccs_id[ 2 ] = 0 ) then
#       ccs_class := CCSClasses( CCSs, "zero_mode" )[ ccs_id[ 1 ] ];
#     elif IsPosInt( ccs_id[ 2 ] ) then
#       ccs_class := CCSClasses( CCSs, "nonzero_mode" )[ ccs_id[ 1 ] ];
#     fi;

#     # extract representation of the given CCSs
#     if IsSpecialOrthogonalGroupOverReal( G ) then
#       cat := IsSpecialOrthogonalGroupOverReal;
#     elif IsOrthogonalGroupOverReal( G ) then
#       cat := IsOrthogonalGroupOverReal;
#     fi;

#     return NewConjugacyClassSubgroups( cat, rec( ccs_class := ccs_class, ccs_id := ccs_id ) );
#   end
# );

#############################################################################
##
#O  nLHnumber( <CL>, <CH> )
##
  InstallMethod( nLHnumber,
    "return n(L,H) number for CCSs of ECLG",
    IsIdenticalObj,
    [ IsCompactLieGroupConjugacyClassSubgroupsRep, IsCompactLieGroupConjugacyClassSubgroupsRep ],
    function( CL, CH )
      local G,		# underlying group of ccs1 and ccs2
            L, H,	# representatives
            k;		# the reflection

      G := ActingDomain( CL );
      if not ( G = ActingDomain( CH ) ) then
        Error( "CL and CH must be from the same ECLG." );
      fi;

      if not ( IdElementaryCompactLieGroup( G ) in [ [ 1, 2 ], [ 2, 2 ] ] ) then
        Info( InfoEquiDeg, INFO_LEVEL_EquiDeg,
            "The underlying group of the CCSs is not supported." );
        TryNextMethod( );
      fi;

      L := Representative( CL );
      H := Representative( CH );

      k := [ [ 1, 0 ], [ 0, -1 ] ];
      if IsSubset( H, L ) then
        if IsZeroModeCCS( CH ) then
          return [ 1, 0 ];
        elif ( k in H ) and not ( k in L ) then
          return [ 1, 1 ];
        else
          return [ 1, 0 ];
        fi;
      else
        return 0;
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

      fam := CollectionsFamily( CollectionsFamily ( CyclotomicsFamily ) );
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
#U  NewCompactLieGroupClassFunction( IsCompactLieGroupClassFunction, <G> )
##
  InstallMethod( NewCompactLieGroupClassFunction,
    "constructs class function of a compact Lie group",
    [ IsCompactLieGroupClassFunction, IsCompactLieGroup ],
    function( filt, G )
      local tbl,
            tr,
            fam,
            rep,
            phi;

      tbl := CharacterTable( G );

      fam := GeneralMappingsFamily(
        ElementsFamily( FamilyObj( G ) ),
        CyclotomicsFamily
      );
      rep := IsComponentObjectRep and IsAttributeStoringRep;

      phi := Objectify( NewType( fam, filt and rep ), rec( ) );
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
#O  \[\]( <irrs>, <l> )
##
  InstallOtherMethod( \[\],
    "returns an irreducible representation of the irr list",
    [ IsCompactLieGroupIrrCollection, IsInt ],
    function( irrs, l )
      local G,
            tr,
            chi;

      G := UnderlyingGroup( irrs );

      if not IsOrthogonalGroupOverReal( G ) or
          not ( DimensionOfMatrixGroup( G ) = 2 ) then
        TryNextMethod( );
      fi;

      if ( l = -1 ) then
        tr := MappingByFunction( G, Cyclotomics, g -> DeterminantMat( g ) );
      elif ( l = 0 ) then
        tr := MappingByFunction( G, Cyclotomics, g -> 1 );
      elif ( l = 1 ) then
        tr := MappingByFunction( G, Cyclotomics, g -> TraceMat( g ) );
      elif ( l > 0 ) then
        tr := MappingByFunction( G, Cyclotomics,
            g -> ( 1 + DeterminantMat( g ) )/2 * TraceMat( g^l ) );
      else
        Error( StringFormatted( "{} admits no such irreducible representation.\n",
            ViewString( G ) ) );
      fi;
      
      chi := NewCompactLieGroupClassFunction( IsCompactLieGroupClassFunction, G );
      SetValuesOfClassFunction( chi, tr );
      SetIsCompactLieGroupCharacter( chi, true );
      SetIsGeneratorsOfSemigroup( chi, true );
      SetModeOfIrr( chi, l );

      return chi;
    end
  );

#############################################################################
##
#A  UnderlyingGroup( <cf> )
##
  InstallOtherMethod( UnderlyingGroup,
    "underlying group of a class function of a compact Lie group",
    [ IsCompactLieGroupClassFunction ],
    cf -> UnderlyingGroup( UnderlyingCharacterTable( cf ) )
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
            phi,
            fchi,
            fpsi;

      G := UnderlyingGroup( chi );
      fchi := ValuesOfClassFunction( chi );
      fpsi := ValuesOfClassFunction( psi );

      phi := NewCompactLieGroupClassFunction(
         IsCompactLieGroupClassFunction, G );
      SetValuesOfClassFunction( phi, fchi + fpsi );
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
            phi,
            fchi;

      G := UnderlyingGroup( chi );
      fchi := ValuesOfClassFunction( chi );

      phi := NewCompactLieGroupClassFunction(
         IsCompactLieGroupClassFunction, G );
      SetValuesOfClassFunction( phi, -fchi );
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
            phi,
            fchi,
            fpsi;

      G := UnderlyingGroup( chi );
      fchi := ValuesOfClassFunction( chi );
      fpsi := ValuesOfClassFunction( psi );

      phi := NewCompactLieGroupClassFunction(
         IsCompactLieGroupClassFunction, G );
      SetValuesOfClassFunction( phi, fchi * fpsi );
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
#O  ViewString( <cf> )
##
  InstallMethod( ViewString,
    "view string of a class function of a compact Lie group",
    [ IsCompactLieGroupClassFunction ],
    cf -> String( cf )
  );

#############################################################################
##
#E  CompactLieGroup.gi . . . . . . . . . . . . . . . . . . . . . .  ends here
