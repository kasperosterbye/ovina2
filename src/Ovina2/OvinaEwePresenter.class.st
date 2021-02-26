Class {
	#name : #OvinaEwePresenter,
	#superclass : #OvinaSheepPresenter,
	#category : #'Ovina2-GUI'
}

{ #category : #initialization }
OvinaEwePresenter >> initializeButtons [ 
	super initializeButtons.
	buttonBar add: (self newButton 
			label: 'Nyt lam';
			action: [ self error:'Not implemented yet' ])
]

{ #category : #acccessing }
OvinaEwePresenter >> sheepClass [
	^ OvinaEwe
]

{ #category : #initialization }
OvinaEwePresenter >> title [
	^'Får'
]
