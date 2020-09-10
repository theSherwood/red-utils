Red []

foldl: function [
	f
	coll
	/init
		initial
][
	either init [accumulator: initial c: coll][accumulator: coll/1 c: next coll]
	foreach i c [
		accumulator: f accumulator either function? :i [:i][i]
	]
	accumulator
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
	function [val] compose/only [foldl/init function [v f][f v] reduce (fns) val]
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
		body: compose [
			either (:predicate*) item [(:reducer) acc item][acc]
		]
		function [acc item] body
	]
]

; a: map function [id][id]
; b: a :reducer

id: function [id][probe id]
add-1: function [n][n + 1]
add-2: function [n][n + 2]

probe fn: pipe [:id function [n][n + 1] :add-2]
probe fn 3
