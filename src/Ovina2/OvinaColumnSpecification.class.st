"
I am a class to hold a datastructure used by the column presenter
"
Class {
	#name : #OvinaColumnSpecification,
	#superclass : #Object,
	#instVars : [
		'dkName',
		'getter',
		'setter',
		'choices'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #comparing }
OvinaColumnSpecification >> = other [
	^ self getter = other getter and: [ self dkName = other dkName ]
]

{ #category : #accessing }
OvinaColumnSpecification >> choices [

	^ choices
]

{ #category : #accessing }
OvinaColumnSpecification >> choices: anObject [
	choices ifNotNil: [ self halt ].
	choices := anObject
]

{ #category : #accessing }
OvinaColumnSpecification >> dkName [

	^ dkName
]

{ #category : #accessing }
OvinaColumnSpecification >> dkName: anObject [

	dkName := anObject
]

{ #category : #accessing }
OvinaColumnSpecification >> getFrom: obj [
	^ obj perform: getter
]

{ #category : #accessing }
OvinaColumnSpecification >> getter [
	^ getter
]

{ #category : #accessing }
OvinaColumnSpecification >> getter: anObject [

	getter := anObject
]

{ #category : #comparing }
OvinaColumnSpecification >> hash [
	^ getter hash bitXor: dkName hash
]

{ #category : #printing }
OvinaColumnSpecification >> printOn: aStream [

	aStream nextPutAll: ('OvinaColumnSpecification [{1} {2}{3}{4}]' format:  {
		self dkName printString.
		self getter.
		self setter ifNotNil: [ '/',setter ] ifNil:[''].
		self choices ifNotNil: [ ' - ', choices printString ] ifNil: [ '' ] } )
]

{ #category : #accessing }
OvinaColumnSpecification >> set: value on: obj [
	^ obj perform: setter with: value
]

{ #category : #accessing }
OvinaColumnSpecification >> setter [

	^ setter
]

{ #category : #accessing }
OvinaColumnSpecification >> setter: anObject [

	setter := anObject
]
