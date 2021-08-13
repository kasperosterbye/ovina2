"
An OvinaModelTest is a test class for testing the behavior of OvinaModel
"
Class {
	#name : #OvinaModelTest,
	#superclass : #OvinaTestCase,
	#category : #'Ovina2-Tests-Model'
}

{ #category : #running }
OvinaModelTest >> tearDown [
	OvinaModel initialize
]

{ #category : #tests }
OvinaModelTest >> testAnnounceChangeName [
	"Name is a property"
	| lamb lambRemoved|
	OvinaModel initialize.
	Ovina1DB loadAll.
	lamb := OvinaSheep lambs values first.
	self assert: lamb isNotNil.
	OvinaModel announcer 
		when: OvinaModelSheepRemoved 
		do: [ :ann | lambRemoved := ann sheep ].
	lamb remove.
	self assert: lamb equals: lambRemoved 
		
]

{ #category : #tests }
OvinaModelTest >> testAnnounceChangeNumber [
	"Number is an intrinsic value (not a property)"
	| number |
	OvinaModel initialize.
	Ovina1DB loadAll.
	OvinaModel announcer 
		when: OvinaModelSheepChanged
		do: [ :ann | number := ann sheep number ].
	number := -1.
	OvinaSheep rams values first number: 999.
	self assert: number equals: 999
		
]
