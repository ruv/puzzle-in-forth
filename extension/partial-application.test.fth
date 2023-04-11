
include ../lib/compat.fth

require-word npart ./partial-application.fth

\ require-word t{   tester.f


t{ 11 pool-idle push-list -> }t
t{ pool-idle pop-list -> 11 }t

t{ 123 ' noop >cons (build-thunk) execute -> 123 }t

t{ build-pool-item cons> swap cons> nip swap cons> -> 0 0 0 }t

t{ 10 [: 20 ;] ' noop build-pool-item configure-pool-item* cdr cdr execute -> 10 20 }t

t{ here find-pool-item -> 0 }t

t{ pool-idle pop-list cdr cdr  find-pool-item nip -> -1 }t

t{ 10 [: 20 ;] [: 30 ;] hire-thunk dup execute rot release-thunk -> 10 20 10 30 }t

t{ 10 [: 20 ;] 1part dup execute rot free-part -> 10 20 }t

t{ 20 10 2 ' noop npart dup execute rot free-part -> 20 10 }t


.( \ All tests in "apply-part.test.fth" are passed ) cr
