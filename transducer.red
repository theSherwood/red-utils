Red []

foldl: function [
	reducer
	coll
	/init
		initial
][
	either init [accumulator: :initial c: coll][accumulator: coll/1 c: next coll]
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

transduce: function [transducer fn coll /init initial ][
	either block? :transducer [
		foldl/init pipe/now transducer :fn coll 
		either init [:initial][to type? coll []]
	][
		foldl/init transducer :fn coll either init [:initial][to type? coll []]
	]
]

map: function [transform][
	function [reducer] compose/only [
		transform*: function (spec-of :transform) (body-of :transform)
		body: compose [
			(:reducer) acc (:transform*) item
		]
		function [acc item] body
	]
]

filter: function [predicate][
	function [reducer] compose/only [
		predicate*: function (spec-of :predicate) (body-of :predicate)
		body: compose/deep [
			either (:predicate*) item [(:reducer) acc item][acc]
		]
		function [acc item] body
	]
]

id: function [id][id]
add-1: function [n][n + 1]
add-2: function [n][n + 2]

a: [2 3 5 3 6 7 3 6 8 5 3]

fn: pipe [
	filter function [a][odd? a]
	map function [a][a + 2]
]

; probe foldl/init fn function [acc i][append acc i] a []
; probe foldl/init fn :append a []
probe transduce :fn :append a
probe transduce/init :fn :append a ""
probe transduce pipe [
	filter function [a][odd? a]
	map function [a][a + 2]
] :append a
probe transduce [
	filter function [a][odd? a]
	map function [a][a + 2]
] :append a
probe transduce/init [
	filter function [a][odd? a]
	map function [a][a + 2]
] :append a ""