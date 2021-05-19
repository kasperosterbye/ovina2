Extension { #name : #String }

{ #category : #'*Ovina2' }
String >> asDKNumber [
	^ OvinaModel dkNumberFrom: self
]

{ #category : #'*Ovina2' }
String >> ovinaDBString [
	^ self printString
]

{ #category : #'*Ovina2' }
String >> parseDKDate [
	"return a date expected to be in Danish format 02.08.1961"
	self ifEmpty: [ ^nil ].
	^ Date readFrom: self readStream  pattern: 'dd.mm.yyyy'
]

{ #category : #'*Ovina2' }
String >> parseISO8601 [
	"return a date expected to be in iso 8601 format yyyy-mm-dd"
	self ifEmpty: [ ^nil ].
	^ Date readFrom: self readStream  pattern: 'yyyy-mm-dd'
]
