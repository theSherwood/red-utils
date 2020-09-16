Red [
	description: {
		Misc Wolfram-Language-inspired utilites
	}
]

factorial: function [n][acc: 1 repeat i n [acc: i * acc] acc]
!: :factorial

context [
	set 'max* function[list][
		either series? first list [
			maximum: first first list
			foreach l list [
				foreach i l [maximum: max maximum i]
			]
		][
			maximum: first list
			foreach i list [maximum: max maximum i]
		]
		maximum
	]
	set 'min* function[list][
		either series? first list [
			minimum: first first list
			foreach l list [
				foreach i l [minimum: min minimum i]
			]
		][
			minimum: first list
			foreach i list [minimum: min minimum i]
		]
		minimum
	]
]

context [
	debugging: false
	set 'debug-random function [
		"Provide the random function with a predictable seed (or not)"
		bool
	][
		either bool [previous: 1 debugging: true][previous: get-time debugging: false]
	]

	; The reseed function gets called at the beginning of every random utility call,
	; unless that utility is called with '/seed
	get-time: does [t: now/time/precise t/second]
	previous: get-time
	reseed: does [random/seed previous: either debugging [
			previous + 1
		][
			mod previous * get-time 10000
		]
	]

	set 'random-integer function [
		"Default behavior returns a 0 or 1. Automatically seeded."
		/seed
			value "Value for seeding 'random"
		/max
			maximum [integer!] "0 (inclusive) to maximum (exclusive)"
		/between
			range [block!] "min (inclusive) to max (exclusive)"
		/list
			range' [block!] "min (inclusive) to max (exclusive)"
			n [integer!] "The length of the list to produce"
	][
		either seed [random/seed value][reseed]
		case [
			max [-1 + random maximum]
			between [range/1 - 1 + random range/2 - range/1]
			list [
				collect [repeat i n [keep random-integer/between range']]
			]
			true [-1 + random 2]
		]
	]

	set 'random-logic function [
		"Returns true or false. Automatically seeded."
		/seed
			value "Value for seeding 'random"
		/list
			n [integer!] "The length of the list to produce"
	][
		either seed [random/seed value][reseed]
		either list [
			collect [repeat i n [keep random-logic]]
		][
			to-logic do random/only [true false]
		]
	]
]
