Red []

#include %compare.red
#include %../test-framework.red

suite "= == => <> > >= < <=" [

	test "= == =? <>" [
		assert compare [1 = 1 = 1.0 = to-integer "1"]
		assert not compare [1 = 1 == 1.0 = to-integer "1"]
		assert compare [1 = 1 - 2 - 1 + 3 = 1.0 ]
		assert compare [b: 1 = 1 =? b = to-integer "1"]
		assert not compare [b: 1 = 1 =? b == to-float "1"]
		assert compare [1 == 1 = 1.0 <> 1.1]
	]

	test "> >= < <=" [
		assert compare [1 < 2 < 3 < 4]
		assert compare [1 < 2 < 3 < 4 > 3 > 2 > 1 > 0]
		assert not compare [1 < 2 < 3 < 4 < 3]
		assert compare [1 >= 1 > 0.8 + 0.1 < 3 <= 3.1]
		assert not compare [1 >= 1 > 0.8 + 0.1 < 3 - (3 * 1) <= 3.1]
	]

	test "variables" [
		a: 3 b: 5
		assert compare [a < b < a * 2]
		assert compare [c: a - 1 < b < a * 2 <= c * 6]
	]

]