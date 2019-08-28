LoadPackage( "equideg" );

TestDirectory(DirectoriesPackageLibrary( "equideg", "tst" ),
  rec(exitGAP     := true,
      testOptions := rec(compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1);

