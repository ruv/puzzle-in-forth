
include ./compat.fth

require-word search-list-with ./cons-list.fth

\ require-word t{   tester.f




t{ 2 1 >cons  dup cdr swap dup car  swap cons> 2over d= ->  2 1 true }t

t{ align here 2 1 >cons, tuck = swap cons@ -> true 2 1 }t


t{ 0 [: 1 ;] visit-list-with -> }t

t{  0  1 >cons 2 >cons 3 >cons  value c3 -> }t

t{ c3 car -> 3 }t
t{ c3 cdr car -> 2 }t
t{ c3 cdr cdr car -> 1 }t
t{ c3 cdr cdr cdr -> 0 }t


t{ 0 c3 [: drop 1+ ;] visit-list-with -> 3 }t

t{ 0 c3 [: drop 1+ false ;] search-list-with ->  3 0 }t

t{ c3 [: car 2 = ;] search-list-with  car -> 2 }t


t{ 0 0 list-node-parent -> 0 0 }t
t{ c3 0 list-node-parent -> c3 0 }t
t{ c3 c3 list-node-parent -> c3 0 }t
t{ 0  c3 list-node-parent -> 0  c3 cdr cdr }t
t{ c3 cdr cdr  c3 list-node-parent -> c3 cdr cdr  c3 cdr }t


t{ 0 0 exclude-list-node -> 0 0 }t
t{ c3 0 exclude-list-node -> c3 0 }t
t{ 0 c3 exclude-list-node -> 0 c3 }t
t{ c3 c3 exclude-list-node -> c3 c3 cdr }t
t{ c3 cdr dup c3 exclude-list-node  -rot = -> c3 true }t
t{ c3 cdr car -> 1 }t


.( \ All tests in "cons-list.test.fth" are passed ) cr
