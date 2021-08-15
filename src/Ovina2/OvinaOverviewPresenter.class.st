"
I am a notebook page used to provide an overview of a selected parent animal (Ewe or Ram).


"
Class {
	#name : #OvinaOverviewPresenter,
	#superclass : #SpNotebookPage,
	#instVars : [
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

{ #category : #grouping }
OvinaOverviewPresenter >> eventsForYear: year [
	^ (self sheep events select: [ :ev | ev date year = year ]) size
]

{ #category : #grouping }
OvinaOverviewPresenter >> eventsTableForYear: year in: aPresenter [
	| events table |
	events := self sheep events select: [ :ev | ev date year = year ].
	table := aPresenter instantiate: SpTablePresenter.
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
OvinaOverviewPresenter >> initialize [
	super initialize.
	self title: 'Oversigt'.
	self presenterProvider: [ self myPresenter ]
	
]

{ #category : #grouping }
OvinaOverviewPresenter >> lambsForYear: year [
	^ (self sheep lambs select: [ :l | l inDate year = year ]) size
]

{ #category : #grouping }
OvinaOverviewPresenter >> lambsTableForYear: year in: aPresenter [
	"Columns: nummer, inDato, køn, event, farve"
	| lambs table |
	lambs := self sheep lambs select: [ :l | l inDate year = year ].
	table := aPresenter instantiate: SpTablePresenter.
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

{ #category : #initialization }
OvinaOverviewPresenter >> myPresenter [
	| years myLayout myPresenter titleHeight rowHeight|
	titleHeight :=22.
	rowHeight:=20.5.
	years := #().
	self sheep ifNotNil: [
			years := self sheep events collect: [ :ev | ev date year ].
			years := (years , (self sheep lambs collect: [ :lamb | lamb inDate year ])) 
					asSet asArray sort reversed].
	myLayout := SpBoxLayout  newTopToBottom spacing: 5.
	myPresenter := SpPresenter new layout: (SpScrollableLayout with: (SpPresenter new 
						layout: myLayout) ).
	years do: [ :year |
		myLayout 
			add: (SpBoxLayout newVertical spacing: 3;
						add: year asString expand: false;
						add: (self lambsTableForYear: year in: myPresenter ) 
							height: rowHeight * (self lambsForYear: year ) + titleHeight ;
						add: (self eventsTableForYear: year in: myPresenter) 
							height: rowHeight * (self eventsForYear: year) + titleHeight) 
			expand: false
	].
	myLayout add: ' ' expand: false.
	^myPresenter .
]

{ #category : #accessing }
OvinaOverviewPresenter >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaOverviewPresenter >> sheep: anEwe [

	sheep := anEwe.
	self resetContent
]
