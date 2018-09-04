# # GAP: Compact Lie Group Library
#
# Implementation file of libCompactLieGroup.g
#
# Author:
# Haopin Wu <psistwu@outlook.com>
#


# ### constructor(s)
# ***
  InstallMethod( NewCompactLieGroup,
    "return a compact lie group",
    [ IsGroup and IsOrthogonalGroupOverRealRep and IsSpecialOrthogonalGroupOverRealRep, IsPosInt ],
    function( filt, d )
      local one,                # identity of (special) orthogonal group
            fam,                # family of element
            collfam,            # family of (sub)group
            grp,                # (special) orthogonal group
            i, j, k;            # indices

      # the d-by-d identity matrix
      # which is the identity of the (special) orthoganal group
      one := One( List( [ 1 .. d ], i -> List( [ 1 .. d ], j -> 0 ) ) );

      # define families
      # family of element
      fam := FamilyObj( one );
      # family of (sub)group
      collfam := CollectionsFamily( fam );

      # objectify the (special) orthogonal group
      grp := Objectify( NewType( collfam, filt ), rec() );

      # setup properties of the (special) orthogonal group
      # identity
      SetOneImmutable( grp, one );
      # dimension of the (special) orthogonal group
      SetDimension( grp, d*(d-1)/2 );
      # dimension of matrices in the (special) orthogonal group
      SetDimensionOfMatrixGroup( grp, d );
      # order of the (special) orthogonal group
      SetOrder( grp, infinity );

      return grp;
    end
  );

# ***
  InstallMethod( OrthogonalGroupOverReal,
    "generate an orthogonal group over real numbers",
    [ IsPosInt ],
    d -> NewCompactLieGroup( IsGroup and IsOrthogonalGroupOverRealRep, d )
  );

# ***
  InstallMethod( SpecialOrthogonalGroupOverReal,
    "generate a special orthogonal group over real numbers",
    [ IsPosInt ],
    d -> NewCompactLieGroup( IsGroup and IsSpecialOrthogonalGroupOverRealRep, d )
  );


# ### attribute(s)
# ***
  InstallMethod( ConjugacyClassesSubgroups,
    "CCS list of O(n)",
    [ IsGroup and IsOrthogonalGroupOverRealRep ],
    function( grp )
      local d,                  # dimension of matrices in the Lie group
            fam,                # family of (sub)group
            collfam,            # family of CCS
            collcollfam,        # family of CCS list
            cat,                # category of sub(group)
            collcat,            # category of CCS
            collcollcat,        # category of CCS list
            ccs_list;           # list of CCS

      d := DimensionOfMatrixGroup( grp );
      fam := FamilyObj( grp );
      collfam := CollectionsFamily( fam );
      collcollfam := CollectionsFamily( collfam );

      cat := IsGroup;
      collcat := CategoryCollections( cat );
      collcollcat := CategoryCollections( collcat );

      ccs_list := Objectify( NewType( collcollfam, IsCompactLieGroupCCSsRep and collcollcat ), rec( Group := grp ) );

      if ( d = 2 ) then
        SetEnumerator( ccs_list, EnumeratorByFunctions( collfam, rec(
          ElementNumber := function( e, n )
            local ccs,                # ccs in ccs_list
                  subg,               # representative of ccs
                  normalizer,         # normalizer of subg
                  k;                  # Fourier mode

            ccs := Objectify( NewType( collfam, IsCompactLieGroupCCSRep and collcat ), rec( ) );
            if ( n = 1 ) then
              subg := SpecialOrthogonalGroupOverReal( 2 );

              # setup the normalizer of subg
              normalizer := grp;
            elif ( n = 2 ) then
              subg := OrthogonalGroupOverReal( 2 );

              # setup the normalizer of subg
              normalizer := grp;
            elif IsOddInt( n ) then
              k := (n-1)/2;
              subg := mCyclicGroup( k );

              # setup the normalizer of subg
              normalizer := grp;
            elif IsEvenInt( n ) then
              k := (n-2)/2;
              subg := mDihedralGroup( k );

              # setup the normalizer of subg
              normalizer := mDihedralGroup( 2*k );
            fi;

            SetParentAttr( subg, grp );
            SetRepresentative( ccs, subg );
            SetActingDomain( ccs, grp );
            SetStabilizerOfExternalSet( ccs, normalizer );

            return ccs;
          end,

          NumberElement := function( e, ccs )
            local subg,
                  ord;

            # check family
            if not IsIdenticalObj( FamilyObj( ccs ), collfam ) then
              return fail;
            fi;

            # check category and representation
            if not ( IsConjugacyClassSubgroupsRep and collcat )( ccs ) then
              return fail;
            fi;

            # check if the given CCS is indeed a CCS of grp
            if not IsIdenticalObj( ActingDomain( ccs ), grp ) then
              return fail;
            fi;

            subg := Representative( ccs );
            ord := Order( subg );

            if ( ord = infinity ) then
              if ( Representative( ccs ) = SpecialOrthogonalGroupOverReal( 2 ) ) then
                return 1;
              elif ( Representative( ccs ) = OrthogonalGroupOverReal( 2 ) ) then
                return 2;
              fi;
            elif ( subg = mCyclicGroup( ord ) ) then
              return 2*ord+1;
            elif ( subg = mDihedralGroup( ord/2 ) ) then
              return ord+2;
            else
              return fail;
            fi;
          end,

          Length := e -> infinity
        ) ) );
      fi;

      return ccs_list;
    end
  );

