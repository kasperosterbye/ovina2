"
An OvinaRaceTest is a test class for testing the behavior of OvinaRace
"
Class {
	#name : #OvinaRaceTest,
	#superclass : #TestCase,
	#category : #'Ovina2-Tests-Model'
}

{ #category : #tests }
OvinaRaceTest >> testAddRaces [
	self 
		assert: ((OvinaRace fromString: 'såne') + (OvinaRace fromString: 'såne') ) printString
		equals: '1Såne'.
	self 
		assert: ((OvinaRace fromString: 'såne') + (OvinaRace fromString: 'texel') ) printString
		equals: '1Såne1Texel'.
	self 
		assert: ((OvinaRace fromString: '2såne4texel') + (OvinaRace fromString: '1såne2texel') ) printString
		equals: '1Såne2Texel'.
]

{ #category : #tests }
OvinaRaceTest >> testMixedRace [
	self assert: (OvinaRace fromString: '1såne1texel') printString equals: '1Såne1Texel'.
	self assert: (OvinaRace fromString: '2Såne2Texel') printString equals: '1Såne1Texel'.
	self assert: (OvinaRace fromString: '3Såne6Texel') printString equals: '1Såne2Texel'.
	self assert: (OvinaRace fromString: '5Såne2Texel1Lüne') printString equals: '1Lüne5Såne2Texel'.
]

{ #category : #tests }
OvinaRaceTest >> testPureRace [
	self assert: (OvinaRace fromString: 'såne') printString equals: '1Såne'.
	self assert: (OvinaRace fromString: 'Såne') printString equals: '1Såne'.
	self assert: (OvinaRace fromString: 'Såne') printString equals: '1Såne'.
	self assert: (OvinaRace fromString: '1såne') printString equals: '1Såne'.	
	self assert: (OvinaRace fromString: '17såne') printString equals: '1Såne'.	
]
