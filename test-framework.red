Red []

context [
	test-verbosity: 3

	width: 60
	char: #"."
	format-log: func [
		body [block!]
		/local total pos padding-pos diff
	][
		total: 0
		pos: 0
		body-copy: copy body
		foreach i body-copy [
			pos: pos + 1
			either i = 'padding [padding-pos: pos][
				either word? i [
					string: form get i
				][
					string: form i
				]
				total: total + length? string
				poke body-copy pos string
			]
		]
		total: total + pos - 1
		poke body-copy padding-pos pad/with copy "" width - total char
		form body-copy
	]

	set 'set-test-verbosity func [v][test-verbosity: v]

	set 'suite func [
		name [string!]
		body [block!]
	][
		total-suite-assertions: 0
		passed-suite-assertions: 0

		if test-verbosity > 1 [print name]

		do body

		if test-verbosity = 1 [
			either passed-suite-assertions < total-suite-assertions [
				print format-log [
					"** -" name padding passed-suite-assertions "/" total-suite-assertions
				]
			][
				print format-log [
					"ok -" name padding passed-suite-assertions "/" total-suite-assertions
				]
			]
		]
	]

	set 'test func [
		name [string!]
		body [block!]
		/local assert pos failures assertion verbosity failed
	][
		assertion: 0
		failures: copy []
		assert: func [v [logic!]] [assertion: assertion + 1 unless v [append failures assertion] ]
		parse body rule: [
			any [pos: ['assert | 'failures] (pos/1: bind pos/1 'assert) | any-string! | binary! | into rule | skip]
		] 
		do body

		verbosity: either value? 'test-verbosity [test-verbosity][3]
		failed: not empty? failures

		if value? 'total-suite-assertions [
			total-suite-assertions: total-suite-assertions + assertion
			passed-suite-assertions: passed-suite-assertions + assertion - length? failures
		]

		if verbosity > 1 [
			print format-log compose [
				(pick ["  ** -" "  ok -"] failed) name padding (assertion - length? failures) "/" assertion
			]
		]
		if verbosity = 3 [
			if failed [print format-log ["    FAILED ASSERTIONS" padding "[" failures "]"]]
		]
	]
]
