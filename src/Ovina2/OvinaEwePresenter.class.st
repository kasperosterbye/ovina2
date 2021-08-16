"
I add a few Ewe specific buttons to the general sheep presenter
"
Class {
	#name : #OvinaEwePresenter,
	#superclass : #OvinaSheepPresenter,
	#instVars : [
		'buttonBar2'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #acccessing }
OvinaEwePresenter class >> sheepClass [
	^ OvinaEwe
]

{ #category : #adding }
OvinaEwePresenter >> addLambForSelectedEwe [

	| dam newLamb |
	dam := table selection selectedItem.
	dam ifNil: [ 
		OvinaApp errorMessage: 'Vælg et moderdyr først'.
		^ self ].
	newLamb := dam newLamb.
	self announcer announce: (OvinaGUILampBorn new sheep: newLamb)
]

{ #category : #initialization }
OvinaEwePresenter >> initializeButtons [

	super initializeButtons.
	buttonBar2 := self newButtonBar.
	buttonBar2
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
OvinaEwePresenter >> setLayout [

	super setLayout.
	self layout
		add: (SpBoxLayout newHorizontal add: buttonBar2)
		expand: false
		fill: true
		padding: 3
]

{ #category : #initialization }
OvinaEwePresenter >> title [
	^'Får'
]
