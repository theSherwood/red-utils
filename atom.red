Red [
	; https://github.com/luwes/sinuous/blob/master/packages/sinuous/observable/src/observable.js
]

context [
	tracking: none

	set 'root function [fn][
		prev-tracking: tracking
		tracking: root-update: does[]
		reset-update root-update
		result: fn func [][unsubscribe root-update tracking: none]
		tracking: prev-tracking result
	]

	set 'sample function [fn][
		prev-tracking: tracking tracking: none
		value: fn
		tracking: prev-tracking value
	]

	set 'observable function [val][
		f: function [
			/set
				newVal
		][
			data: [0]
			observers: []
			either set [poke data 1 newVal][
				append observers tracking
				append tracking/observables f
			]
			first data
		]
		f/set val
		:f
	]

	set 'cleanup function [fn][
		if tracking [
			append tracking/cleanups :fn
		]
		:fn
	]

	set 'unsubscribe function [observer][
		_unsubscribe observer/update
	]

	_unsubscribe: function [update][
		foreach child update/children [unsubscribe child]
		
		; todo
		; foreach observables update/observables [function [0][
			; o/observers
		; ]]

		foreach cleanup update/cleanups [cleanup]
		reset-update update
	]

	_reset-update: function [update][
		update/observables: copy []
		update/children:    copy []
		update/cleanups:    copy []
	]
]
