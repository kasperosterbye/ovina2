Class {
	#name : #OvinaRegistrationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'selBar',
		'selTable',
		'regButtonBar',
		'regTable',
		'regCommentText',
		'regDefaultText',
		'eventTable',
		'regFilterKind',
		'regFilterPastYear',
		'selFilterPresent',
		'selIncludeLambs',
		'selectedSheeps'
	],
	#category : #'Ovina2-GUI'
}

{ #category : #specs }
OvinaRegistrationPresenter class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		addFirst: (SpBoxLayout newVertical
			add: #selBar expand: false fill: true padding: 3;
			add: #selTable);
		addSecond: (SpPanedLayout newVertical
		addFirst: 
			(SpBoxLayout newVertical
			add: #regButtonBar expand: false fill: true padding: 3;
			add: #regTable;
			add: (SpBoxLayout newHorizontal 
				add: #regCommentText ;
				add: #regDefaultText width: 75) 
				withConstraints: [:c| c height: 60; expand: false; fill: false; padding: 3]); 
		addSecond: #eventTable)
]

{ #category : #examples }
OvinaRegistrationPresenter class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #'as yet unclassified' }
OvinaRegistrationPresenter >> currentRegistration: reg [
	reg ifNotNil: [
		regCommentText beEditable; enable; text: reg comment]
	ifNil: [
		regCommentText text: ''; beNotEditable; disable.].
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
	regFilterPastYear := false.
	regFilterKind := 'all'.
	
	super initialize.
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeEditor [
	|lastReg| 
	regCommentText := self newText.
	regCommentText 
		disable;
		whenTextChangedDo: [ :new | 
			lastReg := self selectedRegistration .
			lastReg ifNotNil: [ lastReg comment: regCommentText text asString. ].
	].
	
	regDefaultText := self newText text: 'default'
		
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
	
	self initializeSelButtons.
	self initializeSelTable.
	self initializeRegisterTable.
	self initializeRegButtons.
	self initializeEditor.
	self initializeEventTable. 
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeRegButtons [

	regButtonBar := self newButtonBar.
	regButtonBar 
		add: (self newButton
				 label: 'Print';
				 action: [ self error: 'to be implemented' ]);
		add: (self newCheckBox
				 label: 'Seneste år';
				 whenChangedDo: [ :newValue | 
					 regFilterPastYear := newValue.
					 self updatePresenter ]);
		add: (self newDropList
				 items: #( 'all' ) , self kinds;
				 whenSelectedItemChangedDo: [ :filter | 
					 regFilterKind := filter.
					 self updatePresenter ])
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
		sortingBlock: [ :s1 :s2 | (s2 date) threeWayCompareTo:  (s1 date)] asSortFunction;
		beResizable   
	
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeSelButtons [
	 
	selBar  := self newButtonBar.
	selBar 
		add: (self newButton
				 label: 'Todo';
				 action: [ self error: 'to be implemented' ]);
		add: (self newCheckBox
				 label: 'Aktuelle';
				 whenChangedDo: [ :newValue | 
					 selFilterPresent := newValue.
					 self updatePresenter ]);
		add: (self newCheckBox
				 label: 'Inkluder lam';
				 whenChangedDo: [ :newValue | 
					 selIncludeLambs := newValue.
					 self updatePresenter ])
]

{ #category : #initialization }
OvinaRegistrationPresenter >> initializeSelTable [
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
		sortingBlock: [ :s1 :s2 | (s2 date) threeWayCompareTo:  (s1 date)] asSortFunction;
		beResizable   
	
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
	regFilterPastYear ifTrue: [ |cutof|
		cutof := (registrations collect: [:ds| ds date asISO8601Date]) max - 365 days.
		registrations := registrations select: [ :r | r date asISO8601Date > cutof ] ].
	(regFilterKind = 'all') ifFalse: [ 
		registrations := registrations select: [ :r | r kind = regFilterKind  ] ].
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
