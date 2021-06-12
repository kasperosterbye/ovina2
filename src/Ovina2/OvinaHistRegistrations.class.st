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
		'changedAction',
		'newAction'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #specs }
OvinaHistRegistrations class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #table;
		  add: (SpBoxLayout newHorizontal
				   add: #commentText expand: true fill: true padding: 3;
				   add: #defaultText width: 85)
		  withConstraints: [ :c | 
			  c
				  height: 60;
				  expand: false;
				  fill: false;
				  padding: 3 ];
		  add: #actionBar
		  expand: false
		  fill: true
		  padding: 3
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
		defaultText beEditable; enable; text: reg default]
	ifNil: [
		commentText text: ''; beNotEditable; disable.
		defaultText text: ''; beNotEditable; disable.].
	self announce: (OvinaGUIRegistrationsChanged new registration: self)
]

{ #category : #'as yet unclassified' }
OvinaHistRegistrations >> editRegistration [
	|reg editor|
	reg := self selectedRegistration.
	editor := OvinaHistRegistrationEditor new
		kindExisting: reg kind;
		date: reg date printString;
		comment: reg comment;	
		default: reg default.
	editor openDialogWithSpec 
		cancelAction: [  ];
		okAction: [ self updateRegistrationFromEditor: editor ].
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

	| lastReg |
	commentText := self newText.
	commentText
		disable;
		whenTextChangedDo: [ :new | 
			lastReg := self selectedRegistration.
			lastReg ifNotNil: [ lastReg comment: commentText text asString ] ].

	defaultText := self newText text: ''.
	defaultText
		disable;
		whenTextChangedDo: [ :new | 
			lastReg := self selectedRegistration.
			lastReg ifNotNil: [ 
				lastReg default: defaultText text asString.
				self announce: (OvinaGUIRegistrationsChanged new registration: lastReg)
				 ].
			 ]
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
				 label: 'Ret registrering';
				 action: [ self editRegistration ]);
		add: (self newButton
				 label: 'Ny registrering';
				 action: [ self newRegistration ]);
		add: (self newButton
				 label: 'Slet registrering';
				 action: [ self removeRegistration ]);
		add: (self newCheckBox
				 label: 'Seneste år';
				 whenChangedDo: [ :newValue | 
					 filterPastYear := newValue.
					 self updatePresenter ]);
		add: (self newDropList
				 items: #( 'alle' ) , self kinds;
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
		beResizable;
		bindKeyCombination: KeyboardKey keypadUp toAction: [self selectPreviousOrFirst];
		bindKeyCombination: KeyboardKey keypadDown  toAction: [self selectNextOrLast] 
	
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
	^ OvinaRegistration kinds
]

{ #category : #'instance creation' }
OvinaHistRegistrations >> newRegistration [
	|editor|
	editor := OvinaHistRegistrationEditor new.
	editor openDialogWithSpec 
		cancelAction: [  ];
		okAction: [ self newRegistrationFromEditor: editor ].
]

{ #category : #private }
OvinaHistRegistrations >> newRegistrationFromEditor: editor [
	|reg|
	reg := OvinaRegistration new
			kind: editor kind;
			date: editor date;
			default: editor default;
			comment: editor comment.
	OvinaRegistration addNewRegistration: reg.
	self updatePresenter.
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

{ #category : #removing }
OvinaHistRegistrations >> removeRegistration [
	
	| index |
	index := table selection selectedIndex.
	OvinaRegistration removeRegistration: self selectedRegistration.
	index := index-1 beBetween: 1  and: OvinaRegistration registrations size.
	self updatePresenter.
	table selectIndex: index scrollToSelection: true
]

{ #category : #'as yet unclassified' }
OvinaHistRegistrations >> selectNextOrLast [

	| index |
	index := table selection selectedIndex.
	index = table items size ifTrue: [ ^ self ].
	table selectIndex: index + 1 scrollToSelection: true
]

{ #category : #'as yet unclassified' }
OvinaHistRegistrations >> selectPreviousOrFirst [

	| index |
	index := table selection selectedIndex.
	index = 1 ifTrue: [ ^ self ].
	table selectIndex: index - 1 scrollToSelection: true
]

{ #category : #api }
OvinaHistRegistrations >> selectedRegistration [
	^ table selection selectedItem 
]

{ #category : #private }
OvinaHistRegistrations >> updatePresenter [ 
	
	super updatePresenter.
	table items: self registrations.
	"table selectIndexes: {1} scrollToSelection: true."
	self announce: (OvinaGUIRegistrationsChanged new registration: self)
]

{ #category : #private }
OvinaHistRegistrations >> updateRegistrationFromEditor: editor [
	self selectedRegistration 
			kind: editor kind;
			date: editor date parseDKDate ;
			default: editor default;
			comment: editor comment.
	self updatePresenter.
]
