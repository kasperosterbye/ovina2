Class {
	#name : #OvinaOverviewPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'overview',
		'sheep'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #specs }
OvinaOverviewPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #overview;
		yourself 
		  
]

{ #category : #examples }
OvinaOverviewPresenter class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #'as yet unclassified' }
OvinaOverviewPresenter >> eventsForYear: year [
	^ (self sheep events select: [ :ev | ev date year = year ]) size
]

{ #category : #'as yet unclassified' }
OvinaOverviewPresenter >> eventsTableForYear: year [
	| events table |
	events := self sheep events select: [ :ev | ev date year = year ].
	table := self instantiate: SpTablePresenter.
	table 
		addColumn: (SpStringTableColumn new
			title: 'type' ; evaluated: [:event | event registration kind]);
		addColumn: (SpStringTableColumn new
			title: 'dato' ; evaluated: #date);
		addColumn: (SpStringTableColumn new
			title: 'værdi' ; evaluated: #result);
		sortingBlock: [ :e1 :e2 | (e2 date) threeWayCompareTo: (e1 date)] asSortFunction.
	table items: events.
	^table
]

{ #category : #initialization }
OvinaOverviewPresenter >> initializePresenters [
	| years details titleHeight rowHeight|
	titleHeight :=24.
	rowHeight:=20.
	years := #().
	self sheep ifNotNil: [
			years := self sheep events collect: [ :ev | ev date year ].
			years := (years , (self sheep lambs collect: [ :lamb | lamb inDate year ])) 
					asSet asArray sort reversed].
	details := SpBoxLayout  newTopToBottom spacing: 5.
	years do: [ :year |
		details 
			add: (SpBoxLayout newVertical spacing: 3;
						add: year asString expand: false;
						add: (self lambsTableForYear: year) 
							height: rowHeight * (self lambsForYear: year ) + titleHeight ;
						add: (self eventsTableForYear: year) 
							height: rowHeight * (self eventsForYear: year) + titleHeight) 
			expand: false
	].
	details add: ' ' expand: false.
	overview := SpPresenter new 
		layout: (SpScrollableLayout with: (SpPresenter new 
		layout: details) ).
]

{ #category : #initialization }
OvinaOverviewPresenter >> initializePresenters_ComponentList [
	| years details titleHeight rowHeight|
	titleHeight :=22.
	rowHeight:=20.
	years := #().
	self sheep ifNotNil: [
			years := self sheep events collect: [ :ev | ev date year ].
			years := (years , (self sheep lambs collect: [ :lamb | lamb inDate year ])) 
					asSet asArray sort reversed].
	details := OrderedCollection new.
	years do: [ :year |
		details 
			add: year asString;
			add: (self lambsTableForYear: year);
			add: (self eventsTableForYear: year) 
	].
	overview := SpPresenter new 
		layout: (SpScrollableLayout with: (SpComponentListPresenter new 
		presenters: details) ).
]

{ #category : #initialization }
OvinaOverviewPresenter >> initializePresenters_old [
	| years details titleHeight rowHeight|
	titleHeight :=22.
	rowHeight:=20.
	years := #().
	self sheep ifNotNil: [
			years := self sheep events collect: [ :ev | ev date year ].
			years := (years , (self sheep lambs collect: [ :lamb | lamb inDate year ])) 
					asSet asArray sort reversed].
	details := SpBoxLayout  newTopToBottom spacing: 5.
	years do: [ :year |
		details 
			add: (SpBoxLayout newVertical spacing: 3;
						add: year asString expand: false;
						add: (self lambsTableForYear: year) 
							height: rowHeight * (self lambsForYear: year ) + titleHeight ;
						add: (self eventsTableForYear: year) 
							height: rowHeight * (self eventsForYear: year) + titleHeight) 
			expand: false
	].
	details add: ' ' expand: false.
	overview := SpPresenter new 
		layout: (SpScrollableLayout with: (SpPresenter new 
		layout: details) ).
]

{ #category : #initialization }
OvinaOverviewPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Oversigt';
		initialExtent: 500@600. 
]

{ #category : #'as yet unclassified' }
OvinaOverviewPresenter >> lambsForYear: year [
	^ (self sheep lambs select: [ :l | l inDate year = year ]) size
]

{ #category : #'as yet unclassified' }
OvinaOverviewPresenter >> lambsTableForYear: year [
	"Columns: nummer, inDato, køn, event, farve"
	| lambs table |
	lambs := self sheep lambs select: [ :l | l inDate year = year ].
	table := self instantiate: SpTablePresenter.
	table 
		addColumn: (SpStringTableColumn new
			title: 'nummer' ; evaluated: #number);
		addColumn: (SpStringTableColumn new
			title: 'inddato' ; evaluated: #inDate);
		addColumn: (SpStringTableColumn new
			title: 'køn' ; evaluated: #sex);
		addColumn: (SpStringTableColumn new
			title: 'fødsel' ; evaluated: #event);
		addColumn: (SpStringTableColumn new
			title: 'brug' ; evaluated: #usage);
		sortingBlock: [ :e1 :e2 | (e2 number) threeWayCompareTo: (e1 number)] asSortFunction.
	table items: lambs.
	^table
]

{ #category : #'as yet unclassified' }
OvinaOverviewPresenter >> lambsTableForYear_Old: year [
	"Columns: nummer, inDato, køn, event, farve"
	| lambs table |
	lambs := self sheep lambs select: [ :l | l inDate year = year ].
	table := (self instantiate: SpTablePresenter)
		propagateNaturalHeight: true;
		withoutScrollBars.
	table 
		addColumn: (SpStringTableColumn new
			title: 'nummer' ; evaluated: #number);
		addColumn: (SpStringTableColumn new
			title: 'inddato' ; evaluated: #inDate);
		addColumn: (SpStringTableColumn new
			title: 'køn' ; evaluated: #sex);
		addColumn: (SpStringTableColumn new
			title: 'fødsel' ; evaluated: #event);
		addColumn: (SpStringTableColumn new
			title: 'brug' ; evaluated: #usage);
		sortingBlock: [ :e1 :e2 | (e2 number) threeWayCompareTo: (e1 number)] asSortFunction.
	table items: lambs.
	^table
]

{ #category : #accessing }
OvinaOverviewPresenter >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaOverviewPresenter >> sheep: anEwe [

	sheep := anEwe.
	self initializePresenters.
	self  rebuildLayout 
]
