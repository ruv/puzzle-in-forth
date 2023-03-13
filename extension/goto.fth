\ 2023-03-11 ruv
\ License: Apache License 2.0. https://www.apache.org/licenses/LICENSE-2.0

\ Example of implementation GOTO in the standard Forth -- proof of concept (PoF)
\ See-also: https://groups.google.com/g/comp.lang.forth/c/zx3RBNWK5XI/m/FKBtxoy-AgAJ
\
\ Environmental dependencies:
\   - the control-flow stack is implemented using the data stack in the Forth system.
\
\ Limitations:
\   - 'goto' cannot cross a do-loop construct and definition boundaries
\     (including quotations and 'does>' part).
\     - NB: such an incorrect crossing is not checked in this implementation.
\
\ Usage:
\   The block of code in which 'goto' is allowed is wrapped by wg{ ... }wg
\   'wg' is named after 'with-goto'. Such blocks can be nested.
\   Only the labels specified in the nearest containing 'wg' block are available for 'goto'.
\   A label is specified as:
\       label( name )
\   A goto instruction is specified as:
\       goto( name )


include ../lib/compat.fth

require-word n>mem              ../lib/nmem.fth
require-word search-namelist    ../lib/namelist.fth


: push-mark-by ( sd.key namelist xt -- )
  swap >r -rot 2>r execute-balance n>mem 2r> r> push-namelist
;
: pop-mark ( sd.key namelist -- i*x true | false )
  pop-namelist if nmem> drop true exit then false
;
: find-mark ( sd.key namelist -- i*x true | false )
  search-namelist if nmem@ drop true exit then false
;
: drop-mark-all ( namelist -- )
  begin dup pop-namelist-topmost while free-nmem repeat drop
;



new-namelist value nl-begin
new-namelist value nl-ahead

: begin, ( -- dest ) postpone begin ;
: again, ( dest -- ) postpone again ;
: ahead, ( -- orig ) postpone ahead ;
: then,  ( orig -- ) postpone then  ;

: label, ( sd.name -- )
  2>r begin 2r@ nl-ahead pop-mark while then, repeat
  2r> ( sd.name ) nl-begin ['] begin, push-mark-by
;
: goto, ( sd.name -- )
  2dup nl-begin find-mark if again, 2drop exit then
  nl-ahead ['] ahead, push-mark-by
;



: label( ( "name <rparen>" -- )   \ example: label( a )
  parse-name label,   parse-name s" )" equals 0= -22 and throw
; immediate

: goto(  ( "name <rparen>" -- )   \ example:  goto( a )
  parse-name goto,    parse-name s" )" equals 0= -22 and throw
; immediate

: wg{
  nl-ahead nest-namelist
  nl-begin nest-namelist
; immediate

: }wg
  nl-begin dup drop-mark-all unnest-namelist
  nl-ahead namelist-head 0<> dup >r if cr
    ." \ Error: unresolved 'goto' labels: " cr
    ." \   " nl-ahead [: ( x sd.name -- ) type space drop ;] visit-namelist-with cr
  then
  nl-ahead dup drop-mark-all unnest-namelist
  r> abort" some labels for 'goto' are not found"
; immediate



\ test the environment

:noname [ ' begin, execute-balance ] literal exit again ; execute 0= [if]
  cr
  .( \ The "goto.fth" extension can only work properly when the control-flow stack ) cr
  .( \ is implemented using the data stack, but this Forth system does not satisfy ) cr
  .( \ this condition [environmental dependency]. ) cr
  .( \ Abort. ) cr
  abort
[then]
