Red []

reduce*: function [
	coll
	reducer
	/into
		buffer
][
	accumulator: either into [buffer][to type? coll []]
	foreach i coll [
		accumulator: reducer accumulator i
	]
	accumulator
]

; map: function [acc item][append acc item + 1]
; filter: function [acc item][either item > 2 [append acc item][acc]]

; probe reduce* [1 2 3 4 5] :map
; probe reduce*/into [1 2 3 4 5] :map ""
; probe reduce* [1 2 3 4 5] :filter
; probe reduce*/into [1 2 3 4 5] :filter ""

mapping: function [transform][
	function [reduce*] compose/only [
		transform*: function (spec-of :transform) (body-of :transform)
		body: compose [
			(:reduce*) acc (:transform*) item
		]
		function [acc item] body
	]
]

a: mapping function [id][id]
b: a :reduce*
