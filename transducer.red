Red []

; todo : fix the fact that it's pipe is in reverse
; todo : take-while, drop-while
; todo : pass indices to map and filter, etc
; todo : handle op!
; todo : make map, filter, etc work on series too

foldl: function [
	reducer
	coll
	/init
		initial
][
	either init [accumulator: :initial c: coll][accumulator: :coll/1 c: next coll]
	
	; todo: handle op!
	foreach i c [
		accumulator: reducer :accumulator :i
	]
	:accumulator
]

pipe: function [fns [block!] /now arg][
	fn: function [val] compose/only [
		foldl/init function [v f][f :v] reduce (fns) :val
	]
	either now [fn :arg][:fn]
]

comp: function [fns [block!] /now arg][
	fn: function [val] compose/only [
		foldl/init function [v f][f :v] reverse reduce (fns) :val
	]
	either now [fn :arg][:fn]
]

transduce: function [transducer fn coll /init initial ][
	either block? :transducer [
		foldl/init comp/now transducer :fn coll 
		either init [:initial][to type? coll []]
	][
		foldl/init transducer :fn coll either init [:initial][to type? coll []]
	]
]

map: function [transform][
	function [reducer] compose/only [
		transform': function (spec-of :transform) (body-of :transform)
		body: compose [
			(:reducer) acc (:transform') item
		]
		function [acc item] body
	]
]

filter: function [predicate][
	function [reducer] compose/only [
		predicate': function (spec-of :predicate) (body-of :predicate)
		body: compose/deep [
			either (:predicate') item [(:reducer) acc item][acc]
		]
		function [acc item] body
	]
]

take: function [n][
	function [reducer] compose [
		n': (n)
		body: compose/deep [
			count: [0]
			n'': (n')
			poke count 1 count/1 + 1
			either count/1 <= n'' [(:reducer) acc item][acc]
		]
		function [acc item] body
	]
]

drop: function [n][
	function [reducer] compose [
		n': (n)
		body: compose/deep [
			count: [0]
			n'': (n')
			poke count 1 count/1 + 1
			either count/1 > n'' [(:reducer) acc item][acc]
		]
		function [acc item] body
	]
]

id: function [id][id]
add-1: function [n][n + 1]
add-2: function [n][n + 2]

a: [2 3 5 3 6 7 3 6 8 5 3]

fn: comp [
	filter function [a][odd? a]
	map function [a][a + 2]
]

probe transduce :fn :append a
probe transduce/init :fn :append a ""
probe transduce comp [
	filter function [a][odd? a]
	map function [a][a + 2]
] :append a
probe transduce [
	filter function [a][odd? a]
	map function [a][a + 2]
] :append a
probe transduce/init [
	filter function [a][a > 7]
	map function [a][a + 2]
] :append a ""
probe transduce [
	filter function [a][odd? a]
	take 4
	map function [a][a + 2]
] :append a
probe transduce [
	drop 2
	filter function [a][odd? a]
	take 4
	map function [a][a + 2]
] :append a
