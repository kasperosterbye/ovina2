Class {
	#name : #OvinaLambTest,
	#superclass : #OvinaTestCase,
	#category : #'Ovina2-Tests-Model'
}

{ #category : #tests }
OvinaLambTest >> testFinalWeightCompute [
	"smoke test"
	| lambs |
	lambs := OvinaLamb all.
	lambs do: [ :lamb |
		self assert: lamb finalWeightCompute isNumber.
		 ]
	
]

{ #category : #tests }
OvinaLambTest >> testFinalWeightCompute_l470 [
	"test lamb with id l470"
	| l470 |
	l470 := OvinaSheep sheeps at: 'L470'.
	self assert: l470 finalWeightCompute rounded equals: 52
	
]

{ #category : #tests }
OvinaLambTest >> testFinalWeightCompute_senseTest [
	"does all numbers make sense test"
	| lambs |
	lambs := OvinaLamb all.
	lambs do: [ :lamb | |fw|
		fw := lamb finalWeightCompute.
		"-1 is used to indicate missing data"
		fw <= 0 ifFalse: [ self assert: fw  > 30].
		 ]
	
]

{ #category : #tests }
OvinaLambTest >> testGramPerDayCompute [
	"smoke test"
	| lambs |
	lambs := OvinaLamb all.
	lambs do: [ :lamb |
		self assert: lamb gramPerDayCompute isNumber.
		 ]
	
]

{ #category : #tests }
OvinaLambTest >> testGramPerDayCompute_l470 [
	"test lamb with id l470"
	| l470 |
	l470 := OvinaSheep sheeps at: 'L470'.
	self assert: l470 gramPerDayCompute rounded equals: 215
	
]

{ #category : #tests }
OvinaLambTest >> testGramPerDayCompute_l571 [
	"test lamb with id l470"
	| l571 |
	l571 := OvinaSheep sheeps at: 'L571'.
	self assert: l571 gramPerDayCompute rounded equals: 227
	
]

{ #category : #tests }
OvinaLambTest >> testGramPerDayCompute_senseTest [
	"does all numbers make sense test"
	| lambs |
	lambs := OvinaLamb all.
	lambs do: [ :lamb | |gpd|
		gpd := lamb gramPerDayCompute.
		"-1 is used to indicate missing data"
		gpd <= 0 ifFalse: [ self assert: gpd  > 70].
		 ]
	
]

{ #category : #tests }
OvinaLambTest >> testSlaughterAgeCompute [
	"smoke test"
	| lambs |
	lambs := OvinaLamb all.
	lambs do: [ :lamb |
		self assert: lamb slaughterAgeCompute isNumber.
		 ]
	
	
]

{ #category : #tests }
OvinaLambTest >> testSlaughterAgeCompute_l470 [
	"slagtet 11.11.2018, kød: 20 kg"
	| l470 |
	l470 := OvinaSheep sheeps at: 'L470'.
	self assert: l470 slaughterAgeCompute equals: 227.
	
	
]

{ #category : #tests }
OvinaLambTest >> testSlaughterAgeCompute_senseTest [
	"does all numbers make sense test"
	| lambs |
	lambs := OvinaLamb all.
	lambs do: [ :lamb | |sa|
		sa := lamb slaughterAgeCompute.
		"-1 is used to indicate missing data"
		sa <= 0 ifFalse: [ self assert: sa  > (4*30)].
		 ]
	
]
