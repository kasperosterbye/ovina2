"
* allColumns is an ordered collection of associations of OvinaColumnSpecifications to boolean (indicating if column should be included in the view)
<!-- bla -->
"
Class {
	#name : #OvinaSheepPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'buttonBar',
		'columnSelector',
		'onlyPresent',
		'location'
	],
	#classInstVars : [
		'allColumns'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #accessing }
OvinaSheepPresenter class >> allColumns: anObject [

	allColumns := anObject
]

{ #category : #examples }
OvinaSheepPresenter class >> open [
	self new openWithSpec 
]

{ #category : #accessing }
OvinaSheepPresenter class >> sheepClass [
	^self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter class >> threeWayCompare: a to: b [
	a ifNil: [ ^ -1 ].
	b ifNil: [ ^ 1 ].
	^ a threeWayCompareTo: b
]

{ #category : #selection }
OvinaSheepPresenter >> announceNewSelection: sheep [
	"Currently selected sheep changed"
	
	self announcer announce: (OvinaGUISheepSelectionChanged new sheep: sheep)
]

{ #category : #actions }
OvinaSheepPresenter >> editSheep [
	"OvinaSingleSheepPresenter openOn: table selection selectedItem"
	|editor|
	table selection isEmpty ifTrue: [ table selection selectIndexes: #(1) ].
	editor := OvinaSingleSheepPresenter on: [ table selection selectedItem ].
	editor
		prevBlock: [ self selectPreviousSheep  ];
		nextBlock: [ self selectNextSheep  ].
	editor openWithSpec.
	 
]

{ #category : #accessing }
OvinaSheepPresenter >> filter: sheepCollection [
	"return a filtered sheepCollection"
	"onlyPresent location onlyLambs "
	| filtered | 
	filtered := sheepCollection.
	onlyPresent ifTrue: [ filtered := filtered select: [ :sheep | sheep present ]].
	location = 'alle' ifFalse: [ 
		filtered := filtered select: [ :sheep | 
			sheep location asLowercase = location  ]].
	^filtered
]

{ #category : #initialization }
OvinaSheepPresenter >> initialize [

	onlyPresent := true.
	location := 'alle'.
	columnSelector := OvinaColumnSelection 
		for: self class sheepClass name.
	super initialize.
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeButtons [

	buttonBar := self newButtonBar.
	buttonBar
		add: (self newDropList  
				 "label: 'placering';"
				 items: #('alle' 'hjemme' 'losse' 'konge');
				 whenSelectedItemChangedDo: [ :newValue | 
					location := newValue. 
					self updatePresenter ]);
		add: (self newCheckBox 
				 label: 'aktuelle';
				 state: onlyPresent;
				 whenChangedDo: [ :newValue | 
					onlyPresent := newValue. 
					self updatePresenter ]);
		add: (self newButton
				 icon: (Smalltalk ui icons iconNamed: #smallPrint);
				 label: 'Print';
				 action: [ self printTable ]);
		add: (self newButton
				 icon: (Smalltalk ui icons iconNamed: #edit);
				 label: 'Ret';
				 action: [ self editSheep ]);
		add: (self newButton
				 label: 'Vælg';
				 icon: (Smalltalk ui icons iconNamed: #smallBarcode);
				 action: [ self selectColumns ])
]

{ #category : #initialization }
OvinaSheepPresenter >> initializePresenters [
	 
	self initializeTable.
	self initializeButtons.
	self setLayout.
	OvinaModel announcer 
		when: OvinaModelSheepChanged do: [ :ann |
			(ann sheep class = self class sheepClass) ifTrue: [self updatePresenter] ];
		when: OvinaModelSheepRemoved do: [ self updatePresenter ]
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeTable [
	|cols|
	table ifNil: [ 
		table := self instantiate: OvinaTablePresenter.
		table 
			whenSelectedDo: [ :sheep | self announceNewSelection: sheep];
			whenNoneSelectedDo: [ self announceNewSelection: nil ].
		table announcer 
			when: SpWidgetBuilt do: [ :ann | 
			ann widget allowsDeselection: true.]].
	
	cols := columnSelector activeColumns collect:  [ :col |
		SpStringTableColumn new
				 "width: col width + 15;"
				 title: col dkName ;
				 evaluated: [ :sheep | (col getFrom: sheep) asDKString ] ;
				 sortFunction: [ :s1 :s2 | 
					self class threeWayCompare: (col getFrom: s1) to: (col getFrom: s2)
				] asSortFunction
	 ].
	table columns: cols.
	
	
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self title;
		initialExtent: 600 @ 350 
]

{ #category : #printing }
OvinaSheepPresenter >> printTable [
	|tablePrinter|
	tablePrinter := OvinaTablePrinter new
		title: 'Udskrift af ', self title;
		table: table.
	tablePrinter printTable
		
]

{ #category : #removing }
OvinaSheepPresenter >> removeAnnouncements [
	OvinaModel announcer unsubscribe: self.
	table announcer unsubscribe: self.
	columnSelector announcer unsubscribe: self
]

{ #category : #selection }
OvinaSheepPresenter >> selectColumns [
	|colSelPresenter subscription|
	colSelPresenter := OvinaColumnPresenter new on: columnSelector.
	subscription := columnSelector announcer
		when: OvinaGUIColumnSelectionChanged 
		do: [ self updateColumns  ].
	colSelPresenter openModalWithSpec 
		okAction: [ columnSelector announcer initialize ];
		cancelAction: [ colSelPresenter cancel. columnSelector announcer initialize ] 
]

{ #category : #selection }
OvinaSheepPresenter >> selectNextSheep [
	"Should select next sheep in the list"
	"Should select previous sheep in the list"
	|index|
	index := table selection selectedIndex.
	index = self sheeps size ifTrue: [ ^self ].
	table selection selectIndex: index+1.
	self announcer announce: (OvinaGUISheepSelectionChanged new sheep: table selection selectedItem )
]

{ #category : #selection }
OvinaSheepPresenter >> selectPreviousSheep [
	"Should select previous sheep in the list"
	|index|
	index := table selection selectedIndex.
	index = 1 ifTrue: [ ^self ].
	table selection selectIndex: index-1.
	self announcer announce: (OvinaGUISheepSelectionChanged new sheep: table selection selectedItem )
]

{ #category : #initialization }
OvinaSheepPresenter >> setLayout [
	self layout: (SpBoxLayout newVertical
		add: table;
		add: (SpBoxLayout newHorizontal add: buttonBar) expand: false fill: true padding: 3;
		yourself)
]

{ #category : #selection }
OvinaSheepPresenter >> setSelected: sheep [
	"Currently selected sheep changed"
	table selection selectItem: sheep.
	table verticalAlignment desiredVisibleRow: table selection selectedIndex.
	self announceNewSelection: sheep
]

{ #category : #accessing }
OvinaSheepPresenter >> sheeps [
	"Get the list of all sheeps"
	^ self filter: (self class sheepClass all sort: [ :r1 :r2 | r1 id < r2 id])
]

{ #category : #initialization }
OvinaSheepPresenter >> updateColumns [
	self initializeTable.
	"self setLayout."
	self updatePresenter.
]

{ #category : #initialization }
OvinaSheepPresenter >> updatePresenter [
	table items: self sheeps.
]
