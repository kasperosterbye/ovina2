"
I provide filtering of lambs based on dam or sire, and add lamb specific buttons to the general sheep presenter.
"
Class {
	#name : #OvinaLambPresenter,
	#superclass : #OvinaSheepPresenter,
	#instVars : [
		'filterDam',
		'filterSire'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #acccessing }
OvinaLambPresenter class >> sheepClass [
	^ OvinaLamb
]

{ #category : #accessing }
OvinaLambPresenter >> filterDam: dam [

	filterDam := dam.
	filterSire := nil.
	self updatePresenter
]

{ #category : #accessing }
OvinaLambPresenter >> filterSire: sire [

	filterSire := sire.
	filterDam := nil.
	self updatePresenter
]

{ #category : #initialization }
OvinaLambPresenter >> initialize [
	super initialize.
	onlyPresent := false
]

{ #category : #initialization }
OvinaLambPresenter >> initializeButtons [ 
	super initializeButtons.
	buttonBar  add: ( self newButton 
			label: 'Bliv får';
			action: [ self promoteToEwe  ])
	
]

{ #category : #events }
OvinaLambPresenter >> promoteToEwe [
	|lamb newEwe|
	lamb := table selection selectedItem.
	lamb ifNil: [ ^self ].
	newEwe := lamb promoteToEwe.
	newEwe ifNil: [ ^self ].
	self announcer announce: (OvinaGUILampPromotion new sheep: newEwe )
	
]

{ #category : #accessing }
OvinaLambPresenter >> sheeps [
	"Override to further filter by ewe or ram"
	
	|lambs| 
	lambs := super sheeps.
	filterDam ifNotNil: [ ^ lambs select: [ :lamb| lamb dam = filterDam ] ].
	filterSire ifNotNil: [ ^ lambs select: [ :lamb| lamb sire = filterSire ] ].
	^lambs
]

{ #category : #initialization }
OvinaLambPresenter >> title [
	^'Lam'
]
