Class {
	#name : #OvinaEwePresenter,
	#superclass : #OvinaSheepPresenter,
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #acccessing }
OvinaEwePresenter class >> sheepClass [
	^ OvinaEwe
]

{ #category : #initialization }
OvinaEwePresenter >> initializeButtons [ 
	super initializeButtons.
	buttonBar add: (self newButton 
			label: 'Nyt lam';
			action: [ self error:'Not implemented yet' ])
]

{ #category : #initialization }
OvinaEwePresenter >> title [
	^'Får'
]
