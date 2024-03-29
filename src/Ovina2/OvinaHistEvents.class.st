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

{ #category : #initialization }
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
			sortFunction: [ :e1 :e2 | (e1 date yyyymmdd ) threeWayCompareTo:  (e2 date yyyymmdd )] asSortFunction);
	   addColumn: (SpStringTableColumn new
			title: 'værdi' ;
			evaluated: [:reg | reg result asString truncateTo: 40];
			sortFunction: [ :e1 :e2 | (e1 result) threeWayCompareTo:  (e2 result)] asSortFunction);
		sortingBlock: [ :e1 :e2 | (e2 sheep number) threeWayCompareTo:  (e1 sheep number)] asSortFunction;
		beResizable;
		whenSelectionChangedDo: [ self setDateAndResult  ]
	
]

{ #category : #printing }
OvinaHistEvents >> printPageForNotes [
	|specialTable tablePrinter|
	"Create a new table to be printed, now we have a table printer"
	specialTable := SpTablePresenter new
		columns: {SpStringTableColumn new title: 'værdi' ; evaluated: [ :d| '' ]},
		(table columns copyFrom: 1 to: 2);
		items: ((1 to: table items size) collect: [ :index | table itemAt: index ]).
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

{ #category : #events }
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
			dateField text: (table selection selectedItem date) asDKString ;
				selectionInterval: (dateField text size + 1 to: dateField text size).
			resultField 
				text: (table selection selectedItem result asString);
				selectionInterval: (1 to: resultField text size)
			 ]
	
]

{ #category : #events }
OvinaHistEvents >> sheepAdded: sheep [
	"Add an event for sheep in the current registration"
	|newEvent|
	
	registration  ifNil: [ ^self ].
	newEvent := OvinaEvent new
		registration: registration ;
		sheep: sheep.
	OvinaEvent addNewEvent: newEvent.
	self updatePresenter.
	
]

{ #category : #events }
OvinaHistEvents >> sheepRemoved: sheep [
	"Remove an event for sheep in the current registration"
	
	registration  ifNil: [ ^self ].
	OvinaEvent removeEvent:  (table items detect: [:ev | ev sheep = sheep  ] ifNone: [^self]).
	self updatePresenter.
	
]

{ #category : #events }
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

{ #category : #events }
OvinaHistEvents >> updateResult [
	"cr was pressed in the result field - update the selected Event, and move to next event if any"
	table selection selectedItem result: resultField text.
	self selectNextRow
]
