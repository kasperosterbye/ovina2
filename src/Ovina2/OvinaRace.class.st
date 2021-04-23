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
	"Format of string is '3#Såne/1#Textel'"
	|race parts|
	parts := string substrings: '/'.
	race := self new.
	parts do:[:p| |split|
		split := p substrings: '#'.
		race race: split second asSymbol count: split first asNumber].
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
	|first sorted|
	first := true.
	sorted := races associations sort: [ :a1 :a2 | a1 key < a2 key ].
	sorted do: [ :assoc |
		first ifFalse: [ stream nextPut: $/].
		stream 
			nextPutAll: assoc value asString;
			nextPut: $#;
			nextPutAll: assoc key.
		first := false ]
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
