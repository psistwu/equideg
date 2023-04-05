#############################################################################
##
#W  CompactLieGroup.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2023, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
#Y  Department of Mathematical Sciences, the University of Texas at Dallas, USA
##
##  This file contains declarations for procedures related to
##  compact Lie group.
##
##  Todo:
##    1. The speed of current implementation of DimensionOfFixedSet
##       for finite subgroup is not satisfactory. Think about how to
##       improve it.
##


##  Part 1: Group and Subgroup

#############################################################################
##
#O  PrintObj( <G> )
##
InstallMethod( PrintObj,
  "print for compact Lie group",
  [ IsCompactLieGroup ],
  50,
  function( G )
    if HasString( G ) then
      Print( String( G ) );
    else
      TryNextMethod( );
    fi;
  end
);


##  Part 2: Conjugacy Class of Subgroups

#############################################################################
##
#U  NewConjugacyClassSubgroups( filt, grp )
##
InstallMethod( NewConjugacyClassSubgroups,
  "constructor of CCS for compact Lie group",
  [ IsCompactLieGroupConjugacyClassSubgroupsRep, IsCompactLieGroup ],
  function( filt, grp )
    local cat_grp,  # categary of grp
          fam,      # family of object
          cat,	    # category of object
          rep,	    # representation of object
          type,     # type of object
          obj;		  # object consturcted

    # objectify
    fam := CollectionsFamily( FamilyObj( grp ) );
    cat := IsObject;
    for cat_grp in List( CategoriesOfObject( grp ), c->EvalString( c ) ) do
      cat := cat and CategoryCollections( cat_grp );
    od;
    rep := IsCompactLieGroupConjugacyClassSubgroupsRep;
    type := NewType( fam, cat and rep );
    obj := Objectify( type, rec( ) );

    SetActingDomain( obj, grp );
    # if IsBound( attr.order_of_weyl_group ) then
    #   SetOrderOfWeylGroup( C, attr.order_of_weyl_group );
    # fi;

    # if IsBound( attr.representative ) then
    #   SetRepresentative( C, attr.representative );
    #   SetParentAttr( attr.representative, G );

    #   if IsBound( attr.order_of_weyl_group ) then
    #     SetOrderOfWeylGroup( attr.representative, attr.order_of_weyl_group );
    #   fi;

    #   if IsBound( attr.normalizer ) then
    #     SetStabilizerOfExternalSet( C, attr.normalizer );
    #     SetNormalizerInParent( attr.representative, attr.normalizer );
    #   fi;
    # fi;

    # if IsBound( attr.goursat_info ) then
    #   SetGoursatInfo( C, attr.goursat_info );
    # fi;

    # if IsBound( attr.string ) then
    #   SetString( C, attr.string );
    # fi;

    # if IsBound( attr.abbrv ) then
    #   SetAbbrv( C, attr.abbrv );
    # fi;

    # if IsBound( attr.latex_string ) then
    #   SetLaTeXString( C, attr.latex_string );
    # fi;

    # if IsBound( attr.order_of_representative ) then
    #   SetOrderOfRepresentative( C, attr.order_of_representative );
    # fi;

    return obj;
  end
);

#############################################################################
##
#U  NewConjugacyClassSubgroups( filt, grp )
##
InstallMethod( NewConjugacyClassSubgroups,
  "constructor of prototype of conjugacy class of subgroups",
  [ IsPrototypeConjugacyClassSubgroupsRep, IsGroup ],
  function( filt, grp )
    local cat_grp,  # category of grp
          fam,      # family of object
          cat,	    # category of object
          rep,	    # representation of object
          type,     # type of object
          obj;		  # obj constructed

    # objectify
    fam := CollectionsFamily( CollectionsFamily( FamilyObj( grp ) ) );
    cat := IsObject;
    for cat_grp in List( CategoriesOfObject( grp ), c->EvalString( c ) ) do
      cat := cat and CategoryCollections( CategoryCollections( cat_grp ) );
    od;
    rep := IsPrototypeConjugacyClassSubgroupsRep;
    type := NewType( fam, cat and rep );
    obj := Objectify( type, rec( ) );

    SetActingDomain( obj, grp );

    return obj;
  end
);

#############################################################################
##
#O  SetCCSsAbbrv( <G>, <namelist> )
##
InstallMethod( SetCCSsAbbrv,
  "Set abbreviations of CCSs for a compact Lie group",
  [ IsCompactLieGroup, IsHomogeneousList ],
  function( G, namelist )
    local i,
          class,
          CCSs_G;

    if not ForAll( namelist, IsString ) then
      Error( "<namelist> must be a list of strings." );
    fi;

    CCSs_G := ConjugacyClassesSubgroups( G );

    if not ( Length( CCSs_G!.ccsClasses ) = Length( namelist ) ) then
      Error( "The length of <namelist> and the length of CCSs in G must coincide." );
    fi;

    for i in [ 1 .. Length( namelist ) ] do
      class := CCSs_G!.ccsClasses[ i ];
      class.abbrv := namelist[ i ];
      class.proto := NewConjugacyClassSubgroups(
          IsCompactLieGroupConjugacyClassSubgroupsRep, G, class );
    od;
  end
);

