Class {
	#name : #OvinaEwe,
	#superclass : #OvinaSheep,
	#category : #'Ovina2-Model'
}

{ #category : #accessing }
OvinaEwe class >> all [
	^ self ewes values
]

{ #category : #columns }
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

{ #category : #columns }
OvinaEwe >> avgSlaughterWeight [
	<sheepColumn: #('gnsSlagtevægt')>
	self 
		cache: #avgSlaughterWeight
		compute: [ |slaughtered|
			slaughtered := (self lambs select: [:lamb| lamb slaughterWeight > -1]).
			slaughtered ifEmpty: [ ^ '-1' ].
			((slaughtered collect: #slaughterWeight) sum / slaughtered size) printShowingDecimalPlaces: 2 .]
	
]

{ #category : #'accessing - properties' }
OvinaEwe >> defaultPropertyOrder [
	^#(chr number name color inDate comment)
]

{ #category : #adding }
OvinaEwe >> initialize [ 
	super initialize.
]

{ #category : #testing }
OvinaEwe >> isEwe [
	^true
]

{ #category : #'accessing - properties' }
OvinaEwe >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	^'Får' 
]

{ #category : #relations }
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

{ #category : #'instance creation' }
OvinaEwe >> newLamb [
	|sire newLamb newLambId nextNumber|
	sire := OvinaRam ramForDate: Date today.
	newLambId := (OvinaSheep lambs keys collect: [ :key | key extractNumber ]) max +1.
	nextNumber := (OvinaSheep lambs values collect: [ :lamb | lamb number ]) max +1.
	newLamb := OvinaLamb new
		id: 'L', newLambId asString;
		chr: OvinaSheep maarumlamChr;
		number: nextNumber;
		inDate: Date today;
		dam: self;
		sire: sire.
	OvinaSheep addSheep: newLamb.
	OvinaModel announcer announce: (OvinaModelSheepChanged new sheep: newLamb ).
	^ newLamb 
]

{ #category : #columns }
OvinaEwe >> noLambs [
	<sheepColumn: #('Antal lam')>
	^ self lambs size
]

{ #category : #'accessing - properties' }
OvinaEwe >> outDate [
	<sheepColumn:#('Ud dato' outDate:)>
	^(self property: #outDate) ifNotNil: [ :d| d asDate ] ifNil: [ nil ]
]

{ #category : #'accessing - properties' }
OvinaEwe >> outDate: date [
	date ifNil: [ ^self ].
	date isString 
		ifTrue: [ ^self property: #outDate put: date parseDKDate yyyymmdd  ]
	 	ifFalse: [ ^self property: #outDate put: date yyyymmdd ]
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
