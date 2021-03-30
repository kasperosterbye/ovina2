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
		'presenters',
		'properties'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #specs }
OvinaSingleSheepPresenter class >> defaultSpec [

	^SpBoxLayout newVertical 
		add: #presenters
		yourself
]

{ #category : #'instance creation' }
OvinaSingleSheepPresenter class >> openOn: sheep [
	|instance|
	instance :=self basicNew sheep: sheep; initialize.
	instance openWithSpec
]

{ #category : #initialization }
OvinaSingleSheepPresenter >> initializePresenters [ 
	| aLayout|
	presenters := SpPresenter new.
	aLayout := (SpBoxLayout newTopToBottom spacing: 5).
	presenters layout: aLayout.
	properties do: [ :prop |
		aLayout add: (OvinaPropertyPresenter new
			label: prop dkName; 
			text: (sheep perform: prop getter) asString;
			whenSubmitDo:  [ :morph| self todo: morph text asString. ] )].
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
