Extension { #name : #SequenceableCollection }

{ #category : #'*Ovina2' }
SequenceableCollection >> secondOrNil [
	self size < 2 ifTrue: [ ^nil ].
	^self second
]

{ #category : #'*Ovina2' }
SequenceableCollection >> slidingPairs [
	"return a set of pairs, item 1 and item 2, item 2 and 3, 3 and 4 etc
	the pairs are represented as arrays independent of my collection type"
	"#(1 2 3) slidingPairs >>> #( (1 2) (2 3))"
	^ (1 to: self size - 1) collect: [ :index | {self at: index. self at: index +1}]
]

{ #category : #'*Ovina2' }
SequenceableCollection >> thirdOrNil [
	self size < 3 ifTrue: [ ^nil ].
	^self third
]
