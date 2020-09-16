Red []

#include %variadic.red
#include %../test-framework.red

set-test-verbosity 1

suite "fn" [
	test "simple" [
		a: [9 8 7 6 5 4]
		f: fn [a b c][a]
		f': fn [a b c][b]
		f'': fn [a b c][c]
		f''': fn [a b c][args]
		assert 9 = f a
		assert 8 = f' a
		assert 7 = f'' a
		assert a = f''' a
		assert not value? '&
		assert not value? '&-template
		unset [a f f' f'' f''']
	]
	test "rest params" [
		a: [9 8 7 6 5 4]
		f: fn [a b &c][reduce [a b &c args]]
		assert [9 8 [7 6 5 4] [9 8 7 6 5 4]] = f a
		assert not value? '&
		assert not value? '&-template
		unset [a f]
	]
	test "too many args" [
		a: [9 8 7]
		f: fn [a b c d &e][reduce [a b c]]
		f': fn [a b c d &e][reduce [a b c d]]
		f'': fn [a b c d &e][reduce [a b c d &e]]
		f''': fn [a b c d &e][reduce [a b c d &e args]]
		assert [9 8 7] = f a
		assert (reduce [9 8 7 none]) = f' a
		assert (reduce [9 8 7 none []]) = f'' a
		assert (reduce [9 8 7 none [] [9 8 7]]) = f''' a
		assert not value? '&
		assert not value? '&-template
		unset [a f]
	]
]