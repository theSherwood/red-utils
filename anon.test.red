Red []

#include %anon.red
#include %test-framework.red

suite "function" [
	
	test "1 arg" [
		f: .[. + 3]
		assert equal? 3 f 0
		assert equal? 30 f 27
		assert equal? 276 f 273
	]

	test "multiple args" [
		f: .[./1 * ./2 + 3]
		assert equal? 23 f [10 2]
		assert equal? 29 f [13 2]
	]

]
