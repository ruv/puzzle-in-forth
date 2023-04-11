\ 2023-03-11 ruv
\ License: Apache License 2.0. https://www.apache.org/licenses/LICENSE-2.0

\ Lisp flavored cons pairs and lists
\ See: https://en.wikipedia.org/wiki/Cons

\ '>cons ( x2 x1 -- cons )' creates a cons pair in dynamic memory.
\ 'cons> ( cons -- x2 x1 )' destructs the pair by shallow free its memory and return the content.
\ The top value on the stack corresponds to the first cell of a pair (car).

\ A list is represented by the head node, a node is a cons pair.
\ The value is stored in the first cell of a pair (car),
\ the next node ref is stored in the second cell of the pair (cdr).
\ The second cell (cdr) of the last node contains zero.
\ The empty list is represented by zero.


: cons@ ( cons -- x2 x1 ) 2@ ;
: cons! ( x2 x1 cons -- ) 2! ;

: >cons ( x2 x1 -- cons ) 2 cells allocate throw dup >r cons! r> ;
: cons> ( cons -- x2 x1 ) dup >r cons@ r> free throw ;

: car ( cons -- x1 ) @ ;
: cdr ( cons -- x2 ) cell+ @ ;

: car! ( x cons -- ) ! ;
: cdr! ( x cons -- ) cell+ ! ;

: append-list ( x cons.list1 -- cons.list2 ) swap >cons ;
: append-list-node ( cons.node cons.list1 -- cons.list2 ) over cdr! ;

: visit-list-with ( i*x cons.list|0 xt -- j*x ) \ xt ( i*x cons.node -- j*x )
  begin over while over cdr >r dup >r execute 2r> repeat 2drop
;
: search-list-with ( i*x cons.list|0 xt -- j*x cons.node|0 ) \ xt ( i*x cons.node -- j*x flag )
  >r begin dup while r@ over >r execute 0= while r> cdr repeat r> then rdrop
;
: list-node-parent ( cons.node|0 cons.list1|0 -- cons.node|0 cons.list2|0 )
  [: cdr over = ;] search-list-with
;
: exclude-list-node ( cons.node|0 cons.list1|0 -- cons.node|0 cons.list2|0 )
  dup   0= if exit then
  over  0= if exit then
  2dup  =  if cdr exit then
  dup >r list-node-parent  dup 0= if drop else ( cons.node cons.node-parent )
    over cdr swap cdr!
  then r> ( cons.node cons.list1 )
;

: push-list ( x addr.list -- )
  dup >r @ swap >cons r> !
;
: pop-list ( addr.list -- x )
  dup >r @ dup if cons> swap r> ! exit then
  drop rdrop true abort" Cannot pop from an empty list"
;
