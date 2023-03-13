
include ../lib/compat.fth

require-word find-mark ./goto.fth

\ require-word t{   tester.f


new-namelist value nl

t{ "foo" nl find-mark -> false }t
t{ "foo" nl [: 10 20 ;] push-mark-by -> }t
t{ "foo" nl find-mark -> 10 20 true }t
t{ nl drop-mark-all  "foo" nl find-mark -> false }t

t{ wg{ }wg -> }t
t{ wg{ wg{ }wg }wg -> }t

t{ [: wg{  label( a )  }wg ;] execute -> }t

t{ [: 2 wg{ label( a ) dup if 1- goto( a ) then  }wg ;] execute -> 0 }t


t{ [:
  wg{
    0 3  label( a )
    dup 2 = if  10 0 d+ goto( b ) then   20 0 d+
    dup 1 = if 100 0 d+ goto( b ) then  200 0 d+
    dup 0 = if exit then
    label( b ) 1- goto( a )
}wg ;] execute -> 570 0 }t


.( \ All tests in "goto.test.fth" are passed ) cr
