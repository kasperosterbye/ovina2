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

{ #category : #initialization }
OvinaEvent class >> addNewEvent: event [
	"get the new ID as the max of existing"
	event id: ((self events values collect: [:r | r id asInteger]) max +1) asString.
	self addEvent: event
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

{ #category : #initialization }
OvinaEvent class >> removeEvent: event [

	self events removeKey: event id
]

{ #category : #updating }
OvinaEvent >> changed [
	OvinaModel announcer announce: (OvinaModelEventChanged new event: self)
]

{ #category : #accessing }
OvinaEvent >> date [
	date ifNil: [ ^ registration date ].
	^ date
]

{ #category : #accessing }
OvinaEvent >> date: anObject [

	date := anObject.
	self changed
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
	registration := anObject.
	"Registrations do not change - hence no announcement"
]

{ #category : #accessing }
OvinaEvent >> result [

	result ifNil: [ ^ registration default ].
	result ifEmpty: [ ^ registration default ].
	^ result
]

{ #category : #accessing }
OvinaEvent >> result: anObject [

	result := anObject.
	self changed
]

{ #category : #accessing }
OvinaEvent >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaEvent >> sheep: anObject [

	sheep := anObject.
	"Sheep does not change, no announcement"
]
