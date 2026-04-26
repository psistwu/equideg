gap> START_TEST("test_LowestDegree.tst");

# Test 1: Zero polynomial should return -infinity
gap> x := Indeterminate(Rationals, "x");;
gap> zeropoly := 0*x;;
gap> LowestDegree(zeropoly) = -infinity;
true

# Test 2: Constant polynomial (degree 0 only)
gap> constpoly := 5*x^0;;
gap> LowestDegree(constpoly);
0

# Test 3: Polynomial with positive powers only (lowest degree is 0)
gap> poly1 := x^2 + 2*x + 3;;
gap> LowestDegree(poly1);
0

# Test 4: Polynomial with lowest degree 1
gap> poly2 := x + x^2 + x^3;;
gap> LowestDegree(poly2);
1

# Test 5: Polynomial with lowest degree 3
gap> poly3 := x^3 + x^4;;
gap> LowestDegree(poly3);
3

# Test 6: Laurent polynomial with negative powers
# Create x^(-1) by dividing by a polynomial
gap> lpoly1 := 1/(x);;
gap> LowestDegree(lpoly1);
-1

# Test 7: Laurent polynomial with degree -2
gap> lpoly2 := 1/(x^2);;
gap> LowestDegree(lpoly2);
-2

# Test 8: Laurent polynomial with negative and positive powers
# (1 + x) / x^3 = x^(-3) + x^(-2)
gap> lpoly3 := (1 + x)/(x^3);;
gap> LowestDegree(lpoly3);
-3

# Test 9: More complex Laurent polynomial
# (x^2 + 2*x + 1) / x = x + 2 + x^(-1)
gap> lpoly4 := (x^2 + 2*x + 1)/x;;
gap> LowestDegree(lpoly4);
-1

# Test 10: Negative degree -5
gap> lpoly5 := 1/(x^5);;
gap> LowestDegree(lpoly5);
-5

# Test 13: Verify LowestDegree returns integer or -infinity
gap> x := Indeterminate(Rationals, "x");;
gap> ld1 := LowestDegree(0*x);;
gap> ld1 = -infinity or IsInt(ld1);
true
gap> ld2 := LowestDegree(5*x^0);;
gap> IsInt(ld2);
true
gap> ld3 := LowestDegree(1/x);;
gap> IsInt(ld3);
true

# Test 14: Coefficient on zero polynomial
gap> coeffs := List([-2..2], n -> Coefficient(0*x, n));;
gap> coeffs;
[ 0, 0, 0, 0, 0 ]

# Test 15: Coefficient on constant polynomial
gap> constpoly := 5*x^0;;
gap> Coefficient(constpoly, 0);
5
gap> Coefficient(constpoly, 1);
0
gap> Coefficient(constpoly, -1);
0

# Test 16: Coefficient on polynomial with non-negative degrees
gap> poly1 := x^2 + 2*x + 3;;
> [Coefficient(poly1,0), Coefficient(poly1,1), Coefficient(poly1,2), Coefficient(poly1,3)];
[ 3, 2, 1, 0 ]

# Test 17: Coefficient on Laurent polynomial with negative powers
gap> lpoly1 := (1 + x)/(x^3);;
> [Coefficient(lpoly1,-3), Coefficient(lpoly1,-2), Coefficient(lpoly1,-1), Coefficient(lpoly1,0)];
[ 1, 1, 0, 0 ]

# Test 18: Coefficient out of range returns 0
gap> lpoly2 := x^2 + x^3;;
> [Coefficient(lpoly2,-1), Coefficient(lpoly2,4)];
[ 0, 0 ]
gap> STOP_TEST("test_LowestDegree.tst");
