"
I represent a column, with getter and setter and danish name.
I am also used in the OvinaSingleSheepPresenter to create an editor for those aspects of a sheep which can be editet (has a setter).
If the values of a column/field is an enumeration, my `choices` variable holds this.
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

{ #category : #'building presentations' }
OvinaColumnSpecification >> buildPresenterForSheep: sheep [
	choices ifNil: 
		[ ^ (SpTextInputFieldPresenter new
				text: (sheep perform: getter) asString;
				whenTextChangedDo:  [ :newText| sheep perform: setter with: newText];
				yourself) 
			withLabelAtTop: dkName  ].
	^ (SpBoxLayout newTopToBottom spacing: 0)
		add: (SpLabelPresenter new label: dkName) 
			withConstraints: [:cons | cons height: SpPresenter labelHeight ];
		add: (SpDropListPresenter new
			items: choices;
			whenSelectedItemChangedDo: [ :newText| sheep perform: setter with: newText];
			yourself) 
		withConstraints: [:cons | cons height: SpPresenter labelHeight+4];
		yourself
]

{ #category : #accessing }
OvinaColumnSpecification >> choices [

	^ choices
]

{ #category : #accessing }
OvinaColumnSpecification >> choices: anObject [
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
