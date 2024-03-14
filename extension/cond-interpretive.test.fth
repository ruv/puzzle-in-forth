\ 2024-03-14 Ruv

include ../lib/compat.fth

require-word cond-interpretive ./cond-interpretive.fth


t{ 0 if 1 then -> }t
t{ 1 if 1 then -> 1 }t

t{ 0 if 1 s" else then " 2drop else 2 then -> 2 }t
t{ 1 if 1 else 2 then -> 1 }t

t{ 0 if  0 if 1 else 2 then  else  1 if 1 then  then -> 1 }t
t{ 1 if  0 if 1 else 2 then  else  1 if 1 then  then -> 2 }t


.( \ All tests in "cond-interpretive.test.fth" are passed ) cr
