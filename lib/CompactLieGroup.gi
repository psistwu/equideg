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


##  Part 2: Elementary Compact Lie Group (ECLG)

#############################################################################
##
#U  NewElementaryCompactLieGroup( IsCompactLieGroup and
#U      IsMatrixGroup and IsElementaryCompactLieGroupRep, <r> )
##
  InstallMethod( NewElementaryCompactLieGroup,
    "constructor of a matrix-ECLG",
    [ IsCompactLieGroup and
      IsMatrixGroup and
      IsElementaryCompactLieGroupRep,
      IsRecord ],
    function( filt, r )
      local one,	# identity of the ECLG
            fam,	# family of the ECLG
            G;		# elementary compact Lie group

      # generate the identity of the ECLG (a d-by-d identity matrix)
      one := IdentityMat( r.dimensionMat );

      # define the family of the group
      fam := CollectionsFamily( FamilyObj( one ) );

      # objectify the (special) orthogonal group
      G := Objectify( NewType( fam, filt ), rec( ) );

      # setup properties of the (special) orthogonal group
      SetIsFinite( G, false );
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
      local cat,
            rep,
            G;		# the orthogonal group

      # objectify the group
      cat := IsCompactLieGroup and IsMatrixGroup;
      rep := IsElementaryCompactLieGroupRep;
      G := NewElementaryCompactLieGroup(
        cat and rep,
        rec( dimensionMat := n )
      );

      # setup property(s) and attribute(s) of the group
      SetIsAbelian( G, false );
      SetDimension( G, n*(n-1)/2 );
      SetIdECLG( G, [ 2, n ] );
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
      local cat,
            rep,
            G;		# the special orthogonal group

      # objectify the group
      cat := IsCompactLieGroup and IsMatrixGroup;
      rep := IsElementaryCompactLieGroupRep;
      G := NewElementaryCompactLieGroup(
        cat and rep,
        rec( dimensionMat := n )
      );

      # setup property(s) and attribute(s) of the group
      SetIsAbelian( G, true );
      SetDimension( G, n*(n-1)/2 );
      SetIdECLG( G, [ 1, n ] );
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
#F  ECLGId( <id...> )
##
  InstallGlobalFunction( ECLGId,
    function( id... )
      local G;		# the elementary compact Lie group
 
      if IsList( id[ 1 ] ) then
        id := id[ 1 ];
      fi;

      if ( id[ 1 ] = 1 ) then
        G := SpecialOrthogonalGroupOverReal( id[ 2 ] );
      elif ( id[ 1 ] = 2 ) then
        G := OrthogonalGroupOverReal( id[ 2 ] );
      else
        Info( InfoEquiDeg, INFO_LEVEL_EquiDeg, "Invalid ID." );
        return fail;
      fi;

      return G;
    end
  );

#############################################################################
##
#O  \=( <G>, <H> )
##
  InstallMethod( \=,
    "equivalence relation of ECLGs",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep,
      IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( G, H )
      return IdECLG( G ) = IdECLG( H );
    end
  );

#############################################################################
##
#O  \in( <obj>, SO(n) )
##
  InstallMethod( \in,
    "Membership test for SO(n)",
    [ IsObject, IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( obj, G )
      local id;

      id := IdECLG( G );

      if not ( id[ 1 ] = 1 ) then
        TryNextMethod( );
      fi;

      if IsIdenticalObj(
          FamilyObj( obj ), ElementsFamily( FamilyObj( G ) ) ) and
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
    [ IsObject, IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( obj, G )
      local id;

      id := IdECLG( G );

      if not ( id[ 1 ] = 2 ) then
        TryNextMethod( );
      fi;

      if IsIdenticalObj(
          FamilyObj( obj ), ElementsFamily( FamilyObj( G ) ) ) and
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
    "Test if a finite group is a subgroup of a ECLG",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep, IsCollection ],
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
    [ IsCollection, IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
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
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep,
      IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( G, U )
      local idG,
            idU;

      idG := IdECLG( G );
      idU := IdECLG( U );

      # one should change the rule when adding more ECLGs into the library
      if ( idG = idU ) then
        return true;
      elif ( idG[ 1 ] = 2 ) and ( idU[ 1 ] = 1 ) and
          ( idG[ 2 ] = idU[ 2 ] ) then
        return true;
      else
        return false;
      fi;
    end
  );

#############################################################################
##
#O  ViewString( <G> )
##
  InstallMethod( ViewString,
    "view string of ECLG",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( G )
      local type,
            n,
            string;

      type := IdECLG( G )[ 1 ];
      n := IdECLG( G )[ 2 ];

      if ( type = 1 ) then
        string := StringFormatted( "SO({},R)", n );
      elif ( type = 2 ) then
        string := StringFormatted( "O({},R)", n );
      fi;

      return string;
    end
  );

#############################################################################
##
#O  DisplayString( <G> )
##
  InstallMethod( DisplayString,
    "display string of a elementary compact Lie group",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( G )
      local type,
            n,
            str;

      type := IdECLG( G )[ 1 ];
      n := IdECLG( G )[ 2 ];

      if ( type = 1 ) then
        str := StringFormatted(
            "<group of {1}x{1} special orthogonal matrices over R>", n );
      elif ( type = 2 ) then
        str := StringFormatted(
            "<group of {1}x{1} orthogonal matrices over R>", n );
      fi;

      return str;
    end
  );


##  Part 3: Conjugacy Classes of Subgroups of ECLG

#############################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
  InstallMethod( ConjugacyClassesSubgroups,
    "CCSs of O(2) and SO(2)",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( G )
      local id,			# id of G
            fam,		# family of CCSs
            cat,		# category of CCSs
            rep,		# representation of CCSs
            CCSs,		# CCSs
            ccs_classes;	# procedure generating CCS classes

      id := IdECLG( G );

      # it works only for SO(2) and O(2)
      if not ( id in [ [ 1, 2 ], [ 2, 2 ] ] ) then
        TryNextMethod( );
      fi;

      # define families and collections
      fam := CollectionsFamily( CollectionsFamily( FamilyObj( G ) ) );
      cat := CategoryCollections( CategoryCollections( IsMatrixGroup ) );
      rep := IsCompactLieGroupCCSsRep;

      # objectify CCSs of the group
      CCSs := Objectify( NewType( fam, cat and rep ), rec( ) );
      SetUnderlyingGroup( CCSs, G );
      SetIsFinite( CCSs, false );
      SetString( CCSs,
        StringFormatted( "ConjugacyClassesSubgroups( {} )",
        String( G ) )
      );

      # generate CCS classes
      if ( id = [ 1, 2 ] ) then
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
      elif ( id = [ 2, 2] ) then
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
      fi;
      CCSs!.ccsClasses := ccs_classes;

      return CCSs;
    end
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

      if not IsCompactLieGroupCCSsRep( CCSs ) then
        Error( "The first argement should be IsCompactLieGroupCCSsRep." );
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
#U  NewCCS( IsElementaryCompactLieGroupCCSRep, <r> )
##
  InstallMethod( NewCCS,
    "CCS constructor of SO(2) or O(2)",
    [ IsElementaryCompactLieGroupCCSRep, IsRecord ],
    function( filt, r )
      local G,		# the ECLG
            id,		# id of ECLG
            fam,	# family of CCS
            cat,	# category of CCS
            C,		# CCS
            U,		# representative of CCS
            N;		# normalizer of U in G

      G := r.ccs_class.group;
      id := IdECLG( G );

      if not ( id in [ [ 1, 2 ], [ 2, 2 ] ] ) then
        TryNextMethod( );
      fi;

      if ( r.ccs_class.is_zero_mode <> ( r.ccs_id[ 2 ] = 0 ) ) then
        Error( "Invalid mode for the selected CCS class." );
      fi;

      # objectify the CCS
      fam := CollectionsFamily( FamilyObj( G ) );
      cat := CategoryCollections( IsMatrixGroup );
      C := Objectify( NewType( fam, cat and filt ), rec( ) );

      # find representative subgroup and its normalizer
      if ( r.ccs_id = [ 1, 0 ] ) then
        U := ECLGId( [ 1, 2 ] );
        N := G;
      elif ( r.ccs_id = [ 2, 0 ] ) then
        U := ECLGId( [ 2, 2 ] );
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
#O  CCSId( <CCSs>, <ccs_id> )
##
  InstallMethod( CCSId,
    "return CCS in CCSs object of a compact Lie group",
    [ IsCompactLieGroupCCSsRep, IsList ],
    function( CCSs, ccs_id )
      local G,
            rep,
            ccs_class;

      G := UnderlyingGroup( CCSs );

      if ( ccs_id[ 2 ] = 0 ) then
        ccs_class := CCSClasses( CCSs, "zero_mode" )[ ccs_id[ 1 ] ];
      elif IsPosInt( ccs_id[ 2 ] ) then
        ccs_class := CCSClasses( CCSs, "nonzero_mode" )[ ccs_id[ 1 ] ];
      fi;

      # extract representation of the given CCSs
      if IsElementaryCompactLieGroupRep( G ) then
        rep := IsElementaryCompactLieGroupCCSRep;
      else
        rep := IsCompactLieGroupCCSRep;
      fi;

      return NewCCS( rep, rec( ccs_class := ccs_class, ccs_id := ccs_id ) );
    end
  );

#############################################################################
##
#O  nLHnumber( <CL>, <CH> )
##
  InstallMethod( nLHnumber,
    "return n(L,H) number for CCSs of ECLG",
    IsIdenticalObj,
    [ IsElementaryCompactLieGroupCCSRep, IsElementaryCompactLieGroupCCSRep ],
    function( CL, CH )
      local G,		# underlying group of ccs1 and ccs2
            L, H,	# representatives
            k;		# the reflection

      G := ActingDomain( CL );
      if not ( G = ActingDomain( CH ) ) then
        Error( "CL and CH must be from the same ECLG." );
      fi;

      if not ( IdECLG( G ) in [ [ 1, 2 ], [ 2, 2 ] ] ) then
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

#############################################################################
##
#O  ViewString( <CCSs> )
##
  InstallMethod( ViewString,
    "view string of CCS list of CLG",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( CCSs )
      local G;

      G := UnderlyingGroup( CCSs );
      return StringFormatted( "CCSs( {} )", ViewString( G ) );
    end
  );

#############################################################################
##
#A  DisplayString( <CCSs> )
##
  InstallMethod( DisplayString,
    "Display CCSs of CLG",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
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


##  Part 4: Character Theory for ECLG
##  ??????


#############################################################################
##
#E  CompactLieGroup.gi . . . . . . . . . . . . . . . . . . . . . .  ends here
