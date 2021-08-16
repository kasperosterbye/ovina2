"
I add a few Ewe specific buttons to the general sheep presenter
"
Class {
	#name : #OvinaEwePresenter,
	#superclass : #OvinaSheepPresenter,
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #acccessing }
OvinaEwePresenter class >> sheepClass [
	^ OvinaEwe
]

{ #category : #adding }
OvinaEwePresenter >> addLambForSelectedEwe [
	|dam newLamb|
	dam := table selection selectedItem.
	dam ifNil: [ OvinaApp beep. ^ self ].
	newLamb := dam newLamb.
	self announcer announce: (OvinaGUILampBorn new sheep: newLamb )
	
	
]

{ #category : #initialization }
OvinaEwePresenter >> initializeButtons [

	super initializeButtons.
	buttonBar
		add: (self newButton
				 label: 'Nyt får';
				 action: [ self newEwe ]);
		add: (self newButton
				 label: 'Nyt lam';
				 action: [ self addLambForSelectedEwe ])
]

{ #category : #'instance creation' }
OvinaEwePresenter >> newEwe [

	| newEwe |
	(OvinaApp confirm: 'Registrer nyt får?') ifFalse: [ ^self ].
	newEwe := OvinaEwe newEwe.
	table selection selectItem: newEwe.
	self editSheep
]

{ #category : #initialization }
OvinaEwePresenter >> title [
	^'Får'
]
