\ 2023-03-11 ruv
\ License: Apache License 2.0. https://www.apache.org/licenses/LICENSE-2.0

\ Save a tuple from the stack into memory, and restore from memory to the stack.


: mem!n ( i*x addr u.i -- )
  begin dup while >r tuck ! cell+ r> 1- repeat 2drop
  \ it stores the topmost value at the bottom-most address (like '2!' does)
;
: mem@n ( addr u.i -- i*x )
  cells over + begin 2dup u< while cell- dup @ -rot repeat 2drop
;

: nmem! ( i*x u.i addr -- ) over 1+ mem!n ;
: nmem@ ( addr -- i*x u.i ) dup @ 1+ mem@n ;

: free-nmem ( addr -- ) free throw ;

: n>mem ( i*x u.i -- addr )
  dup 1+ cells allocate throw dup >r nmem! r>
;
: nmem> ( addr -- i*x u.i )
  dup >r nmem@ r> free-nmem
;

: string>cmem ( c-addr1 u -- c-addr2 )
  dup [ -1 pad ! pad c@ ]  literal u> abort" A character string is too long for a counted string"
  dup char+ char+  allocate throw  dup >r ( c-addr1 u1 c-addr2 )
  2dup c!   char+  2dup + 0 swap c!  swap move  r>
;

