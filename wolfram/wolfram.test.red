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
		unset [v seed]
	]
	test "max" [
		seed: 10
		
		; Inclusive min, exclusive max
		assert equal? 1 random-integer/seed/max seed 2
		assert equal? 0 random-integer/seed/max 11 2

		; Consistent when consistently seeded
		assert equal? v: 7739 random-integer/seed/max seed 10000
		assert equal? v random-integer/seed/max seed 10000
		assert equal? v random-integer/seed/max seed 10000
		assert equal? v random-integer/seed/max seed 10000

		; Inconsistent when not seeded
		assert not equal? v v': random-integer/max 10000
		assert not equal? v' random-integer/max 10000
		unset [v seed]
	]
	test "between" [
		seed: 10

		; Consistent when consistently seeded
		assert equal? v: 77739 random-integer/seed/between seed [10000 100000]
		assert equal? v random-integer/seed/between seed [10000 100000]
		assert equal? v random-integer/seed/between seed [10000 100000]
		assert equal? v random-integer/seed/between seed [10000 100000]

		; Inconsistent when not seeded
		assert not equal? v v': random-integer/between [10000 100000]
		assert not equal? v' random-integer/between [10000 100000]
		unset [v seed]
	]
	test "list" [
		list: random-integer/list [2 5] 100
		assert equal? 2 min* list
		assert equal? 4 max* list
		unset 'list
	]
]

suite "random-logic" [
	test "plain" [
		seed: 10
		seed': 11
		assert equal? v: false random-logic/seed seed
		assert equal? v random-logic/seed seed
		assert equal? v random-logic/seed seed
		assert equal? v random-logic/seed seed
		assert equal? v: true random-logic/seed seed'
		assert equal? v random-logic/seed seed'
		assert equal? v random-logic/seed seed'
		assert equal? v random-logic/seed seed'
		unset [v seed seed']
	]
	test "list" [
		contains: function [series item][to-logic find series item]
		list: random-logic/list 100
		assert contains list true
		assert contains list false
		unset [contains list]
	]
]