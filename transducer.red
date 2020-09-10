Red []

safeFn: function ['fn][
	either function? :fn [:fn]
]

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

; mapping: function [acc item][append acc item + 1]
; filtering: function [acc item][either item > 2 [append acc item][acc]]

; probe foldl :mapping [1 2 3 4 5]
; probe foldl/init :mapping [1 2 3 4 5] []
; probe foldl/init :mapping [1 2 3 4 5] ""
; probe foldl :filtering [1 2 3 4 5]
; probe foldl/init :filtering [1 2 3 4 5] []
; probe foldl/init :filtering [1 2 3 4 5] ""

; quit

pipe: function [fns [block!]][
	function [val] compose/only [
		foldl/init function [v f][f :v] reduce (fns) :val
		; foldl/init function [v f][v :f] reduce (fns) :val
	]
]
; pipe*: function [fns [block!]][
; 	foldl function [v f][f v] reduce (fns)
; ]

; comp: function [fns [block!]][
; 	function [coll][ 
; 		fn: pipe* fns function [acc item][
; 			append acc item
; 		]
; 		fn 
; 	]
; ]

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

; a: map function [id][id]
; b: a :reducer

id: function [id][id]
add-1: function [n][n + 1]
add-2: function [n][n + 2]

; fn: pipe [:id function [n][n + 1] :add-2]
; probe fn 3

a: [2 3 5 3 6 7 3 6 8 5 3]

fn: pipe [
	filter function [a][odd? a]
	map function [a][a + 2]
]
; probe foldl/init :fn a []
; probe fn a
; probe :fn

probe foldl/init fn function [acc i][append acc i] a []