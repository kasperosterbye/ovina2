Class {
	#name : #OvinaRam,
	#superclass : #OvinaSheep,
	#category : #'Ovina2-Model'
}

{ #category : #'accessing - properties' }
OvinaRam >> name [
	
	<sheepColumn: #('navn' name:)>
	^ self property: #name
]

{ #category : #'accessing - properties' }
OvinaRam >> name: name [
	^self property: #name put: name
]

{ #category : #printing }
OvinaRam >> printOn: aStream [
	aStream nextPutAll: 'Ram '.
	super printOn: aStream
]
