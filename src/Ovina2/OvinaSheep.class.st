"
I am the superclass for sheeps.
A sheep has a few intrinsic properties (id, chr, and number).
id is on the form AXXXX, where A is either E,L,R (Ewe, Lamb, Ram), XXXX is an id. This scheme allow us to migrate the old id's to the new database.

In addition, a sheep can have different persistent poperties. Those are stored in a large Dictionary on the class side. SheepID->Dictionary<propertyName,StringValue>.

All sheeps are stored in a sheeps table - Dictionary<ID,Sheep>

"
Class {
	#name : #OvinaSheep,
	#superclass : #Object,
	#instVars : [
		'id',
		'chr',
		'number'
	],
	#classInstVars : [
		'properties',
		'sheeps'
	],
	#category : #'Ovina2-Model'
}

{ #category : #sheeps }
OvinaSheep class >> addSheep: aSheep [
	self sheeps at: aSheep id put: aSheep
]

{ #category : #properties }
OvinaSheep class >> get: propName for: sheep [
	"return the property for sheep. Return nil if none exist. 
	I return the string value from the database table properties"
	^(properties at: sheep id ifAbsent: [ ^nil ]) at: propName ifAbsent: [ ^nil ]
	
]

{ #category : #sheeps }
OvinaSheep class >> initializeSheeps [
	<script>
	sheeps := nil.
]

{ #category : #properties }
OvinaSheep class >> properties [ 
	properties ifNil: [ properties := Dictionary new ].
	^ properties 
]

{ #category : #properties }
OvinaSheep class >> propertiesFor: aSheep [
	^ self properties at: aSheep id
]

{ #category : #properties }
OvinaSheep class >> set: property to: value for: sheep [
	"return the property for sheep. Return nil if none exist. 
	I return the string value from the database table properties"
	"set the property for sheep to value. Update in the database too"
	(self properties at: sheep id ifAbsentPut: [ Dictionary new ]) 
		at: property put: value
	
]

{ #category : #sheeps }
OvinaSheep class >> sheep: id [
	"return the sheep with id <Integer>. If id is nil, return nil"
	id ifNil: [ ^nil ].
	^sheeps at: id
]

{ #category : #sheeps }
OvinaSheep class >> sheeps [
	"return the mapping of ID to sheep"
	sheeps ifNil: [ sheeps := Dictionary new ].
	^sheeps
]

{ #category : #accessing }
OvinaSheep >> chr [

	^ chr
]

{ #category : #accessing }
OvinaSheep >> chr: anObject [

	chr := anObject
]

{ #category : #'accessing - properties' }
OvinaSheep >> computeRace [
	^'todo'
]

{ #category : #accessing }
OvinaSheep >> id [

	^ id
]

{ #category : #accessing }
OvinaSheep >> id: anObject [

	id := anObject
]

{ #category : #'accessing - properties' }
OvinaSheep >> inDate [
	^(self property: #inDate) asISO8601Date 
]

{ #category : #'accessing - properties' }
OvinaSheep >> inDate: date [
	date isString 
		ifTrue: [ ^self property: #inDate put: date ]
	 	ifFalse: [ ^self property: #inDate put: date yyyymmdd  ]
	
]

{ #category : #'accessing - properties' }
OvinaSheep >> mother [
	^self class sheep: (self property: #mother)
]

{ #category : #'accessing - properties' }
OvinaSheep >> name [
	^self property: #name
]

{ #category : #'accessing - properties' }
OvinaSheep >> name: name [
	^self property: #name put: name
]

{ #category : #accessing }
OvinaSheep >> number [

	^ number
]

{ #category : #accessing }
OvinaSheep >> number: anObject [

	number := anObject
]

{ #category : #printing }
OvinaSheep >> printOn: aStream [
	aStream nextPutAll: 'Sheep [';
	print: ({ id. chr. number } , self properties values );
	nextPut: $]
]

{ #category : #properties }
OvinaSheep >> properties [
	"return a property dictionary for this sheep"
	^self class propertiesFor: self.
]

{ #category : #properties }
OvinaSheep >> property: property [
	"return the value for property or nil"
	^self class get: property for: self.
]

{ #category : #properties }
OvinaSheep >> property: property put: value [
	"return the value for property or nil"
	self class set: property to: value for: self.
]

{ #category : #'accessing - properties' }
OvinaSheep >> race [
	|race|
	race := self property: #race.
	race ifNil: [ ^ self computeRace ].
	^ race
]

{ #category : #'accessing - properties' }
OvinaSheep >> race: race [
	^self property: #race put: race
]
