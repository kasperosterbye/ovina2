Class {
	#name : #OvinaEwe,
	#superclass : #OvinaSheep,
	#category : #'Ovina2-Model'
}

{ #category : #'accessing - properties' }
OvinaEwe >> name [
	<sheepColumn>
	^ self property: #name
]

{ #category : #'accessing - properties' }
OvinaEwe >> name: name [
	^self property: #name put: name
]

{ #category : #printing }
OvinaEwe >> printOn: aStream [
	aStream nextPutAll: 'Ewe '.
	super printOn: aStream
]
