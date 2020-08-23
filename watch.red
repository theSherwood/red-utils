Red []

watch: function [
	dir 
	action "Takes 1 arg: the full path of the changed file"
	/ignore
		fn "Takes 2 args: relative-path and full-path. Return true to ignore file"
	/interval
		num
][
	if not ignore [fn: func [r f][#"." = first r]] ; Default: ignore files and dirs that start with `.`

	watcher: context [
		watched-files: []

		join-path: func [base path][
			to-red-file rejoin [base path]
		]

		normalize-paths: func [dir][
			collect [
				foreach path read dir [
					keep path
					keep join-path dir path
				]
			]
		]

		compare: func [file ts][
			old-ts: select watched-files file
			if any [old-ts = none ts > old-ts] [
				action file
			]
		]

		collect-files: func [dir results /top /local contents ts][
			contents: normalize-paths dir
			foreach [relative-path full-path] contents [
				if not all [ignore fn relative-path full-path]  [
					either dir? full-path [
							collect-files full-path results
					][
						append results reduce [full-path ts: query full-path]
						compare full-path ts
					]
				]
			]
			if top [watched-files: results]
		]
	]

	dir: normalize-dir dir

	watcher/collect-files/top dir copy []

	forever [
		wait either interval [num][1]
		watcher/collect-files/top dir copy []
	]
]
