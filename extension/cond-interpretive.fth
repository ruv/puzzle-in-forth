\ 2024-03-14 Ruv

\ An example of implementation interpretive "if ... else ... then" in the standard Forth (PoC).
\
\ Limitation: if a phrase cannot be used in compilation state,
\ then it cannot be used inside interpretive if-then
\
\ An idea is that the false branch is compiled into a nameless definition and then discarded.


[undefined] compilation [if]
: compilation ( -- flag ) state @ 0<> ;
[then]

[undefined] exch-current [if]
: exch-current ( wid1 -- wid2 )
  get-current swap set-current
;
[then]

[undefined] >order [if]
: >order ( wid -- ) >r get-order r> swap 1+ set-order ;
[then]
[undefined] order> [if]
: order> ( -- wid ) get-order swap >r 1- set-order r> ;
[then]


wordlist constant cond-interpretive
wordlist constant cond-interpretive-private

cond-interpretive-private dup >order exch-current

0 value n \ nesting level of "if"
: inc-n ( -- )  1 n + to n ;
: dec-n ( -- ) -1 n + to n ;
: ?n0 ( -- )  n if 0 to n -22 throw then ;

cond-interpretive set-current
\ NB: now the wordlist "cond-interpretive" is compilation word list,
\ and it's absent in the search order.

: if ( -- | x -- ) ( C: -- orig | -- )
  compilation if inc-n  postpone if  exit then
  ?n0  ( x ) if exit then  :noname
; immediate

: else ( C: orig1 -- orig2 | -- )
  compilation if
    n if  postpone else  exit then
    postpone ;  drop  exit
  then ?n0  :noname
; immediate

: then ( C: orig -- | -- )
  compilation if
    n if dec-n  postpone then  exit then
    postpone ;  drop  exit
  then ?n0
; immediate

order> drop exch-current >order
\ NB: now the wordlist "cond-interpretive" is in the search order top.
