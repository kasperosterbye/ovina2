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
	| years aLayout stuff|
	years := self sheep events collect: [ :ev | ev date year ].
	years := (years , (self sheep lambs collect: [ :lamb | lamb inDate year ])) asSet asArray sort.
	aLayout := SpBoxLayout  newTopToBottom spacing: 5.
	years do: [ :year |
		aLayout 
			add: year asString expand: false;
			add: (self lambsTableForYear: year) ;
			add: (self eventsTableForYear: year)
		 ].
	stuff := SpPresenter new layout: aLayout.
	overview := SpPresenter new layout: (SpScrollableLayout with: stuff ).
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
			title: 'farve' ; evaluated: #color);
		sortingBlock: [ :e1 :e2 | (e2 number) threeWayCompareTo: (e1 number)] asSortFunction.
	table items: lambs.
	^table
]

{ #category : #accessing }
OvinaOverviewPresenter >> sheep [

	^ OvinaSheep ewes at: 'E41'
]

{ #category : #accessing }
OvinaOverviewPresenter >> sheep: anObject [

	sheep := anObject
]
