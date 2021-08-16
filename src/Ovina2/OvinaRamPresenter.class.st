"
I add a few Ram specific buttons to the general sheep presenter
"
Class {
	#name : #OvinaRamPresenter,
	#superclass : #OvinaSheepPresenter,
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #acccessing }
OvinaRamPresenter class >> sheepClass [
	^ OvinaRam 
]

{ #category : #initialization }
OvinaRamPresenter >> initializeButtons [ 
	super initializeButtons.
	buttonBar add: (self newButton 
			label: 'Ny vædder';
			action: [ self newRam ])
]

{ #category : #'instance creation' }
OvinaRamPresenter >> newRam [

	| newRam |
	(OvinaApp confirm: 'Registrer ny vædder?') ifFalse: [ ^ self ].
	newRam := OvinaRam newRam.
	table selection selectItem: newRam.
	self editSheep
]

{ #category : #initialization }
OvinaRamPresenter >> title [
	^'Væddere'
]
