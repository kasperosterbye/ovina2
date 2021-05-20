Extension { #name : #Number }

{ #category : #'*Ovina2' }
Number >> asDKNumber [
	^self
]

{ #category : #'*Ovina2' }
Number >> asDKString [
	self isInteger ifTrue: [ ^ self printString ].
	^(self printShowingDecimalPlaces: 2) copyReplaceAll: '.' with: ','.
]

{ #category : #'*Ovina2' }
Number >> ovinaDBString [ 
	^ self asString printString
]
