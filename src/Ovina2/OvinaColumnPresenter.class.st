"
I am used to select a which table columns are to be presented, and in which order.

list is an SpListPresenter, 
while columns store the column names as OrderedCollection<Association<ColumnName:String,Include:Boolean>>
"
Class {
	#name : #OvinaColumnPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'columns',
		'sheepPresenter',
		'backup'
	],
	#category : #'Ovina2-GUI'
}

{ #category : #specs }
OvinaColumnPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
		yourself
]

{ #category : #examples }
OvinaColumnPresenter class >> openOn: sheepPresenter [
	|instance|
	instance :=self new on: sheepPresenter.
	instance openDialogWithSpec 
		cancelAction: [ instance cancel ]
]

{ #category : #actions }
OvinaColumnPresenter >> cancel [
	sheepPresenter allColumns: backup 
]

{ #category : #'instance creation' }
OvinaColumnPresenter >> columns [
	sheepPresenter  ifNil: [ ^#() ].
	columns ifNil: [columns := sheepPresenter  allColumns].
	^columns 
]

{ #category : #commands }
OvinaColumnPresenter >> columnsMenu [
	^ self newMenu
		title: 'Flyt søjle';
		addItem: [ :anItem | 
			anItem
				name: 'Op/Venstre';
				description: 'Flytter denne søjle mod venstre i søjlerne';
				iconName: #arrowUp;
				action: [ self moveSelectedColumnLeft  ] ];
		addItem: [ :anItem | 
			anItem
				name: 'Ned/Højre'; 
				description: 'Flytter denne søjle mod højre i søjlerne';
				iconName: #arrowDown;
				action: [ self moveSelectedColumnRight  ] ]
]

{ #category : #initialization }
OvinaColumnPresenter >> initializePresenters [
 
	table := self instantiate: SpTablePresenter.
	table addColumn: (SpCheckBoxTableColumn new
				 title: 'Inkl';
				 evaluated: #value;
				width: 30;
				onActivation: [:col | col value: true. self updatePresenter ];
				onDeactivation: [:col | col value: false. self updatePresenter]);
			addColumn: (SpStringTableColumn new
				 title: 'Kolonne';
				 evaluated: #key).
	table contextMenu: self columnsMenu .
	self updatePresenter.
	
]

{ #category : #initialization }
OvinaColumnPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Søjler';
		initialExtent: 600 @ 350 
]

{ #category : #'instance creation' }
OvinaColumnPresenter >> isColumnSelected [
	^ table selection selectedItem notNil
]

{ #category : #'instance creation' }
OvinaColumnPresenter >> moveSelectedColumnLeft [
	"Swap the selected item and the one before it"
	| index tmp columns|
	self isColumnSelected ifFalse: [ ^ self ].
	index := table selection selectedIndex.
	index = 1 ifTrue:[^ self ].
	columns := self columns.
	tmp := columns at: index-1.
	columns at: index - 1 put: (columns at: index).
	columns at: index put: tmp.
	self updatePresenter.
	table selection selectIndexes: { index-1 }.
	
]

{ #category : #'instance creation' }
OvinaColumnPresenter >> moveSelectedColumnRight [
	"Swap the selected item and the one after it"
	| index tmp columns|
	self isColumnSelected ifFalse: [ ^ self ].
	columns := self columns.
	index := table selection selectedIndex.
	index = columns size ifTrue:[^ self ].
	tmp := columns at: index.
	columns at: index put: (columns at: index+1).
	columns at: index+1 put: tmp.
	self updatePresenter.
	table selection selectIndexes: { index +1 }.
]

{ #category : #'instance creation' }
OvinaColumnPresenter >> on: presenter [
	sheepPresenter := presenter. 
	backup := sheepPresenter allColumns deepCopy.
	self updatePresenter 
]

{ #category : #'instance creation' }
OvinaColumnPresenter >> selectedColumn [
	^ table selectedItem 
]

{ #category : #'instance creation' }
OvinaColumnPresenter >> updatePresenter [ 
	super updatePresenter.
	table items: self columns.
	sheepPresenter ifNotNil:	[sheepPresenter allColumns: self columns].
	
]