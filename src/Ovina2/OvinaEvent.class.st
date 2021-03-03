Class {
	#name : #OvinaEvent,
	#superclass : #Object,
	#instVars : [
		'id',
		'registration',
		'sheep',
		'date',
		'result'
	],
	#classInstVars : [
		'events'
	],
	#category : #'Ovina2-Model'
}

{ #category : #initialization }
OvinaEvent class >> addEvent: event [

	self events at: event id put: event
]

{ #category : #accessing }
OvinaEvent class >> events [
	events ifNil: [ events := Dictionary new ].
	^ events
]

{ #category : #initialization }
OvinaEvent class >> initialize [
	<script>
	events  := nil.
]

{ #category : #accessing }
OvinaEvent >> date [

	^ date
]

{ #category : #accessing }
OvinaEvent >> date: anObject [

	date := anObject
]

{ #category : #accessing }
OvinaEvent >> id [

	^ id
]

{ #category : #accessing }
OvinaEvent >> id: anObject [

	id := anObject
]

{ #category : #printing }
OvinaEvent >> printOn: aStream [

	"id registration sheep date value"

	aStream nextPutAll: ('Event [{1}, {2}, {3}]' format: { 
				 registration kind.
				 sheep.
				 result })
]

{ #category : #accessing }
OvinaEvent >> registration [

	^ registration
]

{ #category : #accessing }
OvinaEvent >> registration: anObject [
	registration := anObject
]

{ #category : #accessing }
OvinaEvent >> result [

	^ result
]

{ #category : #accessing }
OvinaEvent >> result: anObject [

	result := anObject
]

{ #category : #accessing }
OvinaEvent >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaEvent >> sheep: anObject [

	sheep := anObject
]
