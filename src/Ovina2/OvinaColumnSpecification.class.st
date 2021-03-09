Class {
	#name : #OvinaColumnSpecification,
	#superclass : #Object,
	#instVars : [
		'dkName',
		'getter',
		'setter'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #accessing }
OvinaColumnSpecification >> dkName [

	^ dkName
]

{ #category : #accessing }
OvinaColumnSpecification >> dkName: anObject [

	dkName := anObject
]

{ #category : #accessing }
OvinaColumnSpecification >> getter [

	^ getter
]

{ #category : #accessing }
OvinaColumnSpecification >> getter: anObject [

	getter := anObject
]

{ #category : #printing }
OvinaColumnSpecification >> printOn: aStream [

	aStream nextPutAll: ('OvinaColumn [{1} {2}{3}]' format:  {
		self dkName printString.
		self getter.
		self setter ifNotNil: [ '/',setter ] ifNil:[''] } )
]

{ #category : #accessing }
OvinaColumnSpecification >> setter [

	^ setter
]

{ #category : #accessing }
OvinaColumnSpecification >> setter: anObject [

	setter := anObject
]