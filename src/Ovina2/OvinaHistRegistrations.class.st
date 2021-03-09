"
I implement the table of registrations and its action bar.
"
Class {
	#name : #OvinaHistRegistrations,
	#superclass : #SpPresenter,
	#instVars : [
		'actionBar',
		'commentText',
		'defaultText',
		'filterKind',
		'filterPastYear',
		'table',
		'changedAction'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #specs }
OvinaHistRegistrations class >> defaultSpec [

	^ SpBoxLayout newVertical
			add: #table;
			add: (SpBoxLayout newHorizontal 
				add: #commentText ;
				add: #defaultText width: 75) 
				withConstraints: [:c| c height: 60; expand: false; fill: false; padding: 3];
			add: #actionBar expand: false fill: true padding: 3
]

{ #category : #examples }
OvinaHistRegistrations class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #private }
OvinaHistRegistrations >> currentRegistration: reg [
	reg ifNotNil: [
		commentText beEditable; enable; text: reg comment.
		defaultText beEditable; enable; text: (reg default ifEmpty: [ 'default' ] )]
	ifNil: [
		commentText text: ''; beNotEditable; disable.
		defaultText text: ''; beNotEditable; disable.].
	self updatePresenter 
]

{ #category : #private }
OvinaHistRegistrations >> events [
	|reg|
	reg := self selectedRegistration.
	reg ifNil: [ ^#() ].
	^ OvinaEvent events values select: [ :ev | ev registration = reg ]
]

{ #category : #initialization }
OvinaHistRegistrations >> initialize [
	filterPastYear := false.
	filterKind := 'all'.
	
	super initialize.
]

{ #category : #initialization }
OvinaHistRegistrations >> initializeEditor [
	|lastReg| 
	commentText := self newText.
	commentText 
		disable;
		whenTextChangedDo: [ :new | 
			lastReg := self selectedRegistration .
			lastReg ifNotNil: [ lastReg comment: commentText text asString. ].
	].
	
	defaultText := self newText text: 'default'.
	defaultText
		disable;
		whenTextChangedDo: [ :new | 
			lastReg := self selectedRegistration .
			lastReg ifNotNil: [ lastReg default: defaultText text asString. ].
	].
		
]

{ #category : #initialization }
OvinaHistRegistrations >> initializePresenters [
	
	super initializePresenters.

	self initializeRegisterTable.
	self initializeRegButtons.
	self initializeEditor.
]

{ #category : #initialization }
OvinaHistRegistrations >> initializeRegButtons [

	actionBar := self newButtonBar.
	actionBar 
		add: (self newButton
				 label: 'Print';
				 action: [ self error: 'to be implemented' ]);
		add: (self newCheckBox
				 label: 'Seneste år';
				 whenChangedDo: [ :newValue | 
					 filterPastYear := newValue.
					 self updatePresenter ]);
		add: (self newDropList
				 items: #( 'all' ) , self kinds;
				 whenSelectedItemChangedDo: [ :filter | 
					 filterKind := filter.
					 self updatePresenter ])
]

{ #category : #initialization }
OvinaHistRegistrations >> initializeRegisterTable [
	table := self instantiate: SpTablePresenter.
	table addColumn: (SpStringTableColumn new
			title: 'type' ;
			evaluated: #kind ;
			sortFunction: [ :s1 :s2 | (s1 kind) threeWayCompareTo:  (s2 kind)] asSortFunction);
		addColumn: (SpStringTableColumn new
			title: 'dato' ;
			evaluated: #date ;
			sortFunction: [ :s1 :s2 | (s1 date) threeWayCompareTo:  (s2 date)] asSortFunction);
	   addColumn: (SpStringTableColumn new
			title: 'kommentar' ;
			evaluated: [:reg | reg comment asString truncateTo: 40];
			sortFunction: [ :s1 :s2 | (s1 kind) threeWayCompareTo:  (s2 kind)] asSortFunction);
		whenSelectedDo: [ :foo | self currentRegistration: foo ];
		whenNoneSelectedDo: [ self currentRegistration: nil ];
		sortingBlock: [ :s1 :s2 | (s2 date) threeWayCompareTo:  (s1 date)] asSortFunction;
		beResizable   
	
]

{ #category : #initialization }
OvinaHistRegistrations >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Registreringer';
		initialExtent: 600 @ 950 
]

{ #category : #private }
OvinaHistRegistrations >> kinds [
	"return a list of the existing kinds, sorted by most used first"
	|allKinds countDict|
	allKinds := OvinaRegistration registrations values collect: [ :reg| reg kind ].
	countDict := Dictionary new.
	allKinds do: [ :k| countDict at: k update: [:i|i+1] initial:1].
	^ (countDict associations asArray sort:[:a :b| a value > b value]) collect: #key
]

{ #category : #private }
OvinaHistRegistrations >> registrations [
	| registrations |
	registrations :=OvinaRegistration registrations values.
	filterPastYear ifTrue: [ |cutof|
		cutof := (registrations collect: [:ds| ds date asISO8601Date]) max - 365 days.
		registrations := registrations select: [ :r | r date asISO8601Date > cutof ] ].
	(filterKind = 'all') ifFalse: [ 
		registrations := registrations select: [ :r | r kind = filterKind  ] ].
	^registrations 
]

{ #category : #api }
OvinaHistRegistrations >> selectedRegistration [
	^ table selection selectedItem 
]

{ #category : #private }
OvinaHistRegistrations >> updatePresenter [ 
	
	super updatePresenter.
	table items: self registrations.
	changedAction ifNotNil: [changedAction value].
]

{ #category : #api }
OvinaHistRegistrations >> whenChangedDo: aBlock [
	changedAction := aBlock
]
