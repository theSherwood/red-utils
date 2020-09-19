Red []

context [
	set 'fn function [
		"Defines a variadic function that can be called with a block of arguments"
		spec [block!]
		body [block!]
		/local
			&
			&-template
	][
		&-template: if equal? #"&" first to-string &: to-lit-word last spec [
			compose [(to-set-word &) copy skip args (-1 + length? spec)]
		]
		func compose [args /local (spec)] compose/deep [
			set [(spec)] args
			(&-template)
			(body)
		]
	]
]
