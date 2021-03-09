"
I present the actual events of a registration.
In addition, have two printing operations, one with values/results and one without (for noting in real life).
"
Class {
	#name : #OvinaHistEvents,
	#superclass : #SpPresenter,
	#instVars : [
		'histPresenter',
		'actionBar',
		'table'
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
	|reg|
	reg := self selectedRegistration.
	reg ifNil: [ ^#() ].
	^ OvinaEvent events values select: [ :ev | ev registration = reg ]
]

{ #category : #accessing }
OvinaHistEvents >> histPresenter [

	^ histPresenter
]

{ #category : #accessing }
OvinaHistEvents >> histPresenter: anObject [

	histPresenter := anObject
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> initializButtons [

	actionBar := self newButtonBar.
	actionBar 
		add: (self newButton
				 label: 'Print tom';
				 action: [ self error: 'to be implemented' ]);
		add: (self newButton
				 label: 'Print resultater';
				 action: [ self error: 'to be implemented' ])
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
		beResizable   
	
]

{ #category : #'as yet unclassified' }
OvinaHistEvents >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Hændelser';
		initialExtent: 600 @ 950 
]

{ #category : #api }
OvinaHistEvents >> selectedRegistration [
	"pick up currently selected registration from HistoryPresenter"
	^ histPresenter ifNotNil: [ histPresenter selectedRegistration  ]
]

{ #category : #initialization }
OvinaHistEvents >> updatePresenter [
	table items: self events
]
