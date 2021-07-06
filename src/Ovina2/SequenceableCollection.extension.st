Extension { #name : #SequenceableCollection }

{ #category : #'*Ovina2' }
SequenceableCollection >> secondOrNil [
	self size < 2 ifTrue: [ ^nil ].
	^self second
]

{ #category : #'*Ovina2' }
SequenceableCollection >> thirdOrNil [
	self size < 3 ifTrue: [ ^nil ].
	^self third
]
