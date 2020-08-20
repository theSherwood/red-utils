# Series Comprehensions

**Inspired by List Comprehensions in Python**

This code makes liberal use of Vladimir Vasilyev's list comprehension demo at https://stackoverflow.com/questions/59706298/a-compiler-for-list-comprehension-in-rebol. Much of the code is, in fact, his. I simply made a few adjustments to support indices, an output buffer, and some minor syntactic changes.

## Grammar

Not all of this is directly expressed in the code, but much of it is.

```
set-builder: [expression some generator predicate]
expression:  [to 'for]
generator:   ['for words to 'in 'in range to [ 'for | 'if | end ]]
predicate:   ['if to end]
words:       [[ block! | word! ] 0 1 word!]
range:       [[ series! | word! ]]
```

## Usage

**Basic**

```
a: [3 4 5]
b: "abc"

series [a' * 2 for a' in a]       ;== [6 8 10]
series [a' * 2 for a' in [3 4 5]] ;== [6 8 10]

series [rejoin [b' "."] for b' in b]     ;== "a.b.c."
series [rejoin [b' "."] for b' in "abc"] ;== "a.b.c."
```

**`/into`**

```
a: [3 4 5]
b: "abc"

series/into [a' * 2 for a' in a] ""
;== "6810"

series/into [rejoin [b' "."] for b' in b] []
;== ["a." "b." "c."]
```

**`/only`**

```
a: [3 4 5]

series [reduce [a'] for a' in a]
;== [3 4 5]

series/only [reduce [a'] for a' in a]
;== [[3] [4] [5]]
```

**`if` Clause**

```
a: [3 4 5]
series [a' for a' in a if odd? a'] ;== [3 5]
```

**With Index**

```
a: [3 4 5]
series [a' * idx for a' idx in a] ;== [3 8 15]
```

**Draw Multiple**

Similar to `foreach`.

```
a: [3 4 5 6]
series [a' + a'' for [a' a''] in a] ;== [7 11]
```

**Multiple Generators**

Each generator begins with `for`. Unless using `/into` the result type will be the same as the range type in the first generator.

```
a: [3 4 5]
b: "abc"

series [rejoin [a' b'] for a' in a for b' in b]
;== ["3a" "3b" "3c" "4a" "4b" "4c" "5a" "5b" "5c"]

series [rejoin [a' b'] for b' in b for a' in a]
;== "3a4a5a3b4b5b3c4c5c"
```

**All Together**

```
a: "abcd"
b: [3 4 5 6]
c: [7 8]

series/only/into [
	reduce [a'' b' * a-idx - c']
	for [a' a''] a-idx in a
	for [b' b'']       in b
	for c'       c-idx in c
	if even? c-idx + b'
] []
;== [[#"b" -1] [#"b" 3] [#"d" 5] [#"d" 13]]
```

## Acknowledgements

This code makes liberal use of Vladimir Vasilyev's list comprehension demo at https://stackoverflow.com/questions/59706298/a-compiler-for-list-comprehension-in-rebol. Much of the code is, in fact, his. I simply made a few adjustments to support indices, an output buffer, and some minor syntactic changes.
