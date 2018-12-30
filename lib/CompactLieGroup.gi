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

##  Part 1: Compact Lie Group

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
#U  NewCCS( IsCompactLieGroupCCSRep, <r> )
##
  InstallMethod( NewCCS,
    "CCS constructor of SO(2) or O(2)",
    [ IsElementaryCompactLieGroupRep, IsRecord ],
    function( filt, r )
      local id,
            C,
            U,
            fam,
            cat;

      id := IdECLG( r.ccs_class.group );

      if not ( id in [ [ 1, 2 ], [ 2, 2 ] ] ) then
        TryNextMethod( );
      fi;

      if ( r.ccs_class.is_zero_mode <> ( r.mode = 0 ) ) then
        Error( "Invalid mode for the selected CCS class." );
      fi;

      # objectify the CCS
      fam := CollectionsFamily( FamilyObj( r.ccs_class.group ) );
      cat := CategoryCollections( IsMatrixGroup );
      C := Objectify( NewType( fam, cat and filt ), rec( ) );

      # find representative subgroup and its normalizer
      if ( r.ccs_class.id = [ 1, 0 ] ) then
        U := ECLGId( [ 1, 2 ] );
        SetNormalizerInParent( U, r.group );
        if ( id[ 1 ] = 1 ) then
          SetOrderOfWeylGroup( U, [ 1, 0 ] );
        elif ( id[ 1 ] = 2 ) then
          SetOrderOfWeylGroup( U, [ 2, 0 ] );
        fi;
      elif ( r.ccs_class.id = [ 2, 0 ] ) then
        U := ECLGId( [ 2, 2 ] );
        SetNormalizerInParent( U, r.group );
        SetOrderOfWeylGroup( U, [ 1, 0 ] );
      elif ( r.ccs_class.id = [ 1, 1 ] ) then
        U := mCyclicGroup( r.mode );
        SetNormalizerInParent( U, r.group );
        if ( id[ 1 ] = 1 ) then
          SetOrderOfWeylGroup( U, [ 1, 1 ] );
        elif ( id[ 1 ] = 2 ) then
          SetOrderOfWeylGroup( U, [ 2, 1 ] );
        fi;
      elif ( r.ccs_class.id = [ 2, 1 ] ) then
        U := mDihedralGroup( r.mode );
      fi;

      # setup attributes of U and C
      SetParentAttr( U, r.group );
      SetOrderOfWeylGroup( U, r.ccs_class.order_of_weyl_group );
      SetIsZeroModeCCS( C, r.ccs_class.is_zero_mode );
      SetActingDomain( C, r.group );
      SetOrderOfWeylGroup( C, r.ccs_class.order_of_weyl_group );
      SetRepresentative( C, U );

      return C;
    end
  );

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
#A  CCSId( <CCSs> )
##
# InstallMethod( CCSId,
#   "return CCSId attribute of a compact Lie group CCS list",
#   [ IsCompactLieGroupCCSsRep ],
#   ccss -> function( id )
#     local rep_ccss,
#           ccs_class,
#           ccs_classes_filtered,
#           ccs;

#     ccs_classes_filtered := CCSClassesFiltered( ccss );

#     if ( id[ 2 ] = 0 ) then
#       ccs_class := ccs_classes_filtered( "zero_mode" )[ id[ 1 ] ];
#     elif IsPosInt( id[ 2 ] ) then
#       ccs_class := ccs_classes_filtered( "nonzero_mode" )[ id[ 1 ] ];
#     else
#       return fail;
#     fi;

#     # extract representation of the given CCSs
#     rep_ccss := EvalString( Remove( ShallowCopy( RepresentationsOfObject( ccss ) ) ) );

#     ccs := NewCCS( rep_ccss, ccs_class, id[ 2 ] );
#     SetIdCCS( ccs, id );

#     return ccs;
#   end
# );

#############################################################################
##
#O  \=( <eclg1>, <eclg2> )
##
# InstallMethod( \=,
#   "equivalence relation of ECLGs",
#   [ IsElementaryCompactLieGroup, IsElementaryCompactLieGroup ],
#   function( eclg1, eclg2 )
#     return IdECLG( eclg1 ) = IdECLG( eclg2 );
#   end
# );

