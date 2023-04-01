Print("You should start GAP using `gap -A -x 80 -m 100m -o 1g -K 2g'.\n\n");

LoadPackage("equideg");

dir := DirectoriesPackageLibrary("equideg", "tst/test_CompactLieGroup");
TestDirectory(dir, rec(exitGAP:=true,
                       earlyStop:=true));

FORCE_QUIT_GAP(1);
