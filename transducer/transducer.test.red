Red []

#include %transducer.red
#include %../test-framework.red

set-test-verbosity 1

suite "map'" [
	test "inline" [
		a: [5 6 7 8 9 10]
		assert equal? 
			[7 8 9 10 11 12] 
			transduce [
				map' func [a][a + 2]
			] :append a
		assert equal? 
			[14 16 18 20 22 24] 
			transduce [
				map' func [a][a + 2]
				map' func [a][a * 2]
			] :append a
		assert equal? 
			[12 14 16 18 20 22] 
			transduce [
				map' func [a][a * 2]
				map' func [a][a + 2]
			] :append a
		assert equal? a [5 6 7 8 9 10]
		unset 'a
	]
	test "get-word! func" [
		a: [5 6 7 8 9 10]
		add-2:  func [a][a + 2]
		mult-2: func [a][a * 2]
		assert equal? 
			[7 8 9 10 11 12] 
			transduce [
				map' :add-2
			] :append a
		assert equal? 
			[14 16 18 20 22 24] 
			transduce [
				map' :add-2
				map' :mult-2
			] :append a
		assert equal? 
			[12 14 16 18 20 22] 
			transduce [
				map' :mult-2
				map' :add-2
			] :append a
		assert equal? a [5 6 7 8 9 10]
		unset 'a
	]
]

suite "filter'" [
	test "inline" [
		a: [5 6 7 8 9 10]
		assert equal? 
			[5 7 9] 
			transduce [
				filter' func [a][odd? a]
			] :append a
		assert equal? 
			[7 9] 
			transduce [
				filter' func [a][odd? a]
				filter' func [a][a > 6]
			] :append a
		assert equal? a [5 6 7 8 9 10]
		unset 'a
	]
	test "get-word! func" [
		a: [5 6 7 8 9 10]
		is-odd?: func [a][odd? a]                ; Currently no support for native!
		over-6?: func [a][a > 6]
		assert equal? 
			[5 7 9] 
			transduce [
				filter' :is-odd?
			] :append a
		assert equal? 
			[7 9] 
			transduce [
				filter' :is-odd?
				filter' :over-6?
			] :append a
		assert equal? a [5 6 7 8 9 10]
		unset 'a
	]
]

suite "take' and drop'" [
	test "take'" [
		a: [5 6 7 8 9 10]
		assert equal? [5 6 7] transduce [take' 3] :append a
		assert equal? [5 6 7 8 9 10] transduce [take' 30] :append a
		assert equal? a [5 6 7 8 9 10]
		unset 'a
	]
	test "drop'" [
		a: [5 6 7 8 9 10]
		assert equal? [8 9 10] transduce [drop' 3] :append a
		assert equal? [] transduce [drop' 30] :append a
		assert equal? a [5 6 7 8 9 10]
		unset 'a
	]
	test "together" [
		a: [5 6 7 8 9 10 11 12 13 14 15]
		assert equal?
			[11]
			transduce [
				drop' 3 take' 5 drop' 3 take' 1
			] :append a
		assert equal? a [5 6 7 8 9 10 11 12 13 14 15]
		unset 'a
	]
]

suite "map', filter', take', drop'" [
	test "together" [
		a: [5 6 7 8 9 10 11 12 13 14 15]
		under-13?: func [a][a < 14]
		mult-3: func [a][a * 3]
		over-24?: func [a][a > 24]
		assert equal?
			[33 36]
			transduce [
				drop' 2
				filter' :under-13?
				map' :mult-3
				filter' :over-24?
				drop' 2
				take' 2
			] :append a
		assert equal? a [5 6 7 8 9 10 11 12 13 14 15]
		unset 'a
	]
]

suite "transduce" [
	test "comp" [
		a: [5 6 7 8 9 10]
		b: [5 6 7 8 9 10 11 12 13 14 15]
		c: [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]

		mult-4:   func [a][a * 4]
		is-even?: func [a][even? a]
		transducer: comp [
			drop' 2
			filter' :is-even?
			map'    :mult-4
			take' 4
		]
		assert equal? [32 40] transduce :transducer :append a
		assert equal? [32 40 48 56] transduce :transducer :append b
		assert equal? [16 24 32 40] transduce :transducer :append c
		assert equal? a [5 6 7 8 9 10]
		assert equal? b [5 6 7 8 9 10 11 12 13 14 15]
		assert equal? c [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]
		unset 'a unset 'b unset 'c
	]
	test "/init - numeric aggregations" [
		a: [5 6 7 8 9 10 11 12 13 14 15]
		sum:  func [a b][a + b]
		mul: func [a b][a * b]
		min:  func [a b][either a < b [a][b]]

		mult-4:   func [a][a * 4]
		is-even?: func [a][even? a]
		transducer: comp [
			drop' 2
			filter' :is-even?
			map'    :mult-4
			take' 4
		]
		assert equal? 32 + 40 + 48 + 56 transduce/init :transducer :sum a 0
		assert equal? 32 * 40 * 48 * 56 transduce/init :transducer :mul a 1
		assert equal? 32                transduce/init :transducer :min a 99999
		assert equal? a [5 6 7 8 9 10 11 12 13 14 15]
		unset 'a
	]
	test "/init - strings" [
		a: [5 "6" 7 #"8" #"9" 10 11 "12" "13" "14" 15]

		transducer: comp [
			drop' 2
			filter' func [a][any[char? a string? a]]
			map'    func [a][rejoin [a "."]]
		]
		assert equal? "8.9.12.13.14." transduce/init :transducer :append a ""
		assert equal? a [5 "6" 7 #"8" #"9" 10 11 "12" "13" "14" 15]
		unset 'a
	]
]