# ***
  InstallMethod( ConjugacyClassesSubgroups,
    "CCS list of SO(n)",
    [ IsGroup and IsSpecialOrthogonalGroupOverRealRep ],
    function( grp )
      local d,                  # dimension of matrices in the Lie group
            fam,                # family of (sub)group
            collfam,            # family of CCS
            collcollfam,        # family of CCS list
            cat,                # category of sub(group)
            collcat,            # category of CCS
            collcollcat,        # category of CCS list
            ccs_list;           # list of CCS

      d := DimensionOfMatrixGroup( grp );
      fam := FamilyObj( grp );
      collfam := CollectionsFamily( fam );
      collcollfam := CollectionsFamily( collfam );

      cat := IsGroup;
      collcat := CategoryCollections( cat );
      collcollcat := CategoryCollections( collcat );

      ccs_list := Objectify( NewType( collcollfam, IsCompactLieGroupCCSsRep and collcollcat ), rec( Group := grp ) );

      if ( d = 2 ) then
        SetEnumerator( ccs_list, EnumeratorByFunctions( collfam, rec(
          ElementNumber := function( e, n )
            local ccs,                # ccs in ccs_list
                  subg,               # representative of ccs
                  normalizer,         # normalizer of subg
                  k;                  # Fourier mode

            ccs := Objectify( NewType( collfam, IsCompactLieGroupCCSRep and collcat ), rec( ) );
            if ( n = 1 ) then
              subg := SpecialOrthogonalGroupOverReal( 2 );

              # setup the normalizer of subg
              normalizer := grp;
            else
              k := n-1;
              subg := mCyclicGroup( k );

              # setup the normalizer of subg
              normalizer := grp;
            fi;

            SetParentAttr( subg, grp );
            SetRepresentative( ccs, subg );
            SetActingDomain( ccs, grp );
            SetStabilizerOfExternalSet( ccs, normalizer );

            return ccs;
          end,

          NumberElement := function( e, ccs )
            local subg,
                  ord;

            # check family
            if not IsIdenticalObj( FamilyObj( ccs ), collfam ) then
              return fail;
            fi;

            # check category and representation
            if not ( IsConjugacyClassSubgroupsRep and collcat )( ccs ) then
              return fail;
            fi;

            # check if the given CCS is indeed a CCS of grp
            if not IsIdenticalObj( ActingDomain( ccs ), grp ) then
              return fail;
            fi;

            subg := Representative( ccs );
            ord := Order( subg );

            if ( ord = infinity ) then
              if ( Representative( ccs ) = SpecialOrthogonalGroupOverReal( 2 ) ) then
                return 1;
              fi;
            elif ( subg = mCyclicGroup( ord ) ) then
              return ord+1;
            else
              return fail;
            fi;
          end,

          Length := e -> infinity
        ) ) );
      fi;

      return ccs_list;
    end
  );


