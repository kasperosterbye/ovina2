Class {
	#name : #OvinaEvent,
	#superclass : #Object,
	#instVars : [
		'id',
		'registration',
		'sheep',
		'date',
		'value'
	],
	#classInstVars : [
		'events'
	],
	#category : #'Ovina2-Model'
}

{ #category : #initialization }
OvinaEvent class >> addEvent: event [
	events at: event id put: event
]

{ #category : #accessing }
OvinaEvent class >> events [
	events ifNil: [ events := Dictionary new ].
	^ events
]

{ #category : #initialization }
OvinaEvent class >> initializeRegistrations [
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

{ #category : #accessing }
OvinaEvent >> registration [

	^ registration
]

{ #category : #accessing }
OvinaEvent >> registration: anObject [

	registration := anObject
]

{ #category : #accessing }
OvinaEvent >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaEvent >> sheep: anObject [

	sheep := anObject
]

{ #category : #accessing }
OvinaEvent >> value1 [

	^ value
]

{ #category : #accessing }
OvinaEvent >> value: anObject [

	value := anObject
]
