
include ./compat.fth

require-word search-namelist ./namelist.fth

\ require-word t{   tester.f




t{ new-namelist value nl  nl cons@ -> 0 0 }t
t{ 0 0  nl search-namelist -> false }t
t{ "foo" nl search-namelist -> false }t
t{ "foo" nl pop-namelist -> false }t
t{ nl pop-namelist-topmost -> false }t

t{ 0 nl [: 2drop drop 1+ ;] visit-namelist-with -> 0 }t

t{ 10 "foo" nl push-namelist -> }t

t{ "foo" nl search-namelist -> 10 true }t
t{ "bar" nl search-namelist -> false }t

t{ nl [: "foo" equals ;] visit-namelist-with -> 10 true }t


t{ 20 "bar" nl push-namelist -> }t
t{ 11 "foo" nl push-namelist -> }t
t{ 0 nl [: 2drop drop 1+ ;] visit-namelist-with -> 3 }t

t{ "foo" nl search-namelist -> 11 true }t
t{ "bar" nl search-namelist -> 20 true }t

t{ "foo" nl pop-namelist -> 11 true }t
t{ "foo" nl pop-namelist -> 10 true }t
t{ "foo" nl pop-namelist -> false }t
t{ "foo" nl search-namelist -> false }t

t{ nl pop-namelist-topmost -> 20 true }t
t{ nl pop-namelist-topmost -> false }t

t{ 25 "bar" nl push-namelist -> }t
t{ 15 "foo" nl push-namelist -> }t
t{ nl nest-namelist  nl namelist-head -> 0 }t

t{ 30 "bar" nl push-namelist -> }t
t{ nl pop-namelist-topmost -> 30 true }t
t{ nl pop-namelist-topmost -> false }t
t{ nl unnest-namelist -> }t
t{ nl pop-namelist-topmost -> 15 true }t
t{ nl pop-namelist-topmost -> 25 true }t
t{ nl pop-namelist-topmost -> false }t


.( \ All tests in "namelist.test.fth" are passed ) cr
