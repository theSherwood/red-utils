Red []

watch: function [
	dir [file!]
	action [function!] "Takes 1 arg: block of the changed files"
	/ignore
		fn [function!] "Takes 2 args: relative-path and full-path. Return true to ignore file"
	/interval
		num [number!] "In seconds, defaults to 1"
][
	if not ignore [fn: func [r f][#"." = first r]] ; Default: ignore files and dirs that start with `.`

	watcher: context [
		watched-files: copy []
		changed-files: copy []

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
			either any [old-ts = none ts > old-ts] [true][false]
		]

		collect-files: func [dir results /top /local contents ts][
			contents: normalize-paths dir
			foreach [relative-path full-path] contents [
				if not all [value? 'fn fn relative-path full-path]  [
					either dir? full-path [
						collect-files full-path results
					][
						append results reduce [full-path ts: query full-path]
						if compare full-path ts [append changed-files full-path]
					]
				]
			]
			if top [watched-files: results]
		]
	]

	dir: normalize-dir dir

	watcher/collect-files/top dir copy []
	action watcher/changed-files

	forever [
		wait either interval [num][1]
		watcher/changed-files: copy []
		watcher/collect-files/top dir copy []
		action watcher/changed-files
	]
]