#############################################################################
##
#O  SetCCSsLaTeXString( <G>, <namelist> )
##
InstallMethod( SetCCSsLaTeXString,
  "Set LaTeX symbols of CCSs for a compact Lie group",
  [ IsCompactLieGroup, IsHomogeneousList ],
  function( G, namelist )
    local i,
          class,
          CCSs_G;

    if not ForAll( namelist, IsString ) then
      Error( "<namelist> must be a list of strings." );
    fi;

    CCSs_G := ConjugacyClassesSubgroups( G );

    if not ( Length( CCSs_G!.ccsClasses ) = Length( namelist ) ) then
      Error( "The number of strings in <namelist> and the the number of CCSs in G must coincide." );
    fi;

    for i in [ 1 .. Length( namelist ) ] do
      class := CCSs_G!.ccsClasses[ i ];
      class.latex_string := namelist[ i ];
      class.proto := NewConjugacyClassSubgroups(
          IsCompactLieGroupConjugacyClassSubgroupsRep, G, class );
    od;
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
#O  Refolded( <C>, <l> )
##
  InstallMethod( Refolded,
    "refolds CCS of a compact Lie group",
    [ IsCompactLieGroupConjugacyClassSubgroupsRep, IsInt ],
    function( C, l )
      local G,
            G1,
            CCSs,
            id;

      G := ActingDomain( C );
      G1 := DirectProductDecomposition( G )[ 1 ];
      CCSs := ConjugacyClassesSubgroups( G );
      id := ShallowCopy( IdCCS( C ) );

      if ( G1 = SpecialOrthogonalGroupOverReal( 2 ) ) then
        if not IsZero( id[ 1 ] ) and not IsZero( l ) then
          id[ 1 ] := l;
          return CCSs[ id ];
        else
          return C;
        fi;
      elif ( G1 = OrthogonalGroupOverReal( 2 ) ) then
        if IsPosInt( id[ 1 ] ) and IsPosInt( l ) then
          id[ 1 ] := l;
          return CCSs[ id ];
        else
          return C;
        fi;
      else
        TryNextMethod( );
      fi;
    end
  );

#############################################################################
##
#U  NewConjugacyClassesSubgroups( filt, grp )
##
InstallMethod( NewConjugacyClassesSubgroups,
  "Constructor of CCSs for compact Lie group",
  [ IsCompactLieGroupConjugacyClassesSubgroupsRep, IsCompactLieGroup ],
  function( filt, grp )
    local cat_grp,
          fam,
          cat,
          rep,
          type,
          obj;

    # objectify
    fam := CollectionsFamily( CollectionsFamily( FamilyObj( grp ) ) );
    cat := IsObject;
    for cat_grp in List( CategoriesOfObject( grp ), c->EvalString( c ) ) do
      cat := cat and CategoryCollections( CategoryCollections( cat_grp ) );
    od;
    rep := IsPrototypeConjugacyClassSubgroupsRep;
    type := NewType( fam, cat and rep );
    obj := Objectify( type, rec( ) );

    # assign attributes to CCSs
    SetUnderlyingGroup( obj, grp );
    SetString( obj,
      StringFormatted( "ConjugacyClassesSubgroups( {} )", String( grp ) )
    );
    SetAbbrv( obj,
      StringFormatted( "ConjugacyClassesSubgroups( {} )", ViewString( grp ) )
    );

    return obj;
  end
);

#############################################################################
##
#O  \[\]( <CCSs>, <l>, <j> )
##
  InstallMethod( \[\,\],
    "CCS selector for compact Lie group",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep, IsInt, IsPosInt ],
    function( CCSs, l, j )
      local G,
            cl,
            attr,
            CCSs_ECLG,
            idC1,
            C1_proto,
            C1,
            idCZ1,
            CZ1,
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

          CZ1 := cl.goursat_info.CZ1;
          idCZ1 := ShallowCopy( IdCCS( CZ1 ) );
          idCZ1[ 1 ] := l;
          CZ1 := CCSs_ECLG[ idCZ1 ];

          epi := GroupHomomorphismByImages(
            Representative( C1 ),
            Representative( C1_proto )
          );

          attr.goursat_info := rec(
            C1		:= C1,
            CZ1		:= CZ1,
            C2		:= cl.goursat_info.C2,
            CZ2		:= cl.goursat_info.CZ2,
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

        if IsBound( cl.latex_string ) then
          if IsBound( cl.goursat_info ) and ( Order( cl.goursat_info.L ) > 1 ) then
            attr.latex_string := StringFormatted( cl.latex_string, idC1[ 1 ], l );
          else
            attr.latex_string := StringFormatted( cl.latex_string, l );
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
        C := NewConjugacyClassSubgroups( cat, G, attr );
      else
        Error( "Invalid CCS id." );
      fi;

      SetIdCCS( C, [ l, j ] );
      return C;
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


##  Part 3: Representation and Character Theory

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
#U  NewCompactLieGroupClassFunction( IsCompactLieGroupClassFunction, <r> )
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
#O  ViewObj( <chi> )
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
  InstallMethod( DimensionOfFixedSet,
    "dimension of fixed set of finite subgroup <H>",
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

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <C> );
##
  InstallMethod( DimensionOfFixedSet,
    "returns dimension of fixed set of <C> whose representative is finite",
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
#A  MaximalOrbitTypes(<chi>)
##
  InstallMethod(MaximalOrbitTypes,
    "maximal orbit types associated to compact Lie group character <chi>",
    [IsCompactLieGroupCharacter],
    function(chi)
      local orbtyps;

      orbtyps := ShallowCopy(OrbitTypes(chi));
      Remove(orbtyps);
      return MaximalElements(orbtyps);
    end
  );

#############################################################################
##
#A  LatticeOrbitTypes( <chi> )
##
  InstallMethod( LatticeOrbitTypes,
    "lattice of orbit types associated to compact Lie group character <chi>",
    [ IsCompactLieGroupCharacter ],
    chi -> NewLatticeOrbitTypes( chi )
  );


#############################################################################
##
#E  CompactLieGroup.gi . . . . . . . . . . . . . . . . . . . . . .  ends here
