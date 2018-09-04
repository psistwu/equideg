# GAP Equivariant Degree Library

### Author
Haopin Wu <[psistwu@outlook.com](mailto://psistwu@outlook.com "author_email")>

### Overview
This library provides GAP procedures for
computation related to equivariant degree theory,
which consists of the following parts:

1. System
2. Basic
3. Group
4. Compact Lie Group
5. Orbit Type
6. Direct Product
7. Burnside Ring

For each part listed above, there is a corresponding demo file in folder `./demo`.
If you need to run gap in a folder different from `./demo`,
please copy and paste `./demo/preload.gap` to your working directory and
change the path written in the file accordingly.
You can then load the library in the same way as that in the demo files.

***
***

## Part 1: System ###
### Files
* `libSys.g`
* `libSys.gd`
* `libSys.gi`

### Summary
`libSys` provides some system-level functions.

***

#### 1-1 `Clean` (global function)
> <code>Clean()</code>

`Clean` resets all user-defined variables.

***

#### Example 1.1

    gap> a := 1;;
    gap> Clean();
    Cleaning all user-defined variables.... Done!
    gap> a;
    Error, Variable: 'a' must have a value
    not in any function at *stdin*:3

***
***

## Part 2: Basic
### Files
* `libBasic.g`
* `libBasic.gd`
* `libBasic.gi`

### Summary
`libBasic` includes basic functions for mathematics.

***

#### 2-1 `DotFileLattice` (operation)
> <code>DotFileLattice( <var>lat</var>, <var>filename</var> )</code>

`DotFileLattice` generates a **dot** file with
name <var>filename</var> associated to lattice <var>lat</var>.
To obtain the diagram in a different format,
one needs to use the following command
in **Bash**:

> <code>dot -T`<format>` -o `<outputfile>` `<inputfile>`</code>

Please see examples in **Part 3: Group** and **Part 4: Orbit Type** for concrete usage.

***
***

## Part 3: Group
### Files
* `libGroup.g`
* `libGroup.gd`
* `libGroup.gi`

### Dependency
* `libBasic`

### Summary
`libGroup` provides more functions for basic group theory.

***

#### 3-1 `\<` (operation)
> <code><var>Csubg1</var> &lt; <var>Csubg2</var></code>

This is the partial order on the collection of CCSs of a group
induced by the subgroup relation.

#### 3-2 `OrderOfWeylGroup` (attribute)
> <code>OrderOfWeylGroup( <var>subg</var> )</code><br />
> <code>OrderOfWeylGroup( <var>Csubg</var> )</code>

`OrderOfWeylGroup` returns the order of the Weyl group of a subgroup.
The input argument can be either a **subgroup** or a **CCS**.

#### 3-3 `nLHnumber` (operation)
> <code>nLHnumber( <var>L</var>, <var>H</var> )</code><br />
> <code>nLHnumber( <var>CL</var>, <var>CH</var> )</code>

`nLHnumber` returns $n(L,H)$, i.e.,
the number of subgroups conjugate to $H$ which contain $L$.
The input arguments can be either two **subgroups** or two **CCSs**.

#### 3-4 `pCyclicGroup` (operation)
> <code>pCyclicGroup( <var>n</var> )</code>

`pCyclicGroup` returns a cyclic group embedded in a symmetric group.

#### 3-5 `pDihedralGroup` (operation)
> <code>pDihedralGroup( <var>n</var> )</code>

`pDihedralGroup` returns a dihedral group embedded in a symmetric group.

#### 3-6 `mCyclicGroup` (operation)
> <code>mCyclicGroup( <var>n</var> )</code>

`mCyclicGroup` returns a cyclic group as a collection of 2x2 matrices (a subgroup of $SO(2)$).

#### 3-7 `mDihedralGroup` (operation)
> <code>mDihedralGroup( <var>n</var> )</code>

`mDihedralGroup` returns a dihedral group as a collection of 2x2 matrices (a subgroup of $O(2)$).

#### 3-8 `LatticeCCSs` (attribute)
> <code>LatticeCCSs( <var>grp</var> )</code>

`LatticeCCSs` returns the CCSs lattice of group <var>grp</var>.

***

#### Example 3.1
This example demonstrates how to find the order of the Weyl group
and $n(L,H)$ for subgroups of $D_6$.

First, compute all CCSs of $D_6$.

    gap> grp := pDihedralGroup( 6 );;
    gap> ccs_list := ConjugacyClassesSubgroups( grp );;

Next, select two CCSs of $D_6$ and compute the order of the Weyl groups and $n(L,H)$.

    gap> ccs1 := ccs_list[ 5 ];;
    gap> ccs2 := ccs_list[ 8 ];;
    gap> OrderOfWeylGroup( ccs1 );
    4
    gap> OrderOfWeylGroup( ccs2 );
    2
    gap> ccs1 < ccs2;
    true
    gap> nLHnumber( ccs1, ccs2 );
    1

#### Example 3.2
This example shows how to generate CCSs lattice diagarm of $S_4$ in **pdf** format.

First, generate a **dot** file associated to the CCSs lattice diagram of $S_4$.

    gap> grp := SymmetricGroup( 4 );;
    gap> lat := LatticeCCSs( grp );
    <CCS lattice of Sym( [ 1 .. 4 ] ), 11 classes>
    gap> DotFileLattice( lat, "s4_ccslat.dot" );;

Then, convert the **dot** file to a **pdf** file by the following command in **Bash**.

    $ dot -Tpdf -o s4_ccslat.pdf s4_ccslat.dot

***
***

## Part 4: Compact Lie Group
### Files
* `libCompactLieGroup.g`
* `libCompactLieGroup.gd`
* `libCompactLieGroup.gi`

### Dependency
* `libBasic`
* `libGroup`

### Summary
`libCompactLieGroup` deals with Compact Lie Groups O(2) and SO(2).

***
***

## Part 5: Orbit Type
### Files
* `libOrbitType.g`
* `libOrbitType.gd`
* `libOrbitType.gi`

### Dependency
* `libBasic`
* `libGroup`

### Summary
`libOrbitType` deals with orbit types of group representations.

***

#### 5-1 `OrbitTypes` (attribute)
> <code>OrbitTypes( <var>char</var> )</code>

`OrbitTypes` returns the **indices** of CCSs which are orbit types of the given
group representation described by its character <var>char</var>.

#### 5-2 `LatticeOrbitTypes` (attribute)
> <code>LatticeOrbitTypes( <var>char</var> )</code>

`LatticeOrbitTypes` returns the lattice of orbit types of the given
group representation described by its character <var>char</var>.

#### 5-3 `DimensionOfFixedSet` (operation)
> <code>DimensionOfFixedSet( <var>char</var>, <var>subg</var> )</code><br />
> <code>DimensionOfFixedSet( <var>char</var>, <var>Csubg</var> )</code>

`DimensionOfFixedSet` returns dimension of the fixed set of a subgroup
with respect to the given group representation described by its character <var>char</var>.
The second argement can be either a **subgroup** or a **CCS**.

***

#### Example 5.1
This example demonstrates how to find orbit types and the lattice of
an irreducible $S_4$-representation described by its character.

First, let us select a 3-dimensional irreducible $S_4$-representation.

    gap> grp := SymmetricGroup( 4 );;
    gap> Display( CharacterTable( grp ) );
    CT2

     2  3  2  3  .  2
     3  1  .  .  1  .

       1a 2a 2b 3a 4a
    2P 1a 1a 1a 3a 2b
    3P 1a 2a 2b 1a 4a

    X.1     1 -1  1  1 -1
    X.2     3 -1 -1  .  1
    X.3     2  .  2 -1  .
    X.4     3  1 -1  . -1
    X.5     1  1  1  1  1
    gap> char := Irr( grp )[ 2 ];;

Next, find indices of orbit types and generate a dot file associated to the
lattice.

    gap> ind_orbtypes := OrbitTypes( char );
    [ 1, 3, 4, 7, 11 ]
    gap> lat_orbtypes := LatticeOrbitTypes( char );;
    gap> DotFileLattice( lat_orbtypes, "s4_obtlat2.dot" );;

Finally, convert the **dot** file to a **pdf** file in **Bash**.

    $ dot -Tpdf -o s4_obtlat2.pdf s4_obtlat2.dot

***
***

## Part 6: Direct Product
### Files
* `libDirectProduct.g`
* `libDirectProduct.gd`
* `libDirectProduct.gi`

### Dependency
* `libBasic`
* `libGroup`

### Summary
`libDirectProduct` implements the amalgamation notation for subgroups of
the direct product of two groups.

***

#### 6-1 `DirectProductComponents` (attribute)
> <code>DirectProductComponents( <var>grp</var> )</code>

`DirectProductComponents` returns the list of direct product
components of group <var>grp</var>.

#### 6-2 `SubgroupDirectProductInfo` (attribute)
> <code>SubgroupDirectProductInfo( <var>subg</var> )</code>

`SubgroupDirectProductInfo` returns the amalgamation description of a
subgroup of the direct product of two groups.

#### 6-3 `AmalgamationQuadruple` (attribute)
> <code>AmalgamationQuadruple( <var>Csubg</var> )</code>

`AmalgamationQuadruple` returns the quadruple of **indices** which
gives the amalgamation description of a CCS.

#### 6-4 `DirectProductDecomposition` (operation)
> <code>DirectProductDecomposition( <var>grp</var>, <var>elm</var> )</code>

`DirectProductDecomposition` returns the direct product decomposition
of an element in the direct product of groups.

#### 6-5 `DirectProductDecomposition` (attribute)
> <code>DirectProductDecomposition( <var>csubg</var> )</code>
> <code>DirectProductDecomposition( <var>char</var> )</code>

Suppose $G$ is a direct product of groups.
`DirectProductDecomposition` decomposes (1) a conjugacy class of subgroups of $G$
by conjugacy classes of subgroups of the direct product components of $G$, or
(2) a irreducible character of $G$ by irreducible character of direct product components
of $G$.

#### 6-6 `AmalgamationNotation` (operation)
> <code>AmalgamationNotation( <var>Csubg</var> )</code>

`AmalgamationNotation` returns the amalgamation notation of a CCS
of the direct product of two groups.
Before calling this function, one should name all CCSs of each
direct product component; otherwise, the the function will replace
names by indices.

***

#### Example 6.1
This example demonstrates how to obtain the amalgamation notation of
a subgroup and a CCS of $S_4\times D_3$.

First, create the group $S_4\times D_3$ and compute its CCSs.

    gap> grp1 := SymmetricGroup( 4 );;
    gap> grp2 := pDihedralGroup( 3 );;
    gap> grp := DirectProduct( grp1, grp2 );;
    gap> ccs_list := ConjugacyClassesSubgroups( grp );;

Next, take a subgroup of $S_4\times D_3$ and the associated CCS.

    gap> Csubg := ccs_list[ 38 ];;
    gap> subg := representative( Csubg );;

Now, we can get the amalgamation descrpition of the subgroup.

    gap> SubgroupDirectProductInfo( subg );
    rec( DiscriminantElements := [ (1,2)(3,4)(6,7) ],
      Quadruple := [ Group([ (1,2)(3,4), (), (3,4) ]), Group([ (3,4) ]), Group([ (1,2,3) ]),
          Group([ (2,3), (1,2,3), () ]) ] )

In order to obtain the amalgamation notation of CCSs of $S_4\times D_3$,
one has to name CCSs of $S_4$ and $D_3$.

    gap> ccs_s4_list := ConjugacyClassesSubgroups( grp1 );;
    gap> SetName( ccs_s4_list[ 1 ], "Z1" );;
    gap> SetName( ccs_s4_list[ 2 ], "Z2" );;
    gap> SetName( ccs_s4_list[ 3 ], "D1" );;
    gap> SetName( ccs_s4_list[ 4 ], "Z3" );;
    gap> SetName( ccs_s4_list[ 5 ], "V4" );;
    gap> SetName( ccs_s4_list[ 6 ], "D2" );;
    gap> SetName( ccs_s4_list[ 7 ], "Z4" );;
    gap> SetName( ccs_s4_list[ 8 ], "D3" );;
    gap> SetName( ccs_s4_list[ 9 ], "D4" );;
    gap> SetName( ccs_s4_list[ 10 ], "A4" );;
    gap> SetName( ccs_s4_list[ 11 ], "S4" );;
    gap> ccs_d3_list := ConjugacyClassesSubgroups( grp2 );;
    gap> SetName( ccs_d3_list[ 1 ], "Z1" );;
    gap> SetName( ccs_d3_list[ 2 ], "D1" );;
    gap> SetName( ccs_d3_list[ 3 ], "Z3" );;
    gap> SetName( ccs_d3_list[ 4 ], "D3" );;

Then, the following function will return the amalgamation notation
of the given CCS.

    gap> AmalgamationNotation( c );
    "(D2[D1,Z3]D3)"

#### Example 6.2

This example demonstrates how to decompose a CC and a irreducible
representation of $S_4\times D_3$.

First, generate the group $G:=S_4\times D_3$.

    gap> grp1 := SymmetricGroup( 4 );;
    gap> grp2 := pDihedralGroup( 3 );;
    gap> grp  := DirectProduct( grp1, grp2 );;

Then, select a **conjugacy class** and a **irreducible character** of $G$.

    gap> cc_list := ConjugacyClass( grp );;
    gap> irr_list := Irr( grp );;
    gap> cc := cc_list[ 9 ];;
    gap> irr := irr_list[ 7 ];;
    gap> DirectProductDecomposition( cc );
    [ (2,3,4)^G, (1,2,3)^G ]
    gap> DirectProductDecomposition( irr );
    [ Character( CharacterTable( Sym( [ 1 .. 4 ] ) ), [ 1, 1, 1, 1, 1 ] ),
      Character( CharacterTable( Sym( [ 1 .. 3 ] ) ), [ 2, 0, -1 ] ) ]

***
***

## Part 7: Burnside ring
### Files
* `libBurnsideRing.g`
* `libBurnsideRing.gd`
* `libBurnsideRing.gi`

### Dependency
* `libBasic`
* `libGroup`
* `libOrbitType`

***

#### 7-1 `BurnsideRing` (attribute)
> <code>BurnsideRing( <var>grp</var> )</code>

`BurnsideRing` returns the Burnside ring induced by a group <var>grp</var>.
Please refer to **Example 6.1** for arithmetic in the Burnside ring.

#### 7.2 `Basis` (attribute)
> <code>Basis( <var>brng</var> )</code>

`Basis` returns the canonical basis of <var>brng</var> as a free module over integers.

#### 7.3 `UnderlyingGroup` (attribute)
> <code>UnderlyingGroup( <var>brng</var> )</code>

`UnderlyingGroup` returns the the group by which <var>brng</var> is induced.

#### 7.4 `Dimension` (attribute)
> <code>Dimension( <var>brng</var> )</code>

`Dimension` returns the dimension of <var>brng</var> as a free module over integers.

#### 7.5 `Length` (attribute)
> <code>Length( <var>e</var> )</code>

`Length` returns the length of a Burnside ring element, which is the length of the
summation.

#### 7.6 `BasicDegree` (attribute)
> <code>BasicDegree( <var>char</var> )</code>

`BasicDegree` returns the basic degree of a given chararcter <var>char</var>.

***

#### Example 7.1
This example demonstrates how to perform arithmetic in Burnside ring $A(S_4)$.

First, generate Burnside ring $R:=A(S_4)$.

    gap> grp  := SymmetricGroup( 4 );
    Sym( [ 1 .. 4 ] )
    gap> brng := BurnsideRing( grp );
    BurnsideRing( Sym( [ 1 .. 4 ] ) )

Let us take two elements in $R$ and perform three basic operations, i.e.,
**addition**, **multiplication** and **scalar multiplication**.

    gap> a := Basis( brng )[ 4 ];
    <1(4)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )
    gap> b := Basis( brng )[ 8 ];
    <1(8)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )
    gap> a + b;
    <1(4)+1(8)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )
    gap> a * b;
    <1(1)+1(4)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )
    gap> 3 * (a + b);
    <3(4)+3(8)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )

#### Example 7.2
This example demonstrates how to calculate basic degree of
an irreducible $S_4$-representation and check if
the its square is multiplicative idenitity of $R$.

After performing **Example 6.1**, select an irreducible character.

    gap> char := Irr( grp )[ 2 ];
    Character( CharacterTable( Sym( [ 1 .. 4 ] ) ), [ 3, -1, -1, 0, 1 ] )
    gap> bdeg := BasicDegree( char );
    <1(1)-1(3)-1(4)-1(7)+1(11)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )

Then, compute the square of the basic degree and compare with the
multiplicative identity of $R$.

    gap> bdeg^2;
    <1(11)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )
    gap> One( brng );
    <1(11)> in BurnsideRing( Sym( [ 1 .. 4 ] ) )
    gap> bdeg^2 = One( brng );
    true

***
***