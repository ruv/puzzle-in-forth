
[undefined] noop [if]
  : noop ;
[then]

[undefined] -rot [if]
  : -rot  ( 3*x -- 3*x ) rot rot ;
[then]

[undefined] rdrop [if]
  : rdrop ( R.runtime: x -- ) postpone r> postpone drop ; immediate
[then]
[undefined] 2rdrop [if]
  : 2rdrop ( R.runtime: x x -- ) postpone rdrop postpone rdrop ; immediate
[then]


[undefined] equals [if]
  : equals ( sd1 sd2 -- flag ) dup 3 pick <> if 2drop 2drop false exit then compare 0= ;
[then]

[undefined] execute-balance [if]
  : execute-balance ( i*x xt -- j*x n )
    depth 1- >r execute depth r> -
  ;
[then]


[undefined] require-word [if]
  : require-word ( "ccc ccc" ) postpone [defined] if parse-name 2drop else include then ;
[then]
