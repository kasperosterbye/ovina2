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

{ #category : #'accessing - properties' }
OvinaEwe >> present [
	"return true if the ewe is still alive"
	^ self outDate isNil and: [ self slaughterWeight isNil ]
]

{ #category : #printing }
OvinaEwe >> printOn: aStream [
	aStream nextPutAll: 'Ewe '.
	super printOn: aStream
]

{ #category : #'accessing - properties' }
OvinaEwe >> raceCompute [ 
	self chr = OvinaSheep maarumlamChr 
		ifFalse: [ ^ OvinaRace fromString: (self property: #race) ].
	"This hardcoded list are those ewes born here, but where the lamb is not in the database"
	(#('E22' 'E23' 'E12' 'E4' 'E5' 'E7' 'E8' 'E20') includes: self id) 
		ifTrue: [  ^ OvinaRace fromString: ((self property: #race) copyReplaceAll: 'st' with: '1Såne1Texel' )].
	^ self asLamb race
	
]
