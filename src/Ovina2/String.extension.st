Extension { #name : #String }

{ #category : #'*Ovina2' }
String >> asISO8601Date [
	^ Date readFrom: self readStream  pattern: 'yyyy-mm-dd'
]
