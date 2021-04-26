Class {
	#name : #OvinaLabelledContainer,
	#superclass : #SpPresenter,
	#instVars : [
		'label',
		'subwidget',
		'labelLayout'
	],
	#category : #'Ovina2-GUI General'
}

{ #category : #specs }
OvinaLabelledContainer class >> defaultSpec [
	^ self labelTop
]

{ #category : #specs }
OvinaLabelledContainer class >> labelBottom [
	<spec>
	^ SpBoxLayout newTopToBottom
		add: #subwidget;
		add: #label
			expand: false
			fill: false
			padding: 0;
		yourself
]

{ #category : #specs }
OvinaLabelledContainer class >> labelLeft [
	<spec>
	^ SpBoxLayout newLeftToRight
		add: #label
			expand: false
			fill: false
			padding: 0;
		add: #subwidget;
		yourself
]

{ #category : #specs }
OvinaLabelledContainer class >> labelRight [
	<spec>
	^ SpBoxLayout newLeftToRight
		add: #subwidget;
		add: #label
			expand: false
			fill: false
			padding: 0;
		yourself
]

{ #category : #specs }
OvinaLabelledContainer class >> labelTop [
	<spec>
	^ SpBoxLayout newTopToBottom
		add: #label
			expand: false
			fill: false
			padding: 0;
		add: #subwidget;
		yourself
]

{ #category : #initialization }
OvinaLabelledContainer >> content: aWidgetClass [
	subwidget := self instantiate: aWidgetClass.
	self focusOrder add: subwidget
]

{ #category : #showing }
OvinaLabelledContainer >> defaultSpecSelector [
	self labelLayout ifNil: [ ^ #defaultSpec ].
	^  labelLayout 
]

{ #category : #'error handling' }
OvinaLabelledContainer >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: subwidget
]

{ #category : #initialization }
OvinaLabelledContainer >> initializePresenters [
	label := self instantiate: SpLabelPresenter.
]

{ #category : #accessing }
OvinaLabelledContainer >> label [
	^ label
]

{ #category : #accessing }
OvinaLabelledContainer >> label: aString [
	label label: aString
]

{ #category : #accessing }
OvinaLabelledContainer >> labelLayout [

	^ labelLayout
]

{ #category : #accessing }
OvinaLabelledContainer >> labelLayout: anObject [

	labelLayout := anObject
]

{ #category : #showing }
OvinaLabelledContainer >> retrieveDefaultSpec [
	self labelLayout ifNil: [ ^ self class defaultSpec ].
	^ self class perform: labelLayout 
]

{ #category : #accessing }
OvinaLabelledContainer >> subwidget [
	^ subwidget
]

{ #category : #accessing }
OvinaLabelledContainer >> subwidget: anObject [
	subwidget := anObject
]
