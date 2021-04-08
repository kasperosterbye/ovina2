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
		'actionBar'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #specs }
OvinaSingleSheepPresenter class >> defaultSpec [

	^SpBoxLayout newVertical 
		add: #propertyPresenters
		yourself
]

{ #category : #'instance creation' }
OvinaSingleSheepPresenter class >> openOn: sheep [
	|instance|
	instance :=self basicNew sheep: sheep; initialize.
	instance openWithSpec
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
				 action: [ self nextSheep  ])
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> initializePresenters [ 
	| aLayout|
	propertyPresenters := SpPresenter new.
	aLayout := (SpBoxLayout newTopToBottom spacing: 5).
	propertyPresenters layout: aLayout.
	properties do: [ :prop |
		aLayout add: (OvinaPropertyPresenter new
			labelLayout: #labelTop;
			label: prop dkName; 
			text: (sheep perform: prop getter) asString;
			whenTextChanged:  [ :newText| sheep perform: prop setter with: newText. ] ) ].
	
	self initializeActionBar.
	self layout: self myLayout 
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
		add: (SpBoxLayout newHorizontal add: #actionBar) expand: false fill: true padding: 3;
		yourself
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> nextSheep [
	self todo.
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> previousSheep [
	self todo.
]

{ #category : #accessing }
OvinaSingleSheepPresenter >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaSingleSheepPresenter >> sheep: aSheep [
	| order |
	sheep := aSheep.
	properties := aSheep class allColumns select: [ :col | col setter notNil  ].
	"reverse the order as indexOf: return zero if not present"
	order := sheep defaultPropertyOrder reversed.
	properties sort: [ :p1 :p2 |  (order indexOf: p1 getter) > (order indexOf: p2 getter)].
	
]
