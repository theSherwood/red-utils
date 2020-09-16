Red []

#include %wolfram.red
#include %../test-framework.red

set-test-verbosity 1

suite "factorial" [
	test "factorial" [
		assert equal? 6 factorial 3
		assert equal? 120 ! 5
		assert equal? 3628800 ! 10
		assert equal? 479001600 ! 12
	]
]

suite "min*, max*" [
	test "min*" [
		assert equal? 3 min* [5 3 8 7 4 8]
		assert equal? 3 min* [[5 3 8] [7 4 8]]
		assert equal? -10 min* [5 3 8 7 -10 8]
		assert equal? -10 min* [[5 3] [8 7] [-10 8 -9]]
	]
	test "max*" [
		assert equal? 9 max* [5 3 9 7 4 8]
		assert equal? 9 max* [[5 3 9] [7 4 8]]
		assert equal? 8 max* [5 3 2 7 -10 8]
		assert equal? 8 max* [[5 3] [2 7] [-10 8 -9]]
	]
]

suite "random-integer" [
	test "plain" [
		seed: 10
		assert equal? v: 1 random-integer/seed seed
		assert equal? v random-integer/seed seed
		assert equal? v random-integer/seed seed
		assert equal? v random-integer/seed seed
		unset 'v
	]
	test "max" [
		seed: 10
		assert equal? v: 7740 random-integer/seed/max seed 10000
		assert equal? v random-integer/seed/max seed 10000
		assert equal? v random-integer/seed/max seed 10000
		assert equal? v random-integer/seed/max seed 10000
		assert not equal? v v': random-integer/max 10000
		assert not equal? v' random-integer/max 10000
		unset 'v
	]
	test "between" [
		seed: 10
		assert equal? v: 77739 random-integer/seed/between seed 10000 100000
		assert equal? v random-integer/seed/between seed 10000 100000
		assert equal? v random-integer/seed/between seed 10000 100000
		assert equal? v random-integer/seed/between seed 10000 100000
		assert not equal? v v': random-integer/between 10000 100000
		assert not equal? v' random-integer/between 10000 100000
		unset 'v
	]
	test "list" [
		probe random-integer/list [2 5] 10
	]
]