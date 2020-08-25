Red [
	author: [@theSherwood "Adam Sherwood"]
	purpose: {
		Python-inspired chained comparison operators
	}
	license: 'BSD-3
	usage: {
		; SIMPLE EXAMPLE
		compare [1 < 2 < 3 < 4]    ;== true

		; EXPRESSIONS
		compare [1 >= 1 > 0.8 + 0.1 < 3 <= 3.1]             ;== true
		compare [1 = 1 - 2 - 1 + 3 = 1.0 = to-integer "1"]  ;== true

		; VARIABLES
		assert compare [c: a - 1 < b < a * 2 <= c * 6]    ;== true
	}
]

compare: func [body][
	comparisons: [collect [some comparison]]
	comparison: [
		keep copy exp' to operator 
		keep operator 
		ahead keep copy exp'' to [operator | end]
	]
	operator: [ '= | '== | '=? | '<> | '> | '>= | '< | '<= ]
	
	foreach [operand1 op operand2] parse body comparisons [
		if not do compose [('do to-paren operand1) (op) ('do to-paren operand2)][return false]
	]
	return true
]

; probe compare [1 < 2 < 3 < 4]    ;== true
; probe compare [1 < 2 > 3 < 4]    ;== false
; probe compare [1 + 1 = 2 = 2.0 == to-float "2.0"] ;== true