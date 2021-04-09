Class {
	#name : #OvinaAllSheepsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'ewes',
		'rams',
		'lambs',
		'selectedParent',
		'selectedLamb'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #specs }
OvinaAllSheepsPresenter class >> defaultSpec [

	"Layout is taken from the instanceSide method setLayout:"
	self error: 'Should not be called'
]

{ #category : #specs }
OvinaAllSheepsPresenter class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #'as yet unclassified' }
OvinaAllSheepsPresenter >> filterLambsByDam: dam [
	lambs filterDam: dam
]

{ #category : #'as yet unclassified' }
OvinaAllSheepsPresenter >> filterLambsBySire: sire [
	lambs filterSire: sire
]

{ #category : #initialization }
OvinaAllSheepsPresenter >> initializePresenters [


	ewes := self instantiate: OvinaEwePresenter .
	rams := self instantiate: OvinaRamPresenter .
	lambs := self instantiate: OvinaLambPresenter .
	
	ewes whenSelectedDo: [ :ewe | self filterLambsByDam: ewe ].
	rams whenSelectedDo: [ :ram | self filterLambsBySire: ram ].
	
	self setLayout
	
	

	
]

{ #category : #initialization }
OvinaAllSheepsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Får, Lam & Væddere';
		initialExtent: 1200 @ 950 
]

{ #category : #accessing }
OvinaAllSheepsPresenter >> setLayout [
	self layout: (SpPanedLayout newHorizontal
		addFirst: (SpNotebookPresenter new 
			addPageTitle: 'Får' provider: [ewes];
			addPageTitle: 'Væddere' provider: [rams] );
		addSecond: (SpNotebookPresenter new 
			addPageTitle: 'Lam' provider: [lambs]))
]
