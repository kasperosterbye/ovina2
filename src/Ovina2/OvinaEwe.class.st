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
OvinaEwe >> age [
	"in years"
	<sheepColumn: #( 'alder' )>
	^ Date today year - self inDate year
		
]

{ #category : #converting }
OvinaEwe >> asLamb [
	"If chr is our farm, we should be able find this ewe as lamb. If chr or not found, return nil"
	self chr = OvinaSheep maarumlamChr ifFalse: [ ^nil ].
	^ OvinaSheep lambs values detect: [ :l | l number = self number ] ifNone: [ nil]
]

{ #category : #columns }
OvinaEwe >> avgLambGrowth [
	"in years"
	<sheepColumn: #( 'lam vægst' )>
	^ self 
		cache: #avgLambGrowth 
		compute: [ self avgLambGrowthCompute ]
]

{ #category : #columns }
OvinaEwe >> avgLambGrowthCompute [
	| allWeights totalWeight |
	self lambs ifEmpty: [ ^ -1 ].
	allWeights := ((self lambs collect: [:l| l gramPerDay ]) select: [ :v | v > 0 ]).
	totalWeight := allWeights inject: 0 into: [ :sofar :elem | sofar + elem ].
	^ (totalWeight / self lambs size) 
]

{ #category : #columns }
OvinaEwe >> avgLemmingSize [
	"number of lambs per year"
	<sheepColumn: #( 'kuldstørrelse' )>
	^100
	
]

{ #category : #columns }
OvinaEwe >> avgSlaughterWeight [
	<sheepColumn: #('gnsSlagtevægt')>
	^ self 
		cache: #avgSlaughterWeight
		compute: [ |slaughtered|
			slaughtered := (self lambs select: [:lamb| lamb slaughterWeight > -1]).
			slaughtered ifEmpty: [ ^ '-1' ].
			((slaughtered collect: #slaughterWeight) sum / slaughtered size) printShowingDecimalPlaces: 2 .]
	
]

{ #category : #private }
OvinaEwe >> classify: measurement max: max delimiters: delimiters [
	"return the index of measurement in the delimiters, or max if measurement is above max delimiter"
	|score|
	score := 1.
	[ score <= delimiters size and: [ measurement >= (delimiters at: score) ] ] 
		whileTrue: [ score := score + 1 ].
	^ score <= delimiters size
		ifTrue: [ score ]
	 	ifFalse: [ max ]
]

{ #category : #columns }
OvinaEwe >> color [
	<sheepColumn: #('farve')>
	^ self asLamb ifNotNil: [ :l | l color ] ifNil: [ '---' ]
]

{ #category : #'accessing - properties' }
OvinaEwe >> defaultPropertyOrder [
	^#(chr number name color inDate comment)
]

{ #category : #columns }
OvinaEwe >> hardBirths [
	"return number of hard births"
	<sheepColumn: #('svære fødsler')>
	^((self lambs 
		select: [ :l | l event ~= 'let' ]) 
			collect: [ :l | l inDate year ]) 
				asSet size
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

{ #category : #columns }
OvinaEwe >> maleneScore [
	<sheepColumn: #('score')>
	|score|
	score := 0.
	score := score + (self upto: 5 for: self hardBirths).
	score := score + (self classify: self avgLemmingSize  max: 4 delimiters: #(1.6 1.7 1.8 1.9 2.3)).
	score := score + (self upto: 5 for: self noDeadLambs).
	score := score + (self upto: 5 for: self noBottleLambs).
	score := score + (self classify: self avgLambGrowth  max: 5 delimiters: #(180 200 220 240 260)).
	score := score + (self classify: self sumOfLastThreeYears 
								  max: 5  
								  delimiters: #(1200 1400 1600 1800 1900) ).
	^ score
]

{ #category : #'accessing - properties' }
OvinaEwe >> name [
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
OvinaEwe >> noBottleLambs [
	"return number of died lambs"
	<sheepColumn: #('døde')>
	^ (self lambs select: [ :l | l usage = 'flaske' ]) size
]

{ #category : #columns }
OvinaEwe >> noDeadLambs [
	"return number of died lambs"
	<sheepColumn: #('døde')>
	^ (self lambs select: [ :l | l usage = 'død' ]) size
]

{ #category : #columns }
OvinaEwe >> noLambs [
	<sheepColumn: #('Antal lam')>
	^ self lambs size
]

{ #category : #columns }
OvinaEwe >> noLambsForSlaughter [
	<sheepColumn: #('# slagtelam')>
	
	^ (self lambs select: [ :lamb | lamb usage = 'slagt' ]) size
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
	^ self outDate isNil and: [ self slaughterWeight = -1 ]
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

{ #category : #'as yet unclassified' }
OvinaEwe >> sortingScore [
	^ number * 10000
]

{ #category : #columns }
OvinaEwe >> sumOfLastThreeYears [
	"In kg"
	<sheepColumn: #( '3.års vægst' )>
	^self 
		cache: #sumOfLastThreeYears 
		compute: [ self sumOfLastThreeYearsCompute rounded ]

]

{ #category : #columns }
OvinaEwe >> sumOfLastThreeYearsCompute [
	"I am using inject:into: as the inject value is return in case of empty collection"
	|lambsList newestSeason firstSeason totalWeight|
	lambsList := self lambs select: [ :l | l gramPerDay > 0 ].
	lambsList ifEmpty: [ ^ -1 ].
	newestSeason := (lambsList  collect: [ :l | l inDate year ]) inject: 0 into: [:sofar :l| sofar max: l].
	firstSeason := (lambsList  collect: [ :l | l inDate year ]) inject: 3000 into: [:sofar :l| sofar min: l].
	firstSeason := newestSeason -2 max: firstSeason.
	totalWeight := ((lambsList select: [:l | l inDate year >= (newestSeason -2) ])
		collect: [ :l | l gramPerDay  ]) inject: 0 into: [:sofar :l| sofar + l].
	^totalWeight / (newestSeason - firstSeason + 1 ) * 3
]

{ #category : #private }
OvinaEwe >> upto: max for: measureCount [
	^ max - (measureCount min: max)
]
