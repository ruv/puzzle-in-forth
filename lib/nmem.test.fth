
include ./compat.fth

require-word n>mem ./nmem.fth

\ require-word t{   tester.f




t{ 123 pad !  pad 0 mem!n pad @ -> 123 }t

t{ 1 2 3 pad 3 mem!n  10 pad 1 mem!n   pad 3 mem@n -> 1 2 10 }t

t{ 10 20 2 n>mem 30 40 2  3 pick nmem!  nmem>  -> 30 40 2 }t

t{ 10 20 30 3 n>mem dup nmem@ -> dup 1+ pick dup nmem>  }t


t{ "foo bar" string>cmem count "foo bar" equals -> true }t


.( \ All tests in "nmem.test.fth" are passed ) cr
