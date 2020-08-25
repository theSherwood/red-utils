Red [
	author: [@theSherwood "Adam Sherwood"]
	purpose: {
		A vanilla file watcher
	}
	license: 'BSD-3
	usage: {
		; EXAMPLE 1
		; Watches files within `%.` and prints the absolute file name whenever
		; a file is saved. The daemon loops on a 3 second interval.
		watch/interval %. print 3

		;EXAMPLE 2
		; Watches files within `%foo` and prints the absolute file name whenver
		; a file is saved. Ignores all nested directories and their contents.
		watch/ignore %foo print func[r a][dir? a] 
	}
]

watch: function [
	dir [file!]
	"The directory to watch"
	action [function!]
	"Triggered when 1 or more files is saved. Takes 1 arg: block of the changed files."
	/ignore
		fn [function!]
		"Takes 2 args: relative-path and absolute-path. Return true to ignore file. By default,
		files and directories beginning with '.' will be ignored."
	/interval
		num [number!]
		"Daemon interval in seconds; defaults to 1"
][
	if not ignore [fn: func [r a][#"." = first r]] ; Default: ignore files and dirs that start with `.`

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
			foreach [relative-path absolute-path] contents [
				if not all [value? 'fn fn relative-path absolute-path]  [
					either dir? absolute-path [
						collect-files absolute-path results
					][
						append results reduce [absolute-path ts: query absolute-path]
						if compare absolute-path ts [append changed-files absolute-path]
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
