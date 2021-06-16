"
I am the toplevel presenter to show sheep.

I have two primary panes

- Ewe/Ram (OvinaEwePresenter and (OvinaRamPresenter)
- Lambs (OvinaLambPresenter)

Selecting an Ewe or Ram limits the Lambs view to only the offspring of that selected sheep.

I make use of a number of pop-up presentes as well:

- OvinaColumnPresenter which is used to select which columns to show for the three kinds of sheeps.
- OvinaSingleSheepPresenter which is used to edit the properties of a selected sheep.
"
Class {
	#name : #OvinaAllSheepsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'ewes',
		'rams',
		'lambs',
		'overview',
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

{ #category : #initialization }
OvinaAllSheepsPresenter >> initializePresenters [


	ewes := self instantiate: OvinaEwePresenter .
	rams := self instantiate: OvinaRamPresenter .
	lambs := self instantiate: OvinaLambPresenter .
	overview := OvinaOverviewPresenter new.
	
	ewes announcer 
		when: OvinaGUISheepSelectionChanged 
		do: [ :ann |
			lambs filterDam: ann sheep.
		 	overview sheep: ann sheep];
		when: OvinaGUILampBorn 
		do: [:ann | lambs setSelected: ann sheep].
	rams announcer 
		when: OvinaGUISheepSelectionChanged 
		do: [ :ann | 
			lambs filterSire: ann sheep.
		 	overview sheep: ann sheep ].
	lambs announcer
		when: OvinaGUILampPromotion 
		do: [ :ann | ewes setSelected: ann sheep ].
	self setLayout.
	
	

	
]

{ #category : #initialization }
OvinaAllSheepsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Får, Lam & Væddere';
		initialExtent: 1300 @ 950 
]

{ #category : #accessing }
OvinaAllSheepsPresenter >> setLayout [
	self layout: (SpPanedLayout newHorizontal
		addFirst: (SpNotebookPresenter new 
			addPageTitle: 'Får' provider: [ewes];
			addPageTitle: 'Væddere' provider: [rams] );
		addSecond: (SpNotebookPresenter new 
			addPageTitle: 'Lam' provider: [lambs];
			addPage: overview ))
]
