"
I implement the table of sheeps to select for a registration.
"
Class {
	#name : #OvinaHistSheepSelection,
	#superclass : #SpPresenter,
	#instVars : [
		'actionBar',
		'table',
		'filterPresent',
		'includeLambs',
		'sheeps',
		'sheepSelected',
		'changedAction'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #specs }
OvinaHistSheepSelection class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
		add: (SpBoxLayout newHorizontal add: #actionBar) expand: false fill: true padding: 3;
		yourself
]

{ #category : #examples }
OvinaHistSheepSelection class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #initialization }
OvinaHistSheepSelection >> initialize [
	filterPresent := true.
	includeLambs := true.
	sheepSelected := Dictionary new.
	
	super initialize.
]

{ #category : #initialization }
OvinaHistSheepSelection >> initializeButtons [
	 
	actionBar   := self newButtonBar.
	actionBar 
		add: (self newButton
				 label: 'Todo';
				 action: [ self error: 'to be implemented' ]);
		add: (self newCheckBox
				 label: 'Aktuelle';
				 whenChangedDo: [ :newValue | 
					 filterPresent := newValue.
					 self updatePresenter ]);
		add: (self newCheckBox
				 label: 'Inkluder lam';
				 whenChangedDo: [ :newValue | 
					 includeLambs := newValue.
					 self updatePresenter ])
]

{ #category : #initialization }
OvinaHistSheepSelection >> initializePresenters [
	
	super initializePresenters.
	
	self initializeButtons.
	self initializeTable.
	self updatePresenter 
]

{ #category : #initialization }
OvinaHistSheepSelection >> initializeTable [
	table := self instantiate: SpTablePresenter.
	table addColumn: (SpCheckBoxTableColumn new
			title: 'vælg' ;
			evaluated: [ :sheep | sheepSelected at: sheep ifAbsent: [ false ] ] ;
			onActivation: [ :sheep | self toggleSheepSelection: sheep];
			onDeactivation: [ :sheep | self toggleSheepSelection: sheep ]);
		addColumn: (SpStringTableColumn new
			title: 'nummer' ;
			evaluated: [ :sheep | sheep number ] ;
			sortFunction: [ :s1 :s2 | 
				(s1 number asNumber) threeWayCompareTo:  (s2 number)] asSortFunction);
	   addColumn: (SpStringTableColumn new
			title: 'navn' ;
			evaluated: [:sheep | sheep name];
			sortFunction: [ :s1 :s2 | (s1 name) threeWayCompareTo:  (s2 name)] asSortFunction);
		sortingBlock: [ :s1 :s2 | 
				(s2 number asNumber) threeWayCompareTo:  (s1 number asNumber)] asSortFunction;
		beMultipleSelection
]

{ #category : #initialization }
OvinaHistSheepSelection >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Udvælgelse';
		initialExtent: 600 @ 950 
]

{ #category : #initialization }
OvinaHistSheepSelection >> selected: someSheeps [
	sheepSelected := Dictionary new.
	someSheeps do: [ :s | sheepSelected at: s put: true ].
	self updatePresenter.
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> selectedSheeps [
	"return which sheeps are currently selected"
	^(sheepSelected select: [ :bool | bool ]) keys
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> toggleSheepSelection: sheep [
	sheepSelected at: sheep put: (sheepSelected at: sheep ifAbsent:[false] ) not.
	(sheepSelected at: sheep)
		ifTrue: [ table selection selectItem: sheep ] 
		ifFalse: [ table selection unselectItem: sheep ]
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> updatePresenter [
	sheeps  ifNil: [sheeps := OvinaSheep sheeps select: [ :sheep | filterPresent ==> sheep present  ]].
	table items: sheeps.
	changedAction ifNotNil: [ changedAction value ]
	
	
	
	 
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> whenChangedDo: aBlock [
	changedAction := aBlock
]
