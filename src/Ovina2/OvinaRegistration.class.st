Class {
	#name : #OvinaRegistration,
	#superclass : #Object,
	#instVars : [
		'id',
		'kind',
		'date',
		'default',
		'comment'
	],
	#classInstVars : [
		'registrations'
	],
	#category : #'Ovina2-Model'
}

{ #category : #accessing }
OvinaRegistration class >> addRegistration: reg [
	self registrations at: reg id put: reg
]

{ #category : #initialization }
OvinaRegistration class >> initialize [
	<script>
	registrations  := nil.
]

{ #category : #accessing }
OvinaRegistration class >> registrations [
	registrations ifNil: [registrations := Dictionary new].
	^registrations 
]

{ #category : #accessing }
OvinaRegistration >> comment [

	^ comment
]

{ #category : #accessing }
OvinaRegistration >> comment: anObject [

	comment := anObject
]

{ #category : #accessing }
OvinaRegistration >> date [

	^ date
]

{ #category : #accessing }
OvinaRegistration >> date: anObject [

	date := anObject
]

{ #category : #accessing }
OvinaRegistration >> default [

	^ default
]

{ #category : #accessing }
OvinaRegistration >> default: anObject [

	default := anObject
]

{ #category : #accessing }
OvinaRegistration >> id [

	^ id
]

{ #category : #accessing }
OvinaRegistration >> id: anObject [

	id := anObject
]

{ #category : #accessing }
OvinaRegistration >> kind [

	^ kind
]

{ #category : #accessing }
OvinaRegistration >> kind: anObject [

	kind := anObject
]

{ #category : #printing }
OvinaRegistration >> printOn: aStream [
	"id kind date comment default"
	aStream nextPutAll: ('Reg [{1}, {2}, {3}]' 
		format: {kind. date. (comment copyUpTo:  Character space) printString})
]
