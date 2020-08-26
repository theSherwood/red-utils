Red [
	author: [@theSherwood "Adam Sherwood"]
	purpose: {
		Simple functional style utils for series
	}
]

; https://github.com/9214/daruma/blob/master/src/utils.red
map: function [
	series fn
	/into
		buffer
][
	result: either into [buffer][to type? series []]
	foreach elem series [
		append result fn elem
	]
	result
]

filter: function [
	series fn
	/into
		buffer
][
	result: either into [buffer][to type? series []]
	foreach elem series [
		if fn elem [append result elem]
	]
	result
]

fold: function [
	series fn
	/init
		val
][
	either init [
		accumulator: val s: series
	][
		accumulator: first series s: next series
	]
	foreach elem s [
		accumulator: fn accumulator elem
	]
	accumulator
]

; a: [3 4 5 6 7 8]
; b: "bcdefghij"

; probe fold a func[acc v][acc + v]
; probe fold a func[acc v][either odd? acc [acc + 1][acc + v]]

; probe map [2 3 4] func[a][a * 2]
; probe map "abc" func[a][rejoin [a "."]]

; probe filter [2 3 4] func [v][even? v]
; probe filter a func [v][even? v]
