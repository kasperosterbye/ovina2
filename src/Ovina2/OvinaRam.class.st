Class {
	#name : #OvinaRam,
	#superclass : #OvinaSheep,
	#instVars : [
		'offspring'
	],
	#category : #'Ovina2-Model'
}

{ #category : #adding }
OvinaRam >> addLamb: lamb [
	Transcript nextPutAll: self id, ' ', offspring size asString;cr;endEntry.
	offspring add: lamb
]

{ #category : #'as yet unclassified' }
OvinaRam >> defaultPropertyOrder [
	^#(name color inDate comment)
]

{ #category : #initialization }
OvinaRam >> initialize [ 
	super initialize.
	offspring := OrderedCollection new.
]

{ #category : #'accessing - properties' }
OvinaRam >> name [
	
	<sheepColumn: #('navn' name:)>
	^ self property: #name
]

{ #category : #'accessing - properties' }
OvinaRam >> name: name [
	^self property: #name put: name
]

{ #category : #'as yet unclassified' }
OvinaRam >> noLambs [
	<sheepColumn: #('Antal lam')>
	
	^ offspring ifNil: [0] ifNotNil: [ offspring size ] 
]

{ #category : #printing }
OvinaRam >> printOn: aStream [
	aStream nextPutAll: 'Ram '.
	super printOn: aStream
]
