"
* allColumns is an ordered collection of associations of OvinaColumnSpecifications to boolean (indicating if column should be included in the view)
"
Class {
	#name : #OvinaSheepPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'buttonBar',
		'columnSelector'
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

{ #category : #specs }
OvinaSheepPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
		add: (SpBoxLayout newHorizontal add: #buttonBar) expand: false fill: true padding: 3;
		yourself
]

{ #category : #examples }
OvinaSheepPresenter class >> open [
	<example>
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
	a class = b class ifFalse: [ self error: 'Should not compere those' ].
	^ a threeWayCompareTo: b
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> announceNewSelection: sheep [
	"Currently selected sheep changed"
	
	self announcer announce: (OvinaGUISheepSelectionChanged new sheep: sheep)
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> editSheep [
	"OvinaSingleSheepPresenter openOn: table selection selectedItem"
	|editor|
	table selection isEmpty ifTrue: [ table selection selectIndexes: #(1) ].
	editor := OvinaSingleSheepPresenter on: [ table selection selectedItem ].
	editor
		prevBlock: [ self selectPreviousSheep  ];
		nextBlock: [ self selectNextSheep  ]";
		closeBlock: [ |selected| 
			selected := table selection selectedItem.
			self updatePresenter.
			table selection selectItem: selected ]".
	editor openWithSpec.
	 
]

{ #category : #initialization }
OvinaSheepPresenter >> initialize [
	columnSelector := OvinaColumnSelection 
		for: self class sheepClass name.
	columnSelector announcer
		when: OvinaGUIColumnSelectionChanged 
		do: [ self updateColumns  ].
	super initialize.
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeButtons [
	 buttonBar 
		add: (self newButton 
			label: 'Print';
			action: [ self printTable ]);
		add: (self newButton 
			label: 'Ret';
			action: [ self editSheep ]);
		add: ( self newButton 
			label: 'Vælg søjler';
			action: [ self selectColumns ])
]

{ #category : #initialization }
OvinaSheepPresenter >> initializePresenters [
	 
	self initializeTable.
	buttonBar := self newButtonBar.
	self initializeButtons.
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeTable [
	table := self instantiate: SpTablePresenter.
	columnSelector activeColumns  do: [ :col |
		table addColumn: (SpStringTableColumn new
				 title: col dkName ;
				 evaluated: col getter ;
				 sortFunction: [ :s1 :s2 | 
					self class threeWayCompare: (s1 perform: col getter) to: (s2 perform: col  getter)
				] asSortFunction)
	 ].
	table 
		whenSelectedDo: [ :sheep | self announceNewSelection: sheep];
		whenNoneSelectedDo: [ self announceNewSelection: nil ];
		beResizable.
	table announcer when: SpWidgetBuilt do: [ :ann | 
		ann widget allowsDeselection: true.
		ann widget beResizable].
	OvinaModel announcer 
		when: OvinaModelSheepChanged do: [ :ann |
			(ann sheep class = self class sheepClass) ifTrue: [self updatePresenter] ];
		when: OvinaModelSheepRemoved do: [ self updatePresenter ]
	
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

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> selectColumns [
	|colSelPresenter|
	colSelPresenter := OvinaColumnPresenter new on: columnSelector.
	colSelPresenter openDialogWithSpec 
		cancelAction: [ colSelPresenter cancel ] 
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> selectNextSheep [
	"Should select next sheep in the list"
	"Should select previous sheep in the list"
	|index|
	index := table selection selectedIndex.
	index = self sheeps size ifTrue: [ ^self ].
	table selection selectIndex: index+1.
	self announcer announce: (OvinaGUISheepSelectionChanged new sheep: table selection selectedItem )
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> selectPreviousSheep [
	"Should select previous sheep in the list"
	|index|
	index := table selection selectedIndex.
	index = 1 ifTrue: [ ^self ].
	table selection selectIndex: index-1.
	self announcer announce: (OvinaGUISheepSelectionChanged new sheep: table selection selectedItem )
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> setSelected: sheep [
	"Currently selected sheep changed"
	table selection selectItem: sheep.
	table verticalAlignment desiredVisibleRow: table selection selectedIndex.
	self announceNewSelection: sheep
]

{ #category : #accessing }
OvinaSheepPresenter >> sheeps [
	"Get the list of all sheeps"
	^ "(OvinaSheep sheeps values select: [ :sheep | sheep class = self class sheepClass  ]) "
		self class sheepClass all sort: [ :r1 :r2 | r1 id < r2 id]
]

{ #category : #initialization }
OvinaSheepPresenter >> updateColumns [
	self initializeTable.
	self rebuildLayout.
	self updatePresenter 
]

{ #category : #accessing }
OvinaSheepPresenter >> updatePresenter [
	|selected|
	super updatePresenter.
	selected := table selection selectedItem.
	table items: self sheeps.
	(selected notNil and: [ table items includes: selected ]) 
		ifTrue: [ 
			table selection selectItem: selected.
			self announceNewSelection: selected ]
]
