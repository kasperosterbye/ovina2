Class {
	#name : #OvinaSheepTest,
	#superclass : #TestCase,
	#category : #'Ovina2-Tests-Model'
}

{ #category : #tests }
OvinaSheepTest >> testProperty [
	| ram |
	ram := OvinaRam new.
	ram property: #foo put: 88.
	self assert: (ram property: #foo) equals: 88
]

{ #category : #tests }
OvinaSheepTest >> testPropertyTwoSheeps [
	| ram1 ram2|
	ram1 := OvinaRam new id: #ram1.
	ram2 := OvinaRam new id: #ram2.
	ram1 property: #foo put: 88.
	ram2 property: #foo put: 77.
	self assert: (ram1 property: #foo) equals: 88.
]
