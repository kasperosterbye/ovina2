Class {
	#name : #OvinaEwe,
	#superclass : #OvinaSheep,
	#instVars : [
		'offspring'
	],
	#category : #'Ovina2-Model'
}

{ #category : #adding }
OvinaEwe >> addLamb: lamb [
	
	offspring add: lamb
]

{ #category : #'as yet unclassified' }
OvinaEwe >> antalSlagtelam [
	<sheepColumn: #('# slagtelam')>
	
	^ (offspring select: [ :lamb | lamb usage = 'slagt' ]) size
]

{ #category : #'as yet unclassified' }
OvinaEwe >> defaultPropertyOrder [
	^#(chr number name color inDate comment)
]

{ #category : #'as yet unclassified' }
OvinaEwe >> gnsSlagtevægt [
	<sheepColumn: #('gnsSlagtevægt')>
	|slagtede|
	slagtede := (self lambs 
		select: [:lamb| lamb slagtevægt > -1]).
	slagtede ifEmpty: [ ^ '-1' ].
	^((slagtede collect: #slagtevægt) sum / slagtede size) printShowingDecimalPlaces: 2 .
	
]

{ #category : #adding }
OvinaEwe >> initialize [ 
	super initialize.
	offspring := OrderedCollection new.
]

{ #category : #'accessing - properties' }
OvinaEwe >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	^'Får' 
]

{ #category : #'as yet unclassified' }
OvinaEwe >> lambs [
	^ offspring 
]

{ #category : #'accessing - properties' }
OvinaEwe >> name [
	
	<sheepColumn: #('navn' name:)>
	^ self property: #name
]

{ #category : #'accessing - properties' }
OvinaEwe >> name: name [
	^self property: #name put: name
]

{ #category : #'as yet unclassified' }
OvinaEwe >> noLambs [
	<sheepColumn: #('Antal lam')>
	^ offspring ifNil: [0] ifNotNil: [ offspring size] 
]

{ #category : #printing }
OvinaEwe >> printOn: aStream [
	aStream nextPutAll: 'Ewe '.
	super printOn: aStream
]
