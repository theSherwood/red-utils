Red []

context [
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
