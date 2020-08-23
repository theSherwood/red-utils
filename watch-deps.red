Red []

#include %watch.red

context [
	dependencies: #()

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

	parse-dependencies: function [file][
		content: load file

		rules: [collect [some relative-files]]
		relative-files: compose [to (to issue! "include") issue! keep file!]

		normalize-paths file parse content rules
	]

	update-dependencies: function [file deps][
		foreach d deps [
			dependents: dependencies/:d
			either dependents [
				if not find dependents file [
					append dependents file
				]
			][
				dependencies/:d: reduce [file]
			]
		]
	]

	traverse-dependencies: function [file affected-files][
		if not find affected-files file [append affected-files file]
		dependents: dependencies/:file
		if dependents [
			foreach f dependencies/:file [
				traverse-dependencies f affected-files
			]
		]
		affected-files
	]

	user-action: func [
		file
		changed-dependency
	][
		probe [file changed-dependency]
	]

	set 'watch-deps func [
		dir
		/ignore
			fn
		/interval
			num
	][
		watch-action: func [file][
			if not ends-with file ".red" [exit]
			update-dependencies file parse-dependencies file
			affected-files: traverse-dependencies file []
			
			; probe affected-files
			probe reduce [dependencies file]
		]

		case [
			all [ignore interval]         [watch/ignore/interval dir :watch-action :fn num]
			all [ignore not interval]     [watch/ignore dir :watch-action :fn]
			all [not ignore interval]     [watch/interval dir :watch-action num]
			all [not ignore not interval] [watch dir :watch-action]
		]
	]
]

watch-deps %.