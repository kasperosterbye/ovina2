Class {
	#name : #OvinaEvent,
	#superclass : #OvinaModelElement,
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

	self events at: event id put: event.
	event registration invalidateCache.
	event sheep invalidateCache.
	OvinaModel announcer announce: (OvinaModelEventChanged new event: event).
	
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

	self events removeKey: event id.
	event registration invalidateCache.
	event sheep invalidateCache.
	OvinaModel announcer announce: (OvinaModelEventRemoved new event: event).
]

{ #category : #updating }
OvinaEvent >> changed [
	
	self sheep invalidateCache.
	OvinaModel announcer announce: (OvinaModelEventChanged new event: self).
]

{ #category : #accessing }
OvinaEvent >> date [
	date ifNil: [ ^ registration date ].
	^ date
]

{ #category : #accessing }
OvinaEvent >> date: stringOrDate [
	| newDate |
	stringOrDate isString
		ifFalse: [ newDate := stringOrDate. ]
		ifTrue: ["date string might be incomplete. "
			[ newDate := stringOrDate parseDKDate ]
				on: Exception
				do: [ newDate := (date ifNil: [ Date today] ) ]].
	date := newDate.
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

{ #category : #description }
OvinaEvent >> kind [
	^ self registration kind
]

{ #category : #printing }
OvinaEvent >> printOn: aStream [

	"id registration sheep date value"

	aStream nextPutAll: ('Event [{1} @ {2}: {3} - sheep: {4}]' format: { 
				 registration kind.
				 registration date.
				 result.
				 sheep. })
]

{ #category : #accessing }
OvinaEvent >> registration [

	^ registration
]

{ #category : #accessing }
OvinaEvent >> registration: aRegistration [

	registration ifNotNil: [ ^ self error: 'registration should not change for events' ].
	registration := aRegistration.
	"Registrations do not change for an event- hence no announcement"
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
OvinaEvent >> sheep: aSheep [

	sheep ifNotNil: [ ^ self error: 'sheep should not change for events' ].
	sheep := aSheep.
	"Sheep does not change within an event, no announcement"
]
