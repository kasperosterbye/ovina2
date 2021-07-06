Class {
	#name : #OvinaLabeledPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'label',
		'input'
	],
	#category : #'Ovina2-GUI General'
}

{ #category : #specs }
OvinaLabeledPresenter class >> defaultSpec [
	^ (SpBoxLayout newTopToBottom spacing: 0)
		add: #label withConstraints: [:cons | cons height: self labelHeight ];
		add: #input expand: true fill: true padding: 1;
		yourself
]

{ #category : #initialization }
OvinaLabeledPresenter >> initializePresenters [
	label := self newLabel.
]

{ #category : #accessing }
OvinaLabeledPresenter >> input [

	^ input
]

{ #category : #accessing }
OvinaLabeledPresenter >> input: anObject [

	input := anObject
]

{ #category : #accessing }
OvinaLabeledPresenter >> label: aString [

	label label: aString
]