#############################################################################
##
#O  \in( <obj>, SO(n) )
##
# InstallMethod( \in,
#   "Membership test for SO(n)",
#   [ IsObject, IsElementaryCompactLieGroup and IsMatrixGroup ],
#   function( obj, eclg )
#     local d;

#     d := DimensionOfMatrixGroup( eclg );
#     if not ( eclg = SpecialOrthogonalGroupOverReal( d ) ) then
#       TryNextMethod( );
#     fi;

#     if IsIdenticalObj( CollectionsFamily( FamilyObj( obj ) ),
#         FamilyObj( eclg ) ) and ( TransposedMat( obj ) * obj
#         = One( eclg ) ) and ( Determinant( obj ) = 1 ) then
#       return true;
#     else
#       return false;
#     fi;
#   end
# );

#############################################################################
##
#O  \in( <obj>, O(n) )
##
# InstallMethod( \in,
#   "Membership test for O(n)",
#   [ IsObject, IsElementaryCompactLieGroup and IsMatrixGroup ],
#   function( obj, eclg )
#     local d;

#     d := DimensionOfMatrixGroup( eclg );
#     if not ( eclg = OrthogonalGroupOverReal( d ) ) then
#       TryNextMethod( );
#     fi;

#     if IsIdenticalObj( CollectionsFamily( FamilyObj( obj ) ),
#         FamilyObj( eclg ) ) and ( TransposedMat( obj ) * obj
#         = One( eclg ) ) then
#       return true;
#     else
#       return false;
#     fi;
#   end
# );

#############################################################################
##
#O  IsSubset( <eclg>, <grp> )
##
# InstallMethod( IsSubset,
#   "Test if a finite group is a subgroup of a ECLG",
#   [ IsElementaryCompactLieGroup, IsGroup ],
#   function( eclg, grp )
#     local elmt;

#     if not IsFinite( grp ) then
#       TryNextMethod( );
#     fi;

#     for elmt in List( grp ) do
#       if not ( elmt in eclg ) then
#         return false;
#       fi;
#     od;

#     return true;
#   end
# );

#############################################################################
##
#O  IsSubset( <grp>, <eclg> )
##
# InstallMethod( IsSubset,
#   "Test if an ECLG is a subgroup of a finite group",
#   [ IsGroup, IsElementaryCompactLieGroup ],
#   function( grp, eclg )
#     if IsFinite( grp ) then
#       return false;
#     else
#       TryNextMethod( );
#     fi;
#   end
# );

#############################################################################
##
#O  IsSubset( <eclg>, <eclg> )
##
# InstallMethod( IsSubset,
#   "Test if an ECLG is a subset of another ECLG",
#   [ IsElementaryCompactLieGroup, IsElementaryCompactLieGroup ],
#   function( eclg1, eclg2 )
#     # one should change the rule when adding more ECLGs into the library
#     return IsZero( IdECLG( eclg1 ) mod IdECLG( eclg2 ) );
#   end
# );

#############################################################################
##
#O  \=( <ccs1_eclg>, <ccs2_eclg> )
##
# InstallMethod( \=,
#   "the equivalence relation of CCSs of ECLG",
#   IsIdenticalObj,
#   [ IsCompactLieGroupCCSRep, IsCompactLieGroupCCSRep ],
#   function( ccs1, ccs2 )
#     return ( ActingDomain( ccs1 ) = ActingDomain( ccs2 ) ) and
#     ( Representative( ccs1 ) = Representative( ccs2 ) );
#   end
# );

#############################################################################
##
#O  nLHnumber( <ccs1_eclg>, <ccs2_eclg> )
##
# InstallMethod( nLHnumber,
#   "return n(L,H) number for CCSs of ECLG",
#   IsIdenticalObj,
#   [ IsElementaryCompactLieGroupCCSRep, IsElementaryCompactLieGroupCCSRep ],
#   function( ccs1, ccs2 )
#     local eclg,           # underlying group of ccs1 and ccs2
#           workable_clg,   # workable group list
#           is_supported,   # flag indicating whether the underlying group
#                           # is supported
#           subg1, subg2,   # representatives
#           k;              # the reflection

#     eclg := ActingDomain( ccs1 );
#     if not ( eclg = ActingDomain( ccs2 ) ) then
#       Error( "ccs1 and ccs2 must be from the same ECLG." );
#     fi;

