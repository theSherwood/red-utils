Red []

suite: func[
	name [string!]
	body [block!]
][
	test-verbosity: either value? 'test-verbosity [test-verbosity][3]
	total-suite-assertions: 0
	passed-suite-assertions: 0

	if test-verbosity > 1 [print name]

	test-suite-failures: copy []
	do body

	if test-verbosity = 1 [
		either not empty? test-suite-failures [
			print ["** -" name]
			; foreach i test-suite-failures [
			; 	print ["    ** -" i]
			; ]
		][
			print ["ok -" name]
		]
	]
]

test: func[
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

	switch verbosity [
		1 [if all [failed value? 'test-suite-failures] [append test-suite-failures name]]
		2 [
			either failed [print ["    ** -" name]][print ["    ok -" name]]
		]
		3 [
			print ["    TEST --" name "--" assertion - length? failures "/" assertion]
			if failed [print ["        FAILED : [" failures "]"]]
		]
	]
]

test-verbosity: 1
suite "Sample Suite!" [

	test "Random Test!"
	[
		assert 1 = 1
		assert 1 = 2
		assert 4 = 5
	]
]