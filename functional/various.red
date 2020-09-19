Red []

#include %fn.red

context [
	set 'λ function [body [block!]][function [&] body]

	set 'map function [
		f coll 
		/into
			buffer [series!]
	][
		result: either into [buffer][to type? coll []]
		foreach i coll [
			append result f i
		]
		result
	]

	; Need to think about symbols
	; Also, this is not ideal because the op! binds more tightly than the function.
	; So the function will have to be wrapped in parens, which seems to undermine
	; the point.
	set '.m make op! function [f coll][
		result: to type? coll []
		foreach i coll [
			append result f i
		]
		result
	]
	
	set 'filter function [
		f coll 
		/into
			buffer [series!]
	][
		result: either into [buffer][to type? coll []]
		foreach i coll [
			if f i [append result i]
		]
		result
	]

	set '.f make op! function [f coll][
		result: to type? coll []
		foreach i coll [
			if f i [append result i]
		]
		result
	]

	set 'exe function [f arg][f arg]
	; Not terribly useful
	set 'of make op! :exe

	; Limited utility on account of red functions not being variadic
	set 'apply function [f coll][do compose [f (coll)]]

	; variadic
	set 'range-v fn [m m' step][
		result: copy []
		if none? m' [m': m m: 1]
		do compose/deep [
			while [m <= m'][
				append result m
				m: m + (either step [step][1])
			]
		]
		result
	]

	set 'range function [args][
		result: copy []
		either 1 = length? args [m: 1 m': args/1][m: args/1 m': args/2]
		do compose/deep [
			while [m <= m'][
				append result m
				m: m + (either args/3 [args/3][1])
			]
		]
		result
	]

	; This only covers the simplest case
	set 'array function [f n][collect [repeat i n [keep f i]]]

	; set 'multiples function [expr n][return collect [loop n [keep expr]]]

	; Just beginning...
	set 'table fn [expr binding &bindings][
		either block? binding [
			case [
				2 = size? binding [
					either block? binding/2 [
						v: binding/1
						collect [foreach i binding/2 [set v i keep expr]]
					][
						v: binding/1
						collect [repeat i binding/2 [set v i keep expr]]
					]
				]
			]
		][
			collect [loop binding [keep expr]]
		]
	]
]

; a: λ[& + 1]
; b: func[x][x + 1]
; c: λ[b &]

; probe a 3
; probe c 100

; print map λ[& * 2] [1 2 3 4 5]
; print (λ[& + 3]) .m [1 2 3 4 5]

; print :odd? .f [1 2 3 4 5]
; print (λ[& > 2]) .f [1 2 3 4 5]

; print exe λ[& * 4] 10
; print (λ[& * 4]) of 10

; f: function [a b c][a + b + c]
; print apply :f [4 5 6] 

; print range [10]
; print range [3 11]
; print range [3 11 4]

; print array λ[& * & + 1] 10