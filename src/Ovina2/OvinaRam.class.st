Class {
	#name : #OvinaRam,
	#superclass : #OvinaSheep,
	#instVars : [
		'offspring'
	],
	#category : #'Ovina2-Model'
}

{ #category : #'as yet unclassified' }
OvinaRam class >> ramForDate: aDate [
	| rams |
	"last first"
	rams := self rams values sort: [ :r1 :r2 | r1 inDate > r2 inDate ].
	^ rams detect: [ :r | r inDate < aDate ].
]

{ #category : #adding }
OvinaRam >> addLamb: lamb [
	
	self invalidateCache 
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
OvinaRam >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	^'Vædder' 
]

{ #category : #sheeps }
OvinaRam >> lambs [
	"^ offspring "
	^ self cache: #offspring
		 compute: [ OvinaSheep lambs values select:[:lamb | lamb sire = self ]]
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
	^ self lambs size
]

{ #category : #'accessing - properties' }
OvinaRam >> present [
	"return true if the ram is still alive - only the last ram is kept"

	^ self = (OvinaSheep rams values detectMax: [ :r | r inDate  ])
]

{ #category : #printing }
OvinaRam >> printOn: aStream [
	aStream nextPutAll: 'Ram '.
	super printOn: aStream
]

{ #category : #'accessing - properties' }
OvinaRam >> raceCompute [
	^ OvinaRace fromString: (self property: #race)
	
]
