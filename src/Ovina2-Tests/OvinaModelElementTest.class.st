"
An OvinaModelElementTest is a test class for testing the behavior of OvinaModelElement
"
Class {
	#name : #OvinaModelElementTest,
	#superclass : #OvinaTestCase,
	#category : #'Ovina2-Tests-Model'
}

{ #category : #test }
OvinaModelElementTest >> testCacheCompute [
	"Test that cache block is executed"
	|subject|
	subject := OvinaModelElementTestSubject new.
	subject count: 88.
	self assert: (subject cachedValue ) equals: 90
]

{ #category : #test }
OvinaModelElementTest >> testCacheCompute2 [
	"test that we use cached value, and not compute again"
	|subject|
	subject := OvinaModelElementTestSubject new.
	subject count: 88.
	self assert: (subject cachedValue ) equals: 90.
	subject count: 8.
	self assert: (subject cachedValue ) equals: 90.
]

{ #category : #test }
OvinaModelElementTest >> testInvalidateCache [
	|subject|
	subject := OvinaModelElementTestSubject new.
	subject count: 88.
	self assert: (subject cachedValue ) equals: 90.
	subject count: 8.
	self assert: (subject cachedValue ) equals: 90.
	subject invalidateCache.
	self assert: (subject cachedValue ) equals: 10.
]
