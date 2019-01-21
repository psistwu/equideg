  # This script continues tst1.gap

  l1 := List( [ 1 .. 33 ], j -> CCSs_o2xs4[ 0, j ] );
  l2 := List( [ 1 .. 67 ], j -> CCSs_o2xs4[ 2, j ] );
  chi := irrs_o2xs4[ -1, 2 ];

  Print( List( l1, C -> DimensionOfFixedSet( chi, C ) ) );
  Print( List( l2, C -> DimensionOfFixedSet( chi, C ) ) );
