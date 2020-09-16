Red []

context [
	id: function [i][:i]
	zip: function [
		a b
		/all
		/left
		/right
		/map
			transform-a
			transform-b
	][
		m: case [
			all [max length? a length? b]
			left [length? a]
			right [length? b]
			true [min length? a length? b]
		]
		collect compose/deep [
			repeat i m [
				(either map [
					[keep transform-a a/:i keep transform-b b/:i]
				][
					[keep a/:i keep b/:i]
				])
			]
		]
	]

	; set 'variadic function [
	; 	spec [block!]
	; 	body [block!]
	; ][
	; 	function [args] compose/deep [
	; 		do zip/left/map [(spec)] args :to-set-word :id
	; 		do [(body)]
	; 	]
	; ]

	set 'fn function [
		spec [block!]
		body [block!]
		/local
			&
			&-template
	][
		&-template: if equal? #"&" first to-string &: to-lit-word last spec [
			compose [(to-set-word &) copy skip args (-1 + length? spec)]
		]
		function compose [args /local & (spec)] compose/deep [
			set [(spec)] args
			(&-template)
			(body)
		]
	]
]
