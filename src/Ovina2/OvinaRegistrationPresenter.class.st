Class {
	#name : #OvinaRegistrationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'regTable',
		'eventTable',
		'buttonBar',
		'filterLast',
		'filterKind',
		'editSelected'
	],
	#category : #'Ovina2-GUI'
}

{ #category : #specs }
OvinaRegistrationPresenter class >> defaultSpec [

	^ SpPanedLayout newVertical
		addFirst:
			(SpBoxLayout newVertical
			add: (SpBoxLayout newHorizontal add: #buttonBar;yourself) 
				expand: false fill: true padding: 3;
			add: #regTable;
			add: #editSelected withConstraints: [:c| c height: 60; fill: true; padding: 3]); 
		addSecond: #eventTable
		yourself
]

{ #category : #examples }
OvinaRegistrationPresenter class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #'as yet unclassified' }
OvinaRegistrationPresenter >> currentRegistration: reg [
	reg ifNotNil: [
		editSelected beEditable; enable; text: reg comment]
	ifNil: [
		editSelected text: ''; beNotEditable; disable.].
	self updatePresenter 
]

{ #category : #accessing }
OvinaRegistrationPresenter >> events [
	|reg|
	reg := self selectedRegistration.
	reg ifNil: [ ^#() ].
	^ OvinaEvent events values select: [ :ev | ev registration = reg ]
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initialize [
	filterLast := false.
	filterKind := 'all'.
	
	super initialize.
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeButtons [
	 buttonBar 
		add: (self newButton 
			label: 'Print';
			action: [ self error: 'to be implemented' ]);
		add: ( self newCheckBox 
			label: 'Seneste år';
			whenChangedDo: [ :newValue | filterLast := newValue. self updatePresenter ]);
		add: (self newDropList
			items: (#('all'), self kinds);
			whenSelectedItemChangedDo: [ :filter | filterKind := filter. self updatePresenter  ]
		)
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeEditor [
	editSelected := self newText.
	editSelected 
		disable;
		whenTextChangedDo: [ :new | self selectedRegistration ifNotNil: [ :reg | reg comment: new asString. ] ]
		
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeEventTable [
	eventTable  := self instantiate: SpTablePresenter.
	eventTable addColumn: (SpStringTableColumn new
			title: 'Dyr' ;
			evaluated: [ :event | event sheep name ] ;
			sortFunction: [ :s1 :s2 | (s1 sheep name) threeWayCompareTo:  (s2 sheep name)] asSortFunction);
		addColumn: (SpStringTableColumn new
			title: 'dato' ;
			evaluated: #date ;
			sortFunction: [ :s1 :s2 | (s1 date) threeWayCompareTo:  (s2 date)] asSortFunction);
	   addColumn: (SpStringTableColumn new
			title: 'værdi' ;
			evaluated: [:reg | reg result truncateTo: 40])
	
	
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializePresenters [
	
	super initializePresenters.
	self initializeRegisterTable.
	buttonBar := self newButtonBar.
	self initializeButtons.
	self initializeEditor.
	self initializeEventTable. 
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeRegisterTable [
	regTable := self instantiate: SpTablePresenter.
	regTable addColumn: (SpStringTableColumn new
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
		sortingBlock: [ :s1 :s2 | (s2 date) threeWayCompareTo:  (s1 date)] asSortFunction  
	
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Registreringer';
		initialExtent: 600 @ 950 
]

{ #category : #'as yet unclassified' }
OvinaRegistrationPresenter >> kinds [
	"return a list of the existing kinds, sorted by most used first"
	|allKinds countDict|
	allKinds := OvinaRegistration registrations values collect: [ :reg| reg kind ].
	countDict := Dictionary new.
	allKinds do: [ :k| countDict at: k update: [:i|i+1] initial:1].
	^ (countDict associations asArray sort:[:a :b| a value > b value]) collect: #key
]

{ #category : #accessing }
OvinaRegistrationPresenter >> registrations [
	| registrations |
	registrations :=OvinaRegistration registrations values.
	filterLast ifTrue: [ |cutof|
		cutof := (registrations collect: [:ds| ds date asISO8601Date]) max - 365 days.
		registrations := registrations select: [ :r | r date asISO8601Date > cutof ] ].
	(filterKind = 'all') ifFalse: [ 
		registrations := registrations select: [ :r | r kind = filterKind  ] ].
	^registrations 
]

{ #category : #'as yet unclassified' }
OvinaRegistrationPresenter >> selectedRegistration [
	^ regTable selection selectedItem 
]

{ #category : #initialization }
OvinaRegistrationPresenter >> updatePresenter [ 
	super updatePresenter.
	regTable items: self registrations.
	eventTable items: self events.
]
