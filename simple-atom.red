Red []

atom: function [val][
	f: function [
		/set
			newVal
	][
		data: [0]
		if set [poke data 1 newVal]
		first data
	]
	f/set val
	:f
]