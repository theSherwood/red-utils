Red [
	author: [@theSherwood "Adam Sherwood"]
	purpose: {
		Transducers allow for efficient functional programming over large collections.

		Rather than iterating over a collection multiple times to filter, map, etc.,
		transducers make it possible to iterate over the collection once without
		making intermediate collections that will simply be disposed of regardless
		of the number of transformations one makes.
	}
	license: 'BSD-3
	limitations: {
		Currently, the transduce function cannot take an op! as it's second argument.
		Similarly, map' and filter' cannot take native! as their arguments.

		foldl, which is used by transduce, can only handle series at this point. 
		If sequences, streams, generators, iterators, or other iterables come to exist,
		foldl will need to be updated to accommodate them. Fortunately, it is the
		only function that will need to be updated in order for transduce to 
		handle those other cases.
	}
]

;; UTILITIES

foldl: function [
	reducer
	coll
	/init
		initial
][
	either init [accumulator: :initial c: coll][accumulator: :coll/1 c: next coll]
	
	foreach i c either op? :reducer [
		[accumulator: :accumulator reducer :i]
	][
		[accumulator: reducer :accumulator :i]
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

;; TRANSDUCERS

map': function [transform [function!]][
	function [reducer] compose/only [
		transform': function (spec-of :transform) (body-of :transform)
		body: compose [
			(:reducer) acc (:transform') item
		]
		function [acc item] body
	]
]

filter': function [predicate [function!]][
	function [reducer] compose/only [
		predicate': function (spec-of :predicate) (body-of :predicate)
		body: compose/deep [
			either (:predicate') item [(:reducer) acc item][acc]
		]
		function [acc item] body
	]
]

take': function [n [integer!]][
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

drop': function [n [integer!]][
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

;; TRANSDUCER APPLICATION

transduce: function [
	transducer  [block! function!]
	fn          [function! native! action! routine!]
	coll        [series!]
	/init 
		initial [any-type!]
][
	either block? :transducer [
		foldl/init comp/now transducer :fn coll 
		either init [:initial][to type? coll []]
	][
		foldl/init transducer :fn coll either init [:initial][to type? coll []]
	]
]