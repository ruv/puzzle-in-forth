\ 2023-03-12 ruv
\ License: Apache License 2.0. https://www.apache.org/licenses/LICENSE-2.0

\ Dynamic singly-linked list of names.
\ It's based on the cons-list.
\ A node is a pair of a key (a string) and a cell (x).


include ./compat.fth

require-word search-list-with   ./cons-list.fth
require-word string>cmem        ./nmem.fth



: new-namelist ( -- namelist ) 0 0 >cons ;

: namelist-head ( namelist -- cons.list ) car ;
: namelist-head! ( cons.list namelist -- ) car! ;

: nest-namelist ( namelist -- ) dup >r cons@ >cons 0  r> cons! ;

: unnest-namelist ( namelist -- )
  dup >r cons@
  over 0=   abort" non-nested namelist cannot be unnested"
  dup       abort" non-empty namelist cannot be unnested"
  drop cons> r> cons!
;


: (search-namelist-node) ( sd.name namelist -- sd.name cons.node|0 )
  namelist-head [: ( sd.key cons.node -- sd.key flag ) >r 2dup r> car car count equals ;]
  search-list-with
;
: search-namelist ( sd.name namelist -- x true | false )
  (search-namelist-node) nip nip  dup if car cdr true then
;
: push-namelist ( x sd.name namelist -- )
  >r string>cmem >cons r@ namelist-head append-list r> namelist-head!
;
: pop-namelist ( sd.name namelist -- x true | false )
  dup >r (search-namelist-node) nip nip dup 0= if rdrop exit then
  r@ namelist-head exclude-list-node ( cons.node cons.list ) r> namelist-head!
  cons> nip  cons> free-nmem  true
;
: pop-namelist-topmost ( namelist -- x true | false )
  dup namelist-head  dup 0= if nip exit then ( namelist cons.list )
  swap >r  cons>  swap r> namelist-head!   cons> free-nmem   true
;
: visit-namelist-with ( i*x namelist xt -- j*x ) \ xt ( i*x x sd.name -- j*x )
  swap namelist-head [: ( xt cons.node -- xt ) swap >r car cons@ count r@ execute r> ;]
  visit-list-with drop
;
