Red [
	author: [@theSherwood "Adam Sherwood"]
	notes: {
		This code makes liberal use of Vladimir Vasilyev's list comprehension demo at https://stackoverflow.com/questions/59706298/a-compiler-for-list-comprehension-in-rebol. Much of the code is, in fact, his. I simply made a few adjustments to support indices, an output buffer, and some minor syntactic changes.
	}
]

series: function [
	"Series comprehension"
	spec [block!]
	/only
	/into
	buffer [series!]
][
	#1
	set-builder: [collect [expression collect some generator predicate]]
	expression:  [keep to 'for]
	generator:   ['for keep copy words to 'in 'in keep copy range to [ 'for | 'if | end ]]
	predicate:   [keep to end]

	set [expression ranges: clause:] parse spec set-builder

	#2
	result: either into [buffer][to type? do ranges/2 []]
	body: compose/deep [(any [clause 'do]) [(pick [append/only append] only) result (expression)]]
	layer: [
		(if idx: words/2 [compose [(to-set-word idx) 0]])
		foreach [(words/1)] (range) [
			(if idx [compose [
				(to-set-word idx) (idx) + (either block? words/1 [length? words/1][1])
			]])
			(body)
		]
	]

	do foreach [range words] reverse ranges [body: compose/deep layer]
	result
]
