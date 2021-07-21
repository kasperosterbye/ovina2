Class {
	#name : #OvinaModelElement,
	#superclass : #Model,
	#instVars : [
		'cachings'
	],
	#category : #'Ovina2-Model'
}

{ #category : #caching }
OvinaModelElement >> cache: symbol compute: block [
	^ cachings at: symbol ifAbsentPut: block
	
]

{ #category : #initialization }
OvinaModelElement >> initialize [
	super initialize.
	cachings := Dictionary new.
]

{ #category : #caching }
OvinaModelElement >> invalidateCache [
	cachings := Dictionary new.
	OvinaModel announcer announce: (OvinaModelSheepChanged new sheep: self)
]
