#-------
# GAP: Lattice of Orbit Types Library
#-------
# Implementation file of libLatticeOrbitTypes.g
#
# Author: Hao-pin Wu <hxw132130@utdalls.edu>
# Last update: 2016-12-14
#-------

#-----
# attribute(s)
#-----

#---
# OrbitTypes
#---
  InstallMethod( OrbitTypes,
    "orbit types of the representation",
    [ IsCharacter ],
    function( chi )

      local G,
            i,
            j,
            orbittypes,
            ccs,
            is_orbittype,
            fixeddims;

      orbittypes := [ ];
      G := UnderlyingGroup( chi );
      ccs := ConjugacyClassesSubgroups( G );
      fixeddims := List( ccs, c -> DimensionOfFixedSet( chi, c ) );

      for i in Reversed( [ 1 .. Size( ccs ) ] ) do
        is_orbittype := true;
        for j in [ i+1 .. Size( ccs ) ] do
          if ( fixeddims[ i ] = fixeddims[ j ] ) and ( ccs[ i ] < ccs[ j ] ) then
            is_orbittype := false;
            break;
          fi;
        od;
        if is_orbittype then
          Add( orbittypes, i, 1 );
        fi;
      od;

      return orbittypes;

    end
  );
#---

#---
# AlphaCharacteristic
#---
  InstallMethod( AlphaCharacteristic,
    "Alpha-characteristic of the representation",
    [ IsCharacter ],
    function( chi )

      local orbittypes,
            G,
            ccs;

      G := UnderlyingGroup( chi );

      ccs := ConjugacyClassesSubgroups( G );
      orbittypes := ShallowCopy( OrbitTypes( chi ) );
      if ( DimensionOfFixedSet( chi, G ) = 0 ) then
        Remove( orbittypes );
      fi;

      return Order( G ) / Lcm( List( ccs{ orbittypes }, c -> Size( Representative ( c ) ) ) );
    end
  );
#---

#---
# LatticeOrbitTypes
#---
  InstallMethod( LatticeOrbitTypes,
    "lattice of orbit types of the given character",
    [ IsCharacter and IsFinite ],
    function( chi )

      local	G;		# the underlying group

      return;

    end
  );

#---

#-----
# property(s)
#-----

#---
# IsAGroup
#---
  InstallMethod( IsAGroup,
    "check whether the given group is an A-group",
    [ IsGroup ],
    function( G )

      local nontris,
            tri;

      tri := TrivialCharacter( G );
      nontris := Filtered( Irr( G ), chi -> not ( chi = tri ) );
      
      return not ( 1 in List( nontris, chi -> AlphaCharacteristic( chi ) ) );

    end
  );
#---

#-----
# operation(s)
#-----

#---
# DimensionOfFixedSet
#---
  InstallMethod( DimensionOfFixedSet,
    "compute the dimension of fixed set for given character and subgroup",
    [ IsCharacter and IsFinite, IsGroup and IsFinite ],
    function( chi, U )

      local G,		# the parent group
            chi_U;	# restriction of chi on U

      G := UnderlyingGroup( chi );

      if not IsSubgroup( G, U ) then
        Info( ERROR, MSGLEVEL, "U is not a subgroup of the underlying group of chi." );
        Error();
      fi;

      chi_U := RestrictedClassFunction( chi, U );

      return ScalarProduct( chi_U, TrivialCharacter( U ) );

    end
  );

#-
  InstallMethod( DimensionOfFixedSet,
    "compute the dimension of fixed set for given character and CCSubgroups",
    [ IsCharacter and IsFinite, IsConjugacyClassSubgroupsRep ],
    function( chi, C )

      return DimensionOfFixedSet( chi, Representative( C ) );

    end
  );

#---

#-----
# function(s)
#-----

