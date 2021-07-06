"
I am a presenter for a single sheep.

I am intended to provide a convenient edit facility for individual sheeps using a property sheet.

I have two sections:

* Identity section (chr, number, and optionally name)
* Other section (all other defined properties)

The properties to show is controlled by the column mechanism - see `OvinaSheep>>allColumns`
"
Class {
	#name : #OvinaSingleSheepPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'sheep',
		'properties',
		'propertyPresenters',
		'actionBar',
		'sheepBlock',
		'prevBlock',
		'nextBlock',
		'closeBlock'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #'instance creation' }
OvinaSingleSheepPresenter class >> on: sheepBlock [
	^ self basicNew sheepBlock: sheepBlock; initialize.
	
]

{ #category : #'initialize-release' }
OvinaSingleSheepPresenter >> close [
	closeBlock value.
	self owner close.
]

{ #category : #'initialize-release' }
OvinaSingleSheepPresenter >> closeBlock: aBlock [
	closeBlock := aBlock
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> initializeActionBar [ 

	actionBar := self newButtonBar.
	actionBar  
		add: (self newButton
				 label: 'Forrige';
				 action: [ self previousSheep  ]);
		add: (self newButton
				 label: 'Næste';
				 action: [ self nextSheep  ]);
		add: (self newButton
				 label: 'Luk';
				 action: [ self close  ])
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> initializePresenters [
	self initializePropertyPresenters.
	self initializeActionBar.
	self layout: self myLayout 
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> initializePropertyPresenters [
	| aLayout|
	propertyPresenters ifNil: [propertyPresenters := SpPresenter new].
	aLayout := (SpBoxLayout newTopToBottom spacing: 5).
	properties do: [ :prop |
		aLayout add: (
			(SpTextInputFieldPresenter new
				text: (self sheep perform: prop getter) asString;
				whenTextChangedDo:  [ :newText| self sheep perform: prop setter with: newText];
				yourself) 
			withLabelAtTop: prop dkName  )  ].
	propertyPresenters layout: aLayout.
	
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Ret ', sheep kind;
		initialExtent: 500 @ (properties size * 50 + 40). 
]

{ #category : #'as yet unclassified' }
OvinaSingleSheepPresenter >> myLayout [
	^ SpBoxLayout newVertical 
		add: #propertyPresenters;
		add: #actionBar expand: false fill: true padding: 3;
		yourself
]

{ #category : #accessing }
OvinaSingleSheepPresenter >> nextBlock: anObject [

	nextBlock := anObject
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> nextSheep [
	nextBlock value.
	self updatePresenter 
]

{ #category : #accessing }
OvinaSingleSheepPresenter >> prevBlock: anObject [

	prevBlock := anObject
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> previousSheep [
	prevBlock value.
	self updatePresenter 
]

{ #category : #accessing }
OvinaSingleSheepPresenter >> sheep [
	|order|
	sheep ifNotNil: [ ^sheep ].
	sheep := sheepBlock value.
	properties := sheep class allColumns select: [ :col | col setter notNil  ].
	"reverse the order as indexOf: return zero if not present"
	order := sheep defaultPropertyOrder reversed.
	properties sort: [ :p1 :p2 |  (order indexOf: p1 getter) > (order indexOf: p2 getter)].
	^sheep
]

{ #category : #accessing }
OvinaSingleSheepPresenter >> sheep: aSheep [
	self error: 'Should not be called'
	
]

{ #category : #accessing }
OvinaSingleSheepPresenter >> sheepBlock: aBlock [
	sheepBlock := aBlock.
	self sheep
	
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> updatePresenter [
	"I set a new sheep using sheepBlock"
	sheep := nil.
	self sheep.
	self initializePropertyPresenters.
	self takeKeyboardFocus
	
]