# ### binary relation(s)
# ***
  InstallMethod( \=,
    "equality of compact Lie groups",
    [ IsGroup and IsCompactLieGroupRep, IsGroup and IsCompactLieGroupRep ],
    function( grp1, grp2 )
      if ( IsOrthogonalGroupOverRealRep( grp1 ) and IsOrthogonalGroupOverRealRep( grp2 ) ) then
        return ( DimensionOfMatrixGroup( grp1 ) = DimensionOfMatrixGroup( grp2 ) );
      elif ( IsSpecialOrthogonalGroupOverRealRep( grp1 ) and IsSpecialOrthogonalGroupOverRealRep( grp2 ) ) then
        return ( DimensionOfMatrixGroup( grp1 ) = DimensionOfMatrixGroup( grp2 ) );
      else
        return false;
      fi;
    end
  );

# ***
  InstallOtherMethod( \=,
    "equality of CCSs of compact Lie groups",
    IsIdenticalObj,
    [ IsCollection and IsCompactLieGroupCCSRep, IsCollection and IsCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      return ( ActingDomain( ccs1 ) = ActingDomain( ccs2 ) ) and
          ( Representative( ccs1 ) = Representative( ccs2 ) );
    end
  );


# ### print, view and display
# ***
  InstallMethod( PrintString,
    "print string of orthogonal groups",
    [ IsGroup and IsOrthogonalGroupOverRealRep ],
    function( grp )
      local d;    # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "OrthogonalGroupOverReal(", d, ")" );
    end
  );

# ***
  InstallMethod( PrintObj,
    "print orthogonal groups",
    [ IsGroup and IsOrthogonalGroupOverRealRep ],
    10,
    function( grp )
      Print( PrintString( grp ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of orthogonal groups",
    [ IsGroup and IsOrthogonalGroupOverRealRep ],
    function( grp )
      local d;        # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "O(", d, ")" );
    end
  );

# ***
  InstallMethod( ViewObj,
    "print orthogonal groups",
    [ IsGroup and IsOrthogonalGroupOverRealRep ],
    10,
    function( grp )
      Print( ViewString( grp ) );
    end
  );

# ***
  InstallMethod( DisplayString,
    "display string of orthogonal groups",
    [ IsGroup and IsOrthogonalGroupOverRealRep ],
    function( grp )
      local d;        # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "<group of ", d, "x", d, " orthogonal matrices over real>" );
    end
  );

# ***
  InstallMethod( Display,
    "display orthogonal groups",
    [ IsGroup and IsOrthogonalGroupOverRealRep ],
    function( grp )
      Print( DisplayString( grp ) );
    end
  );

# ***
  InstallMethod( PrintString,
    "print string of special orthogonal groups",
    [ IsGroup and IsSpecialOrthogonalGroupOverRealRep ],
    function( grp )
      local d;    # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "SpecialOrthogonalGroupOverReal(", d, ")" );
    end
  );

# ***
  InstallMethod( PrintObj,
    "print special orthogonal groups",
    [ IsGroup and IsSpecialOrthogonalGroupOverRealRep ],
    10,
    function( grp )
      Print( PrintString( grp ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of special orthogonal groups",
    [ IsGroup and IsSpecialOrthogonalGroupOverRealRep ],
    function( grp )
      local d;    # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "SO(", d, ")" );
    end
  );

# ***
  InstallMethod( ViewObj,
    "view special orthogonal groups",
    [ IsGroup and IsSpecialOrthogonalGroupOverRealRep ],
    10,
    function( grp )
      Print( ViewString( grp ) );
    end
  );

# ***
  InstallMethod( DisplayString,
    "display string of orthogonal groups",
    [ IsGroup and IsSpecialOrthogonalGroupOverRealRep ],
    function( grp )
      local d;        # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "<group of ", d, "x", d, " special orthogonal matrices over real>" );
    end
  );

# ***
  InstallMethod( Display,
    "display orthogonal groups",
    [ IsGroup and IsSpecialOrthogonalGroupOverRealRep ],
    function( grp )
      Print( DisplayString( grp ) );
    end
  );

# ***
  InstallMethod( PrintString,
    "print string of CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      local grp;

      grp := ccs_list!.Group;
      return Concatenation( "ConjugacyClassesSubgroups( ", PrintString(grp), " )" );
    end
  );

# ***
  InstallMethod( PrintObj,
    "print CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      Print( PrintString( ccs_list ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      local grp;

      grp := ccs_list!.Group;
      return Concatenation( "CCSs( ", ViewString(grp), " )" );
    end
  );

# ***
  InstallMethod( ViewObj,
    "view CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      Print( ViewString( ccs_list ) );
    end
  );

