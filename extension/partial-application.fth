\ 2023-04-10 Ruv
\ License: Apache License 2.0. https://www.apache.org/licenses/LICENSE-2.0

\ PoC: Implementation of partial application in Standard Forth.
\ The dictionary is not used at run-time.
\ The produced xt can be release in any time (independently of other xt-s).

\ 1part ( x xt.full -- xt.part )
\   xt.part identifies a part of xt.full execution semantics
\   that is specialized by the top parameter x

\ npart ( i*x u.i xt.full -- xt.part )
\   xt.part identifies a part of xt.full execution semantics
\   that is specialized by u.i top parameters represented by i*x

\ free-part ( xt.part --  )
\   free the resources taken by xt.part



include ../lib/compat.fth

require-word n>mem              ../lib/nmem.fth
require-word search-list-with   ../lib/cons-list.fth


[undefined] pool-thunk-length [if]
  1024 constant pool-thunk-length
[then]


variable pool-idle  0 pool-idle !
variable pool-all   0  pool-all !

: (build-thunk) ( addr.cons -- xt )
  >r :noname r> lit, postpone cons@ postpone execute postpone ;
;
: build-pool-item ( -- addr.item )
  0 0 ( xt.thunk  xt.free   ) >cons
  0 0 ( x.param   xt.action ) >cons
  >cons dup >r car (build-thunk)  r@ cdr cdr!  r>
;
: configure-pool-item* ( x.param xt.action xt.free  addr.item -- addr.item )
  dup >r  cdr car!  r@ car cons!  r>
;
: build-pool-all ( -- )
  pool-thunk-length 0 ?do
    build-pool-item dup  pool-idle push-list  pool-all push-list
  loop
; build-pool-all

: find-pool-item ( xt.thunk -- addr.item true | false )
  pool-all @ [: car cdr cdr over = ;] search-list-with nip
  dup if car true then
;
: hire-thunk ( x.data xt.run xt.free -- xt.thunk ) \ xt.free ( x -- )
  pool-idle pop-list configure-pool-item* cdr cdr
;
: release-thunk ( xt.thunk -- )
  find-pool-item 0= abort" Supplied xt is not a thunk"
  dup >r car car 0= abort" Supplied thunk already released"
  r@ car cdr ( x ) r@ cdr car ( xt.free ) execute
  0 r@ car car! r> pool-idle push-list
;

: npart ( i*x u.i xt.full -- xt.part )
  swap 1+ n>mem [: nmem@ drop execute ;]  ['] free-nmem  hire-thunk
;
: free-part ( xt.part -- ) release-thunk ;
: 1part ( x xt.full -- xt.part ) ['] drop hire-thunk ;
