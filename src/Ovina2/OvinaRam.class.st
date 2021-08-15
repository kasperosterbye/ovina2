Class {
	#name : #OvinaRam,
	#superclass : #OvinaSheep,
	#instVars : [
		'offspring'
	],
	#category : #'Ovina2-Model'
}

{ #category : #accessing }
OvinaRam class >> all [
	^ self rams values
]

{ #category : #'instance creation' }
OvinaRam class >> newRam [
	|nextRamId newRam|
	nextRamId := (OvinaSheep rams keys collect: [ :key | key extractNumber ]) max +1.
	newRam := OvinaRam new
		id: 'R', nextRamId asString;
		chr: -1;
		number: -1;
		inDate: Date today asDKString;
		name: 'Unavngivet';
		race: 'Uangivet'.
	OvinaSheep addSheep: newRam.
	OvinaModel announcer announce: (OvinaModelSheepChanged new sheep: newRam ).
	^ newRam 	
]

{ #category : #'as yet unclassified' }
OvinaRam class >> ramForDate: aDate [
	| rams |
	"last first"
	rams := self rams values sort: [ :r1 :r2 | r1 inDate > r2 inDate ].
	^ rams detect: [ :r | r inDate < aDate ].
]

{ #category : #initialization }
OvinaRam >> defaultPropertyOrder [
	^#(name color inDate comment)
]

{ #category : #initialization }
OvinaRam >> initialize [ 
	super initialize.
	offspring := OrderedCollection new.
]

{ #category : #testing }
OvinaRam >> isRam [
	^true
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
	
	^ self property: #name
]

{ #category : #'accessing - properties' }
OvinaRam >> name: name [
	^self property: #name put: name
]

{ #category : #'accessing - properties' }
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

{ #category : #'accessing - properties' }
OvinaRam >> sortingScore [
	^ number negated
]
