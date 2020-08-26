Red []

#include %watch/watch-deps.red

watch-deps %. func [affected-files][
	foreach file affected-files [
		if parse file [thru ".test.red" end][
			print file
			print ""
			do file
			print ""
		]
	]
	if not zero? length? affected-files [
		print "...I'm watching you, Wazowski. Always watching..."
	]
]