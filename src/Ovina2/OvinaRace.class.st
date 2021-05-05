"
The purpose of Race is to represent races of sheeps.
All sheeps with our CHR have their race computed

Internally we use a map #Såne->3, #Texel->1. Sum must be 1,2,4,8, 16 etc
"
Class {
	#name : #OvinaRace,
	#superclass : #Object,
	#instVars : [
		'races'
	],
	#category : #'Ovina2-Model'
}

{ #category : #'instance creation' }
OvinaRace class >> fromString: string [
	"Format of string is '3Såne1Texel' or 'Texel'"
	"\d is digits, \D is not-digits"
	|race parts|
	parts := string allRegexMatches: '(\d+\D+)|\D+'.
	"check if we are in the single unnumbered case"
	(parts size = 1 and: [ parts first first isDigit not ]) 
		ifTrue: [ ^ self new race: parts first capitalized count: 1 ].
	"parts is now a number of 1Såne 2Lüne 5Texel"
	race := self new.
	parts do:[:match| |p|
		p := match allRegexMatches: '\d+|\D+'.
		race race: p second capitalized asSymbol count: p first asNumber].
	race normalize.
	^race
	
]

{ #category : #arithmetic }
OvinaRace >> + other [
	| allRaces result sumMe sumOther|
	allRaces := self races , other races.
	sumMe := self sum.
	sumOther := other sum.
	result := self class new.
	allRaces do: [ :race | 
		result 
			race: race 
			count: ((self countForRace: race)*sumOther) + ((other countForRace: race)*sumMe) ].
	result normalize.
	^result
	
]

{ #category : #accessing }
OvinaRace >> countForRace: race [
	^ races at: race ifAbsent: [ 0 ].
	
]

{ #category : #initialization }
OvinaRace >> initialize [
	super initialize.
	races := Dictionary new.
]

{ #category : #converting }
OvinaRace >> normalize [
	"make sure the count for each race is minimal - eg, 2#Såne/2#Texel is reduced to 1#Såne/1#Texel"
	|sum reduceBy |
	sum := races values sum.
	reduceBy := (races values collect: [:count| count gcd: sum]) min.
	reduceBy = 1 ifTrue:[^self]. "fully reduced"
	races keys do: [ :race | races at: race update: [ :count | count / reduceBy  ] ]
]

{ #category : #printing }
OvinaRace >> printOn: stream [
	| sorted|
	sorted := races associations sort: [ :a1 :a2 | a1 key < a2 key ].
	sorted size = 1 ifTrue: [ stream nextPutAll: sorted first key. ^self ].
	sorted do: [ :assoc |
		stream 
			nextPutAll: assoc value asString;
			nextPutAll: assoc key]
]

{ #category : #initialization }
OvinaRace >> race: race count: count [
	races at: race put: count
]

{ #category : #accessing }
OvinaRace >> races [
	^ races keys
]

{ #category : #'primitives-plugin' }
OvinaRace >> sum [
	^ races values sum
]

{ #category : #'as yet unclassified' }
OvinaRace >> threeWayCompareTo: b [
	"must implement, but there is no reasonable definition"
	^0
]
