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
	get-time: does [t: now/time/precise t/second]
	previous: get-time
	reseed: does [random/seed previous: mod previous * get-time 10000]

	set 'random-integer function [
		/seed
			seed-val
		/max
			maximum
		/between
			min'
			max'
		/list
			range'
			n
	][
		either seed [random/seed seed-val][reseed]
		case [
			max [random maximum]
			between [min' - 1 + random max' - min']
			list [
				min'': pick range' 1
				max'': pick range' 2
				collect [repeat i n [keep random-integer/between min'' max'']]
			]
			true [-1 + random 2]
		]
	]
]