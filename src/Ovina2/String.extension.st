Extension { #name : #String }

{ #category : #'*Ovina2' }
String >> asISO8601Date [
	^ Iso8601Date readFrom: self readStream  pattern: 'yyyy-mm-dd'
]

{ #category : #'*Ovina2' }
String >> ovinaDBString [
	^ self printString
]
