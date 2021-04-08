Class {
	#name : #OvinaPropertyPresenter,
	#superclass : #SpLabelledTextInput,
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #specs }
OvinaPropertyPresenter class >> defaultSpec [
	^ self labelTop
]

{ #category : #initialization }
OvinaPropertyPresenter >> initialize [
	super initialize.
	
	self subwidget bindKeyCombination: $n meta toAction: [self singleSheepPresenter nextSheep].
	self subwidget bindKeyCombination: $f meta toAction: [self singleSheepPresenter previousSheep]
	
]

{ #category : #'as yet unclassified' }
OvinaPropertyPresenter >> singleSheepPresenter [
	|up|
	up := self.
	[ up class = OvinaSingleSheepPresenter  ] whileFalse: [ up := up owner ].
	^up
]
