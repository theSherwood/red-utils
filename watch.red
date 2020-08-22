Red []

watch: function [dir action interval][
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
				either dir? full-path [
					if not #"." = first relative-path  [
						collect-files full-path results
					]
				][
					append results reduce [full-path ts: query full-path]
					compare full-path ts
				]
			]
			if top [watched-files: results]
		]
	]

	dir: normalize-dir dir

	watcher/collect-files/top dir copy []

	forever [
		wait interval
		watcher/collect-files/top dir copy []
	]
]
