Class {
	#name : #OvinaLamb,
	#superclass : #OvinaSheep,
	#category : #'Ovina2-Model'
}

{ #category : #'accessing-properties' }
OvinaLamb >> color [

	^ (self property: #color)
]

{ #category : #'accessing-properties' }
OvinaLamb >> color: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #color put: val
]

{ #category : #'accessing-properties' }
OvinaLamb >> comment [

	^ (self property: #comment)
]

{ #category : #'accessing-properties' }
OvinaLamb >> comment: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #comment put: val
]

{ #category : #'accessing-properties' }
OvinaLamb >> dam [

	^ (self property: #dam)
]

{ #category : #'accessing-properties' }
OvinaLamb >> dam: val [

	self property: #dam put: val
]

{ #category : #'accessing-properties' }
OvinaLamb >> event [

	^ (self property: #event)
]

{ #category : #'accessing-properties' }
OvinaLamb >> event: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #event put: val
]

{ #category : #'accessing-properties' }
OvinaLamb >> growth [

	^ (self property: #growth)
]

{ #category : #'accessing-properties' }
OvinaLamb >> growth: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #growth put: val
]

{ #category : #printing }
OvinaLamb >> printOn: aStream [
	aStream nextPutAll: 'Lamb '.
	super printOn: aStream
]

{ #category : #'accessing-properties' }
OvinaLamb >> sex [

	^ (self property: #sex)
]

{ #category : #'accessing-properties' }
OvinaLamb >> sex: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #sex put: val
]

{ #category : #'accessing-properties' }
OvinaLamb >> sire [

	^ (self property: #sire)
]

{ #category : #'accessing-properties' }
OvinaLamb >> sire: val [

	self property: #sire put: val
]

{ #category : #accessing }
OvinaLamb >> usage [
	^ self class get: #usage for: self.
]

{ #category : #accessing }
OvinaLamb >> usage: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #usage put: val. 
]
