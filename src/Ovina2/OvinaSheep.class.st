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
	#category : #Ovina2
}

{ #category : #'as yet unclassified' }
OvinaSheep class >> get: propName for: sheep [
	"return the property for sheep. Return nil if none exist. 
	I return the string value from the database table properties"
	(properties at: sheep id ifAbsent: [ ^nil ]) at: propName ifAbsent: [ ^nil ]
	
]

{ #category : #'as yet unclassified' }
OvinaSheep class >> set: property to: value for: sheep [
	"return the property for sheep. Return nil if none exist. 
	I return the string value from the database table properties"
	"set the property for sheep to value. Update in the database too"
	(properties at: sheep id ifAbsentPut: [ Dictionary new ]) 
		at: property put: value
	
]

{ #category : #'as yet unclassified' }
OvinaSheep class >> sheep: id [
	"return the sheep with id <Integer>. If id is nil, return nil"
	id ifNil: [ ^nil ].
	^sheeps at: id
]

{ #category : #'as yet unclassified' }
OvinaSheep >> mother [
	^self class sheep: (self property: #mother)
]

{ #category : #accessing }
OvinaSheep >> property: property [
	"return the value for property or nil"
	^self class get: property for: self.
]

{ #category : #accessing }
OvinaSheep >> property: property put: value [
	"return the value for property or nil"
	self class set: property to: value for: self.
]
