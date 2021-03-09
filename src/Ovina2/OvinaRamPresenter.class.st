Class {
	#name : #OvinaRamPresenter,
	#superclass : #OvinaSheepPresenter,
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #initialization }
OvinaRamPresenter >> initializeButtons [ 
	super initializeButtons.
	buttonBar add: (self newButton 
			label: 'Ny vædder';
			action: [ self error:'Not implemented yet' ])
]

{ #category : #acccessing }
OvinaRamPresenter >> sheepClass [
	^ OvinaRam 
]

{ #category : #initialization }
OvinaRamPresenter >> title [
	^'Væddere'
]
