Red []

#include %watch.red

context [
	dependencies: make hash! []

	ends-with: function [str sub-str] [
		parse str [thru sub-str end]
	]
	starts-with: function [str sub-str] [
		parse str [sub-str thru end]
	]

	resolve-relative-path: function [from relative] [
		base: first split-path from
		adjusted: case [
			starts-with relative %../ [copy skip relative 3]
			starts-with relative %./  [copy skip relative 2]
			starts-with relative %/   [return copy relative]
			true                      [copy relative]
		]
		to file! rejoin [base adjusted]
	]

	normalize-paths: function [from relative-files] [
		collect [	
			foreach f relative-files [
				keep resolve-relative-path from f
			]
		]
	]

	find-dependencies: function [file][
		if not ends-with file ".red" [exit]

		content: load file

		rules: [collect [some relative-files]]
		relative-files: compose [to (to issue! "include") issue! keep file!]

		set 'relative-paths parse content rules

		probe normalize-paths file relative-paths
	]

	set 'watch-deps func [][
		action: func [f][
			find-dependencies f
		]
		watch %. :action 1
	]
]

watch-deps