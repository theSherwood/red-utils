Red []

;; Variant 1

; https://github.com/9214/daruma/blob/master/src/utils.red
map: function [
	series spec body
	/into
		buffer
][
	f: func spec body
	result: either into [buffer][to type? series []]
	foreach :spec series [
		append result do compose [(:f) (:spec)]
	]
	result
]

probe map [2 3 4] [a][a * 2]
probe map "abc" [a][rejoin [a "."]]

;; Variant 2

map2: function [
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

probe map2 [2 3 4] func[a][a * 2]
probe map2 "abc" func[a][rejoin [a "."]]