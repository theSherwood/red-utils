Red [
	author: [@theSherwood "Adam Sherwood"]
	purpose: {
		A file watcher that tracks dependencies
	}
	license: 'BSD-3
	usage: {
		; A basic test-runner that will `do` files ending in ".test.red" 
		; whenever that file or a dependency of that file is saved

		watch-deps %. func [affected-files][
			foreach file affected-files [
				if parse file [thru ".test.red" end][
					print ""
					print file
					print ""
					do file
					print ""
					print "...I'm watching you, Wazowski. Always watching..."
				]
			]
		]
	}
	limitations: {
		Only tracks .red files
	}
]

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
			starts-with relative %../ [base: first split-path base copy skip relative 3 ]
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

	affected-files: copy []

	traverse-dependencies: function [file][
		if not find affected-files file [append affected-files file]
		dependents: dependencies/:file
		if dependents [
			foreach f dependencies/:file [
				traverse-dependencies f
			]
		]
	]

	set 'watch-deps func [
		dir [file!]
		"The directory to watch"
		action [function!] 
		{Triggered when 1 or more files is saved. Takes 1 arg: block of the changed files
		and any files within `dir` that depend on them.}
		/ignore
			fn [function!]
			{Takes 2 args: relative-path and full-path. Return true to ignore file. By default,
			files and directories beginning with '.' will be ignored.}
		/interval
			num [number!]
			"Daemon interval in seconds; defaults to 1"
	][
		watch-action: func [changed-files][
			affected-files: copy []
			if changed-files [
				foreach file changed-files [
					if not ends-with file ".red" [continue]
					update-dependencies file parse-dependencies file
				]
				foreach file changed-files [traverse-dependencies file]
			]

			action affected-files
		]

		case [
			all [ignore interval]         [watch/ignore/interval dir :watch-action :fn num]
			all [ignore not interval]     [watch/ignore dir :watch-action :fn]
			all [not ignore interval]     [watch/interval dir :watch-action num]
			all [not ignore not interval] [watch dir :watch-action]
		]
	]
]
