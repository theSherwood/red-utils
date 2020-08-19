Red []

#include %series.red
#include %test-framework.red

set-test-verbosity 1

suite "block series, no index, 1 for, no if" [
	test "series as word" [
		a: [5 6 7]
		assert equal? series [a-elem for a-elem in a] a
		assert equal? series/into [a-elem for a-elem in a] "" "567"
		assert equal? series [reduce [a-elem] for a-elem in a] [5 6 7]
		assert equal? series/only [reduce [a-elem] for a-elem in a] [[5] [6] [7]]
		unset 'a
	]
	test "series inlined" [
		assert equal? series [a-elem for a-elem in [5 6 7]] [5 6 7]
		assert equal? series/into [a-elem for a-elem in [5 6 7]] "" "567"
		assert equal? series [reduce [a-elem] for a-elem in [5 6 7]] [5 6 7]
		assert equal? series/only [reduce [a-elem] for a-elem in [5 6 7]] [[5] [6] [7]]
	]
]

suite "block series, with index, 1 for, no if" [
	test "series as word" [
		a: [5 6 7]
		assert equal? series [rejoin [a-elem a-idx] for a-elem a-idx in a] ["51" "62" "73"]
		assert equal? series/into [rejoin [a-elem a-idx] for a-elem a-idx in a] "" "516273"
		assert equal? series [reduce [a-elem a-idx] for a-elem a-idx in a] [5 1 6 2 7 3]
		assert equal? series/only [reduce [a-elem a-idx] for a-elem a-idx in a] [[5 1] [6 2] [7 3]]
		unset 'a
	]
	test "series inlined" [
		assert equal? series [rejoin [a-elem a-idx] for a-elem a-idx in [5 6 7]] ["51" "62" "73"]
		assert equal? series/into [rejoin [a-elem a-idx] for a-elem a-idx in [5 6 7]] "" "516273"
		assert equal? series [reduce [a-elem a-idx] for a-elem a-idx in [5 6 7]] [5 1 6 2 7 3]
		assert equal? series/only [reduce [a-elem a-idx] for a-elem a-idx in [5 6 7]] [[5 1] [6 2] [7 3]]
	]
]

