#############################################################################
##
#W  RepresentationTheory.gi    GAP Package `EquiDeg'    Haopin Wu
##
#Y  Copyright (C) 2024  Haopin Wu
##
##  MIT License
##

#############################################################################
##
#O  SchurIndicator( <chi> )
##
  InstallOtherMethod( SchurIndicator,
    "2nd Schur Indicator of character <chi> whose underlying group is a direct product of groups",
    [ IsCompactLieGroupCharacter and IsIrreducibleCharacter ],
    function( chi )
      local underlying_group,
            tensor_factors;
    
      underlying_group := UnderlyingGroup( chi );

      if not HasDirectProductInfo( underlying_group ) then
        TryNextMethod();
      fi;

      tensor_factors := TensorProductDecomposition( chi );

      return Product( tensor_factors, SchurIndicator );
    end
  );