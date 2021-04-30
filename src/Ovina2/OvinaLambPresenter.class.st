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
OvinaLambPresenter >> initializeButtons [ 
	super initializeButtons.
	
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
