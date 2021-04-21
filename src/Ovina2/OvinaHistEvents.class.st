"
I present the actual events of a registration.
In addition, have two printing operations, one with values/results and one without (for noting in real life).
"
Class {
	#name : #OvinaHistEvents,
	#superclass : #SpPresenter,
	#instVars : [
		'registration',
		'actionBar',
		'table',
		'dateField',
		'resultField'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #specs }
OvinaHistEvents class >> defaultSpec [
	
	^ SpBoxLayout newVertical  
				add: #table ;
				add: #actionBar expand: false fill: true padding: 3
]

{ #category : #accessing }
OvinaHistEvents >> events [
	registration  ifNil: [ ^#() ].
	^ OvinaEvent events values select: [ :ev | ev registration = registration  ]
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> initializButtons [

	actionBar := self newButtonBar.
	actionBar 
		add: (self newButton
				 label: 'Print tom';
				 action: [ self printPageForNotes ]);
		add: (self newButton
				 label: 'Print resultater';
				 action: [ self printResults]);
		add: (dateField := self newTextInput 
			whenSubmitDo: [:x :y :z | self updateDate]);
		add: (resultField := self newTextInput 
			whenSubmitDo: [:x :y :z | self updateResult ])
]

{ #category : #initialization }
OvinaHistEvents >> initializePresenters [
	
	super initializePresenters.
	self initializeTable. 
	self initializButtons 
]

{ #category : #initialization }
OvinaHistEvents >> initializeTable [
	table := self instantiate: SpTablePresenter.
	table addColumn: (SpStringTableColumn new
			title: 'nummer' ;
			evaluated: [ :event | event sheep number ] ;
			sortFunction: [ :e1 :e2 | 
				(e1 sheep number asInteger) threeWayCompareTo:  (e2 sheep number asInteger)] asSortFunction);
		addColumn: (SpStringTableColumn new
			title: 'navn' ;
			evaluated: [ :event | event sheep name ] ;
			sortFunction: [ :e1 :e2 | (e1 sheep name) threeWayCompareTo:  (e2 sheep name)] asSortFunction);
		addColumn: (SpStringTableColumn new
			title: 'dato' ;
			evaluated: #date ;
			sortFunction: [ :e1 :e2 | (e1 date) threeWayCompareTo:  (e2 date)] asSortFunction);
	   addColumn: (SpStringTableColumn new
			title: 'værdi' ;
			evaluated: [:reg | reg result asString truncateTo: 40];
			sortFunction: [ :e1 :e2 | (e1 result) threeWayCompareTo:  (e2 result)] asSortFunction);
		sortingBlock: [ :e1 :e2 | (e2 sheep number) threeWayCompareTo:  (e1 sheep number)] asSortFunction;
		beResizable;
		whenSelectionChangedDo: [ self setDateAndResult  ]
	
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Hændelser';
		initialExtent: 600 @ 950 
]

{ #category : #printing }
OvinaHistEvents >> printPageForNotes [
	|specialTable tablePrinter|
	"Create a new table to be printed, now we have a table printer"
	specialTable := SpTablePresenter new 
		columns: (table columns copyFrom: 1 to: 2), 
			{SpStringTableColumn new title: 'værdi' ; evaluated: [ :d| '' ]};
		sortingBlock: [ :e1 :e2 | (e2 sheep number) threeWayCompareTo:  (e1 sheep number)] asSortFunction;
		items: table items.
	tablePrinter := OvinaTablePrinter new
		title: 'Notering af ', registration kind, ' - ', registration date asString;
		table: specialTable .
	tablePrinter printTable
]

{ #category : #printing }
OvinaHistEvents >> printResults [
	|tablePrinter|
	tablePrinter := OvinaTablePrinter new
		title: registration kind, ' - ', registration date asString;
		table: table .
	tablePrinter printTable
]

{ #category : #accessing }
OvinaHistEvents >> registration [

	^ registration
]

{ #category : #accessing }
OvinaHistEvents >> registration: newRegistration [

	registration := newRegistration.
	self updatePresenter 
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> selectNextRow [
	|index|
	index := table selection selectedIndex.
	index = self events size ifTrue: [ index := 0 ].
	table selection selectIndex: index+1.
]

{ #category : #initialization }
OvinaHistEvents >> setDateAndResult [
	"Set the date and result field from current event"
	table selection isEmpty 
		ifTrue: [ dateField text: ''. resultField text: '' ]
		ifFalse: [ 
			dateField text: (table selection selectedItem date);
				selectionInterval: (dateField text size + 1 to: dateField text size).
			resultField 
				text: (table selection selectedItem result asString);
				selectionInterval: (1 to: resultField text size)
			 ]
	
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> sheepAdded: sheep [
	"Add an event for sheep in the current registration"
	|newEvent|
	newEvent := OvinaEvent new
		registration: registration ;
		sheep: sheep.
	OvinaEvent addNewEvent: newEvent.
	self updatePresenter.
	
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> sheepRemoved: sheep [
	"Remove an event for sheep in the current registration"
	OvinaEvent removeEvent:  (table items detect: [:ev | ev sheep = sheep  ]).
	self updatePresenter.
	
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> updateDate [
	"cr was pressed in the date field - update the selected Event, and move to next event if any"
	table selection selectedItem date: dateField text.
	self selectNextRow
]

{ #category : #initialization }
OvinaHistEvents >> updatePresenter [
	|index|
	index := table selection selectedIndex.
	table items: self events.
	table items ifNotEmpty: [ 
		table selection selectIndexes: { index beBetween: 1 and: table items size }].
	self setDateAndResult.
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> updateResult [
	"cr was pressed in the result field - update the selected Event, and move to next event if any"
	table selection selectedItem result: resultField text.
	self selectNextRow
]
