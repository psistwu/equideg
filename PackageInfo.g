#############################################################################
##  
##  PackageInfo.g for the package `EquiDeg'                         Haopin Wu
##
##
##

SetPackageInfo( rec(
  PackageName := "EquiDeg",
  Subtitle := "A GAP package for Equivariant Degree Theory",
  Version := "0.1",
  Date := "30/11/2018",	# dd/mm/yyyy format

##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.1">
##  <!ENTITY RELEASEDATE "30 November 2018">
##  <#/GAPDoc>


  Persons := [
    rec( 
      LastName      := "Wu",
      FirstNames    := "Haopin",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "psistwu@outlook.com",
      WWWHome       := "http://psistwu.sdf.org",
      PostalAddress := Concatenation( [
                       "Haopin Wu\n",
                       "Department of Mathematics\n",
                       "National Tsing Hua University\n",
                       "No. 101, Sec. 2, Guangfu Rd.\n",
                       "East District, Hsinchu City 300\n",
                       "Taiwan" ] ),
      Place         := "Hsinchu City",
      Institution   := "National Tsing Hua University"
    )
  ],

  PackageWWWHome := Concatenation(
    "https://gap-packages.github.io/",
    LowercaseString( ~.PackageName )
  ),

  SourceRepository := rec(
    Type := "git",
    URL  := "https://github.com/psistwu/GAP-EDL"
  ),

  IssueTrackerURL := Concatenation(
    ~.SourceRepository.URL,
    "/issues"
  ),

  SupportEmail := "psistwu@outlook.com",

  ArchiveURL := Concatenation(
    ~.SourceRepository.URL,
    "/releases/download/v", ~.Version,
    "/", ~.PackageName, "-", ~.Version
  ),

  ArchiveFormats := ".tar.gz",

  Status := "dev",

  README_URL := Concatenation(
    ~.PackageWWWHome,
    "/README.md"
  ),

  PackageInfoURL := Concatenation(
    ~.PackageWWWHome,
    "/PackageInfo.g"
  ),

  AbstractHTML := Concatenation(
    "This <span class=\"pkgname\">GAP</span> package provides functions ",
    "for computation associated with Equivairant Degree Theory."
  ),

  PackageDoc := rec(
    BookName  := "EquiDeg",
    ArchiveURLSubset := [ "doc" ],
    HTMLStart := "doc/chap0.html",
    PDFFile   := "doc/manual.pdf",
    SixFile   := "doc/manual.six",
    LongTitle := "A GAP Package for Equivariant Degree Theory"
  ),


  Dependencies := rec(
    GAP := ">= 4.7",
    NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ] ],
    SuggestedOtherPackages := [],
    ExternalConditions := []
  ),

  AvailabilityTest := ReturnTrue,

  BannerString := Concatenation(
    "----------------------------------------------------------------\n",
    "Loading EquiDeg ", ~.Version, "\n",
    "by ",
    JoinStringsWithSeparator( List( Filtered( ~.Persons, r -> r.IsAuthor ),
                                    r -> Concatenation(
        r.FirstNames, " ", r.LastName, " <", r.Email, ">\n" ) ), "   " ),
    "For help, type: ?EquiDeg package \n",
    "----------------------------------------------------------------\n" ),

  TestFile := "tst/testall.g",

  Keywords := [
    "Burnside ring",
    "equivariant degree theory",
    "Euler ring", "group theory",
    "representation theory"
  ]

) );
