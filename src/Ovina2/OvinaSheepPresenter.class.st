"
* allColumns is an ordered collection of associations of OvinaColumnSpecifications to boolean (indicating if column should be included in the view)
"
Class {
	#name : #OvinaSheepPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'selectionChangeAction',
		'table',
		'buttonBar',
		'printAll',
		'newRam',
		'editColumns'
	],
	#classInstVars : [
		'allColumns'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #accessing }
OvinaSheepPresenter class >> allColumns [
	allColumns ifNil: [ allColumns := self sheepClass allColumns  collect:[:c| c->true ]].
	^ allColumns
]

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

{ #category : #initialization }
OvinaSheepPresenter >> activeColumns [
	"return the column names which are active"
	^ (self allColumns  select: #value) collect: #key

]

{ #category : #initialization }
OvinaSheepPresenter >> allColumns [
	^ self class allColumns 

]

{ #category : #initialization }
OvinaSheepPresenter >> allColumns: columns [
	" columns is {colName->bool. colName->bool...} 
	where the booleans indicate if should be included in presentation"
	self class allColumns: columns.
	self initializeTable.
	self rebuildLayout.
	self updatePresenter 
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> currentSheep: sheep [

	selectionChangeAction ifNotNil: [ selectionChangeAction value: sheep ]
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> editSheep [
	"OvinaSingleSheepPresenter openOn: table selection selectedItem"
	|editor|
	table selection isEmpty ifTrue: [ table selection selectIndexes: #(1) ].
	editor := OvinaSingleSheepPresenter on: [ table selection selectedItem ].
	editor
		prevBlock: [ self selectPreviousSheep  ];
		nextBlock: [ self selectNextSheep  ];
		closeBlock: [ |selected| 
			selected := table selection selectedItem.
			self updatePresenter.
			table selection selectItem: selected ].
	editor openWithSpec.
	 
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
			label: 'Ret søjler';
			action: [ OvinaColumnPresenter openOn: self ])
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
	self activeColumns  do: [ :col |
		table addColumn: (SpStringTableColumn new
				 title: col dkName ;
				 evaluated: col getter ;
				 sortFunction: [ :s1 :s2 | 
					(s1 perform: col getter)   threeWayCompareTo:  (s2 perform: col  getter)
				] asSortFunction)
	 ].
	table 
		whenSelectedDo: [ :sheep | self currentSheep: sheep];
		whenNoneSelectedDo: [ self currentSheep: nil ];
		beResizable.
	table announcer when: SpWidgetBuilt do: [ :ann | ann widget allowsDeselection: true ].
	"self updatePresenter."
	
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
OvinaSheepPresenter >> selectNextSheep [
	"Should select next sheep in the list"
	"Should select previous sheep in the list"
	|index|
	index := table selection selectedIndex.
	index = self sheeps size ifTrue: [ ^self ].
	table selection selectIndex: index+1.
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> selectPreviousSheep [
	"Should select previous sheep in the list"
	|index|
	index := table selection selectedIndex.
	index = 1 ifTrue: [ ^self ].
	table selection selectIndex: index-1.
]

{ #category : #accessing }
OvinaSheepPresenter >> sheeps [
	"Get the list of all sheeps"
	^ (OvinaSheep sheeps values select: [ :sheep | sheep class = self class sheepClass  ]) 
		sort: [ :r1 :r2 | r1 id < r2 id]
]

{ #category : #accessing }
OvinaSheepPresenter >> updatePresenter [ 
	super updatePresenter.
	table items: self sheeps
]

{ #category : #enumerating }
OvinaSheepPresenter >> whenSelectedDo: aBlock [
	selectionChangeAction := aBlock
]