#     is_supported := false;
#     if not ( IdECLG( eclg ) in [ [ 1, 1 ], [ 2, 1 ] ] ) then
#       Info( InfoEquiDeg, INFO_LEVEL_EquiDeg, "The underlying group of the CCSs is not supported." );
#       return fail;
#     fi;

#     subg1 := Representative( ccs1 );
#     subg2 := Representative( ccs2 );

#     if IsSubset( subg2, subg1 ) then
#       k := [ [ 1, 0 ], [ 0, -1 ] ];
#       if ( k in subg2 ) and not ( k in subg1 ) then
#         return infinity;
#       else
#         return 1;
#       fi;
#     else
#       return 0;
#     fi;
#   end
# );

#############################################################################
##
#O  \<( <ccs1_clg>, <ccs2_clg> )
##
# InstallMethod( \<,
#   "the partial order oe the conjugacy classes of subgroups of a compact Lie group",
#   IsIdenticalObj,
#   [ IsCompactLieGroupCCSRep, IsCompactLieGroupCCSRep ],
#   function( ccs1, ccs2 )
#     return ( nLHnumber( ccs1, ccs2 ) > 0 );
#   end
# );

#############################################################################
##
#O  PrintObj( <eclg> )
##
  InstallMethod( PrintObj,
    "print ECLG",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    10,
    function( eclg )
      Print( String( eclg ) );
    end
  );

#############################################################################
##
#A  ViewString( <eclg> )
##
  InstallMethod( ViewString,
    "view string of ECLG",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( eclg )
      local type,
            n,
            string;

      type := IdECLG( eclg )[ 1 ];
      n := IdECLG( eclg )[ 2 ];

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
#O  ViewObj( <eclg> )
##
  InstallMethod( ViewObj,
    "view ECLG",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    10,
    function( eclg )
      Print( ViewString( eclg ) );
    end
  );

#############################################################################
##
#A  DisplayString( <eclg> )
##
  InstallMethod( DisplayString,
    "display string of ECLG",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    function( eclg )
      local type,
            n,
            string;

      type := IdECLG( eclg )[ 1 ];
      n := IdECLG( eclg )[ 2 ];

      if ( type = 1 ) then
        string := StringFormatted( "<group of {1}x{1} special orthogonal matrices over R>", n );
      elif ( type = 2 ) then
        string := StringFormatted( "<group of {1}x{1} orthogonal matrices over R>", n );
      fi;

      return string;
    end
  );

#############################################################################
##
#O  Display( <eclg> )
##
  InstallMethod( Display,
    "display ECLG",
    [ IsCompactLieGroup and IsElementaryCompactLieGroupRep ],
    10,
    function( eclg )
      Print( DisplayString( eclg ) );
    end
  );

#############################################################################
##
#A  PrintString( <ccss_clg> )
##
# InstallMethod( PrintString,
#   "print string of CCS list of clg",
#   [ IsCollection and IsCompactLieGroupCCSsRep ],
#   function( ccss )
#     local clg;

#     clg := UnderlyingGroup( ccss );
#     return Concatenation( "ConjugacyClassesSubgroups( ", String( clg ), " )" );
#   end
# );

#############################################################################
##
#O  PrintObj( <ccss_cclg> )
##
# InstallMethod( PrintObj,
#   "print CCS list of compact Lie group",
#   [ IsCollection and IsCompactLieGroupCCSsRep ],
#   function( ccss )
#     Print( PrintString( ccss ) );
#   end
# );

#############################################################################
##
#A  ViewString( <ccss_clg> )
##
# InstallMethod( ViewString,
#   "view string of CCS list of CLG",
#   [ IsCollection and IsCompactLieGroupCCSsRep ],
#   function( ccss )
#     local clg;

#     clg := UnderlyingGroup( ccss );
#     return Concatenation( "CCSs( ", ViewString( clg ), " )" );
#   end
# );

#############################################################################
##
#A  ViewObj( <ccss_clg> )
##
# InstallMethod( ViewObj,
#   "view CCS list of compact Lie group",
#   [ IsCollection and IsCompactLieGroupCCSsRep ],
#   function( ccss )
#     Print( ViewString( ccss ) );
#   end
# );


#############################################################################
##
#E  CompactLieGroup.gi . . . . . . . . . . . . . . . . . . . . . .  ends here
