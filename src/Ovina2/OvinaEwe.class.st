Class {
	#name : #OvinaEwe,
	#superclass : #OvinaSheep,
	#category : #'Ovina2-Model'
}

{ #category : #adding }
OvinaEwe >> addLamb: lamb [
	
	self invalidateCache 
]

{ #category : #'as yet unclassified' }
OvinaEwe >> antalSlagtelam [
	<sheepColumn: #('# slagtelam')>
	
	^ (self lambs select: [ :lamb | lamb usage = 'slagt' ]) size
]

{ #category : #converting }
OvinaEwe >> asLamb [
	"If chr is our farm, we should be able find this ewe as lamb. If chr or not found, return nil"
	self chr = OvinaSheep maarumlamChr ifFalse: [ ^nil ].
	^ OvinaSheep lambs values detect: [ :l | l number = self number ] ifNone: [ nil]
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
]

{ #category : #'accessing - properties' }
OvinaEwe >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	^'Får' 
]

{ #category : #'as yet unclassified' }
OvinaEwe >> lambs [
	"^ offspring "
	^ self cache: #offspring
		 compute: [ OvinaSheep lambs values select:[:lamb | lamb dam = self ]]
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
	^ self lambs size
]

{ #category : #printing }
OvinaEwe >> printOn: aStream [
	aStream nextPutAll: 'Ewe '.
	super printOn: aStream
]