suite "string series, no index, 1 for, no if" [
	test "series as word" [
		a: "abc"
		assert equal? series [a-elem for a-elem in a] a
		assert equal? series/into [a-elem for a-elem in a] [] [#"a" #"b" #"c"]
		assert equal? series/into [reduce [a-elem] for a-elem in a] [] [#"a" #"b" #"c"]
		assert equal? series/into/only [reduce [a-elem] for a-elem in a] [] [[#"a"] [#"b"] [#"c"]]
		unset 'a
	]
	test "series inlined" [
		assert equal? series [a-elem for a-elem in "abc"] "abc"
		assert equal? series/into [a-elem for a-elem in "abc"] [] [#"a" #"b" #"c"]
		assert equal? series/into [reduce [a-elem] for a-elem in "abc"] [] [#"a" #"b" #"c"]
		assert equal? series/into/only [reduce [a-elem] for a-elem in "abc"] [] [[#"a"] [#"b"] [#"c"]]
	]
]

suite "string series, with index, 1 for, no if" [
	test "series as word" [
		a: "abc"
		assert equal? series [rejoin [a-elem a-idx] for a-elem a-idx in a] "a1b2c3"
		assert equal? series/into [rejoin [a-elem a-idx] for a-elem a-idx in a] [] ["a1" "b2" "c3"]
		assert equal? series/into [reduce [a-elem a-idx] for a-elem a-idx in a] [] [#"a" 1 #"b" 2 #"c" 3]
		assert equal? series/into/only [reduce [a-elem a-idx] for a-elem a-idx in a] [] 
			[[#"a" 1] [#"b" 2] [#"c" 3]]
		unset 'a
	]
	test "series inlined" [
		assert equal? series [rejoin [a-elem a-idx] for a-elem a-idx in "abc"] "a1b2c3"
		assert equal? series/into [rejoin [a-elem a-idx] for a-elem a-idx in "abc"] [] ["a1" "b2" "c3"]
		assert equal? series/into [reduce [a-elem a-idx] for a-elem a-idx in "abc"] [] [#"a" 1 #"b" 2 #"c" 3]
		assert equal? series/into/only [reduce [a-elem a-idx] for a-elem a-idx in "abc"] [] 
			[[#"a" 1] [#"b" 2] [#"c" 3]]
	]
]

suite "if clauses" [
	test "block, 1 for" [
		a: [5 6 7 8]
		assert equal? series [a-elem * 2 for a-elem in a if even? a-elem] [12 16]
		unset 'a
	]
	test "block, index, 1 for" [
		a: [5 6 7 8]
		assert equal? series [a-elem * a-idx for a-elem a-idx in a if even? a-elem] [12 32]
		assert equal? series [a-elem * a-idx for a-elem a-idx in a if even? a-elem + a-idx] [5 12 21 32]
		unset 'a
	]
]

suite "2 for" [
	test "block" [
		a: [5 6 7]
		b: [1 -1 2]
		assert equal? series [a-elem * b-elem for a-elem in a for b-elem in b] [5 -5 10 6 -6 12 7 -7 14]
		unset [a b]
	]
	test "block, if clause" [
		a: [5 6 7]
		b: [1 -1 2]
		assert equal? series [a-elem * b-elem for a-elem in a for b-elem in b if even? a-elem + b-elem]
			[5 -5 12 7 -7]
		unset [a b]
	]
	test "mixed series, if clause" [
		a: [5 6 7]
		b: "abc"
		assert equal? series [rejoin [a-elem b-elem] for a-elem in a for b-elem in b if odd? a-elem]
			["5a" "5b" "5c" "7a" "7b" "7c"]
		assert equal? series [rejoin [a-elem b-elem] for b-elem in b for a-elem in a if odd? a-elem]
			"5a7a5b7b5c7c"
		assert equal? series/into [rejoin [a-elem b-elem] for b-elem in b for a-elem in a if odd? a-elem] []
			["5a" "7a" "5b" "7b" "5c" "7c"]
		unset [a b]
	]
]

suite "for by 2" [
	test "simple" [
		a: [5 6 7 8]
		b: "abcdefghijklmno"
		assert equal? series [a1 * a2 for [a1 a2] in a] [30 56]
		assert equal? series [rejoin ["." b1 b2 b3] for [b1 b2 b3] in b] ".abc.def.ghi.jkl.mno"
		unset [a b]
	]
	test "with index" [
		a: [5 6 7 8]
		b: "abcdefghijklmno"
		assert equal? series [a1 * a2 + a-idx for [a1 a2] a-idx in a] [32 60]
		assert equal? series [rejoin [b1 b2 b3 b-idx] for [b1 b2 b3] b-idx in b]
			"abc3def6ghi9jkl12mno15"
		unset [a b]
	]
	test "with index, if clause" [
		a: [5 6 7 8]
		b: "abcdefghijklmno"
		assert equal? series [
			a1 * a2 + a-idx
			for [a1 a2] a-idx in a
			if a1 * a2 > 40
		] [60]
		assert equal? series [
			rejoin [b1 b2 b3 b-idx]
			for [b1 b2 b3] b-idx in b
			if even? b-idx
		] "def6jkl12"
		unset [a b]
	]
]

suite "complex - all the fixin's" [
	test "mixed series, with index, if clause" [
		a: [5 6 7 8]
		b: "abcdefghijklmno"
		c: [12 13 14]
		assert equal? series [
			rejoin [(a1 * a2 + b-idx) b2]
			for [a1 a2] a-idx in a
			for [b1 b2 b3] b-idx in b
			if even? a1 * b-idx
		] ["36e" "42k" "62e" "68k"]
		assert equal? series/into [
			rejoin [(a1 * a2 + b-idx) b2]
			for [a1 a2] a-idx in a
			for [b1 b2 b3] b-idx in b
			if even? a1 * b-idx
		] "" "36e42k62e68k"
		; assert equal? series [
		; 	rejoin [b1 b2 b3 b-idx]
		; 	for [b1 b2 b3] b-idx in b
		; 	for [a1 a2] a-idx in a
		; 	for c c-idx in c
		; 	if even? b-idx
		; ] "def6jkl12"
		unset [a b c]
	]
]
