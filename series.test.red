Red []

#include %series.red

a: [5 6 7]
b: "abc"

print equal? series [a-elem for a-elem in a] a
print equal? series/into [a-elem for a-elem in a] "" "567"
print equal? series [reduce [a-elem] for a-elem in a] [5 6 7]
print equal? series/only [reduce [a-elem] for a-elem in a] [[5] [6] [7]]

print equal? series [a-elem for a-elem in [5 6 7]] a
print equal? series/into [a-elem for a-elem in [5 6 7]] "" "567"
print equal? series [reduce [a-elem] for a-elem in [5 6 7]] [5 6 7]
print equal? series/only [reduce [a-elem] for a-elem in [5 6 7]] [[5] [6] [7]]

print equal? series [rejoin [a-elem a-idx] for a-elem a-idx in a] ["51" "62" "73"]
print equal? series/into [rejoin [a-elem a-idx] for a-elem a-idx in a] "" "516273"
print equal? series [reduce [a-elem a-idx] for a-elem a-idx in a] [5 1 6 2 7 3]
print equal? series/only [reduce [a-elem a-idx] for a-elem a-idx in a] [[5 1] [6 2] [7 3]]

print equal? series [rejoin [a-elem a-idx] for a-elem a-idx in [5 6 7]] ["51" "62" "73"]
print equal? series/into [rejoin [a-elem a-idx] for a-elem a-idx in [5 6 7]] "" "516273"
print equal? series [reduce [a-elem a-idx] for a-elem a-idx in [5 6 7]] [5 1 6 2 7 3]
print equal? series/only [reduce [a-elem a-idx] for a-elem a-idx in [5 6 7]] [[5 1] [6 2] [7 3]]

; series [rejoin [i * 2 j] for i in a for j in b if even? i and char? j]
; probe series [rejoin [i * 2 j] for i in a for j in b if even? i]
; probe series [rejoin [i * 2 j] for i in [ 1 2 3 4 ] for j in "string" if even? i]
; probe series [rejoin [i * 2 j] for j in b for i in [ 1 2 3 4 ] if even? i]
; probe series/into [rejoin [i * 2 "." i-idx j-idx "." j] for j j-idx in b for i i-idx in [ 1 2 3 4 ] if even? i] []
; probe series [rejoin [i * 2 j] for i in [ 1 2 3 4 ] for j in "string"]