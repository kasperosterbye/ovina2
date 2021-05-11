Class {
	#name : #OvinaHistSheepSelectionBackup,
	#superclass : #SpPresenter,
	#instVars : [
		'actionBar',
		'table',
		'filterPresent',
		'includeLambs',
		'sheeps',
		'sheepSelected'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #specs }
OvinaHistSheepSelectionBackup class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
		add: (SpBoxLayout newHorizontal add: #actionBar) expand: false fill: true padding: 3;
		yourself
]

{ #category : #examples }
OvinaHistSheepSelectionBackup class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #accessing }
OvinaHistSheepSelectionBackup >> filter: sheepCollection [
	filterPresent 
		ifTrue: [ ^ sheepCollection select: [ :sheep | sheep present ] ] 
		ifFalse: [ ^ sheepCollection  ]
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelectionBackup >> filteredLambsOf: anEwe [
	anEwe isEwe ifFalse: [ ^#() ].
	^ self filter: anEwe lambs
]

{ #category : #initialization }
OvinaHistSheepSelectionBackup >> initialize [
	filterPresent := true.
	includeLambs := true.
	sheepSelected := Dictionary new.
	
	super initialize.
]

{ #category : #initialization }
OvinaHistSheepSelectionBackup >> initializeButtons [

	actionBar := self newButtonBar
		add: (self newButton 
				 label: 'Fold ud';
				 action: [self expandAll ]);
		add: (self newButton 
				 label: 'Fold sammen';
				 action: [self collapseAll ]);
		add: (self newButton 
				 label: 'Afvælg alle';
				 action: [self deselectAll]);
		add: (self newButton 
				 label: 'Vælg alle';
				 action: [self selectAll]);
		add: (self newCheckBox
				 label: 'Aktuelle';
				 state: filterPresent ;
				 whenChangedDo: [ :newValue | 
					 filterPresent := newValue.
					 self updatePresenter ]);
		add: (self newCheckBox
				 label: 'Inkluder lam';
				 state: includeLambs ;
				 whenChangedDo: [ :newValue | 
					 includeLambs := newValue.
					 self updatePresenter ]);
		yourself 
]

{ #category : #initialization }
OvinaHistSheepSelectionBackup >> initializePresenters [
	
	super initializePresenters.
	
	self initializeButtons.
	self initializeTable.
	self updatePresenter 
]

{ #category : #initialization }
OvinaHistSheepSelectionBackup >> initializeTable [
	table := self instantiate: SpTablePresenter.
	table addColumn: (SpCheckBoxTableColumn new
			title: 'vælg' ;
			evaluated: [ :sheep | sheepSelected at: sheep ifAbsent: [ false ] ] ;
			onActivation: [ :sheep | self selectSheep: sheep];
			onDeactivation: [ :sheep | self unselectSheep: sheep ]);
		addColumn: (SpStringTableColumn new
			title: 'nummer' ;
			evaluated: [ :sheep | sheep number ] ;
			sortFunction: [ :s1 :s2 | 
				(s1 number asNumber) threeWayCompareTo:  (s2 number)] asSortFunction);
	   addColumn: (SpStringTableColumn new
			title: 'navn' ;
			evaluated: [:sheep | sheep name];
			sortFunction: [ :s1 :s2 | (s1 name) threeWayCompareTo:  (s2 name)] asSortFunction);
		beMultipleSelection.
]

{ #category : #initialization }
OvinaHistSheepSelectionBackup >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Udvælgelse';
		initialExtent: 600 @ 950 
]

{ #category : #selection }
OvinaHistSheepSelectionBackup >> selectAll [
	self roots do: [ :sheep | self selectSheep: sheep ] 
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelectionBackup >> selectSheep: sheep [
	sheepSelected at: sheep put: true.
	table selection selectItem: sheep.
	self announce: (OvinaGUIHistSelectorAdded new sheep: sheep).
	(includeLambs & sheep isEwe )
		ifTrue:[ (self filteredLambsOf: sheep) do: [ :lamb | self selectSheep: lamb] ]
	
]

{ #category : #initialization }
OvinaHistSheepSelectionBackup >> selected: someSheeps [
	"sendt from history presenter (my owner)"
	sheepSelected := Dictionary new.
	someSheeps do: [ :s | sheepSelected at: s put: true ].
	self updatePresenter.
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelectionBackup >> selectedSheeps [
	"return which sheeps are currently selected"
	^(sheepSelected select: [ :bool | bool ]) keys
]

{ #category : #accessing }
OvinaHistSheepSelectionBackup >> sheeps [
	^ self filter: OvinaSheep sheeps values
	
]

{ #category : #selection }
OvinaHistSheepSelectionBackup >> unselectAll [
	self roots do: [ :sheep | self unselectSheep: sheep ] 
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelectionBackup >> unselectSheep: sheep [
	sheepSelected at: sheep put: false.
	table selection unselectItem: sheep.
	self announce: (OvinaGUIHistSelectorRemoved new sheep: sheep).
	(includeLambs & sheep isEwe )
		ifTrue:[ ((self filteredLambsOf: sheep) ) do: [ :lamb | self unselectSheep: lamb ] ]
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelectionBackup >> updatePresenter [
	table items: self sheeps.
	
	
	
	 
	
]
