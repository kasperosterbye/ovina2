"
I am a subject to test the caching of OvinaModelElement
"
Class {
	#name : #OvinaModelElementTestSubject,
	#superclass : #OvinaModelElement,
	#instVars : [
		'count'
	],
	#category : #'Ovina2-Tests-Model'
}

{ #category : #'as yet unclassified' }
OvinaModelElementTestSubject >> cachedValue [
	^ self cache: #cachedValue compute: [ count + 2 ]
]

{ #category : #accessing }
OvinaModelElementTestSubject >> count [

	^ count
]

{ #category : #accessing }
OvinaModelElementTestSubject >> count: anObject [

	count := anObject
]
