Red []

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
		(if idx: word/2 [compose [(to-set-word idx) 0]])
		foreach [(word/1)] (range) [
			(if idx [compose [(to-set-word idx) (idx) + (either block? word/1 [length? word/1][1])]])
			(body)
		]
	]

    do foreach [range word] reverse ranges [body: compose/deep layer]
	result
]
