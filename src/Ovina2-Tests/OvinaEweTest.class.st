Class {
	#name : #OvinaEweTest,
	#superclass : #OvinaTestCase,
	#category : #'Ovina2-Tests-Model'
}

{ #category : #tests }
OvinaEweTest >> testAvgLambGrowthCompute [
	"smoke test"
	| ewes |
	ewes := OvinaEwe all.
	ewes do: [ :ewe |
		self assert: ewe avgLambGrowthCompute isNumber.
		 ]
	
	
]

{ #category : #tests }
OvinaEweTest >> testAvgLambGrowthCompute_e71 [
	"test Kim"
	| e71 |
	e71 := OvinaSheep sheeps at: 'E71'.
	self assert: e71 name equals: 'Kim'.
	self assert: e71 avgLambGrowthCompute closeTo: 240.74 precision: 0.1
	
]

{ #category : #tests }
OvinaEweTest >> testAvgLambGrowthCompute_senseTest [
	"sense test"
	| ewes lambsGpd min max|
	ewes := OvinaEwe all reject: [:ewe | ewe avgLambGrowthCompute <= 0 ].
	lambsGpd:= OvinaLamb all collect: [ :l | l gramPerDay  ] thenSelect: [ :gpd | gpd > 0 ].
	min := lambsGpd min.
	max := lambsGpd max.
	ewes do: [ :ewe |
		self assert: (ewe avgLambGrowthCompute between:  min and: max) .
		 ]
	
	
]

{ #category : #tests }
OvinaEweTest >> testAvgLemmingSize [
	"smoke test"
	| ewes |
	ewes := OvinaEwe all.
	ewes do: [ :ewe |
		self assert: ewe avgLemmingSize isNumber.
		 ]
	
]

{ #category : #tests }
OvinaEweTest >> testAvgLemmingSize_e45 [
	"test flica"
	| e45 |
	e45 := OvinaSheep sheeps at: 'E45'.
	self assert: e45 name equals: 'Flicka'.
	self assert: e45 avgLemmingSize equals: (1+2+2+2+1+2)/6
	
	
]

{ #category : #tests }
OvinaEweTest >> testAvgLemmingSize_senseTest [
	"smoke test"
	| ewes |
	ewes := OvinaEwe all.
	ewes do: [ :ewe |
		self assert: (ewe avgLemmingSize between: 0 and: 3).
		 ]
	
]

{ #category : #tests }
OvinaEweTest >> testSumOfLastThreeYearsCompute [
	"smoke test"
	| ewes |
	ewes := OvinaEwe all.
	ewes do: [ :ewe |
		self assert: ewe sumOfLastThreeYearsCompute isNumber.
		 ]
	
	
]

{ #category : #tests }
OvinaEweTest >> testSumOfLastThreeYearsCompute_e45 [
	"test flica"
	| e45 expected |
	e45 := OvinaSheep sheeps at: 'E45'.
	self assert: e45 name equals: 'Flicka'.
	expected := (OvinaSheep sheeps at: 'L658') gramPerDay "2021"
		+ (OvinaSheep sheeps at: 'L549') gramPerDay "2020"
		+ (OvinaSheep sheeps at: 'L550') gramPerDay "2020"
		+ (OvinaSheep sheeps at: 'L510') gramPerDay "2019"
		+ (OvinaSheep sheeps at: 'L509') gramPerDay "2019".
	
	self assert: e45 sumOfLastThreeYearsCompute closeTo: expected precision: 0.01.
	
	
]

{ #category : #tests }
OvinaEweTest >> testSumOfLastThreeYearsCompute_e67 [
	"test jytte"
	| e67 expected|
	e67 := OvinaSheep sheeps at: 'E67'.
	self assert: e67 name equals: 'Jytte'.
	expected := (OvinaSheep sheeps at: 'L645') gramPerDay.
	self assert: e67 sumOfLastThreeYearsCompute equals: expected * 3.
	
	
]
