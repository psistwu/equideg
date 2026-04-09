Print( "Testing methods regarding Representation Theory....\n\n" );

LoadPackage( "equideg" );

dir := DirectoriesPackageLibrary( "equideg", "tst/test_RepresentationTheory" );
TestDirectory(
  dir,
  rec( exitGAP:=true, earlyStop:=true )
);

FORCE_QUIT_GAP( 1 );
