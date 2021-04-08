Class {
	#name : #OvinaLambPresenter,
	#superclass : #OvinaSheepPresenter,
	#instVars : [
		'filterDam',
		'filterSire'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #accessing }
OvinaLambPresenter >> filterDam: anObject [

	filterDam := anObject
]

{ #category : #accessing }
OvinaLambPresenter >> filterSire: anObject [

	filterSire := anObject
]

{ #category : #initialization }
OvinaLambPresenter >> initializeButtons [ 
	super initializeButtons.
	
]

{ #category : #acccessing }
OvinaLambPresenter >> sheepClass [
	^ OvinaLamb
]

{ #category : #accessing }
OvinaLambPresenter >> sheeps [
	"Override to further filter by ewe or ram"
	
	|lambs| 
	lambs := super sheeps.
	filterDam ifNotNil: [ ^ lambs select: [ :lamb| lamb dam = filterDam ] ].
	filterSire ifNotNil: [ ^ lambs select: [ :lamb| lamb sire = filterSire ] ]
]

{ #category : #initialization }
OvinaLambPresenter >> title [
	^'Lam'
]
