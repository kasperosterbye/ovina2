"
* allColumns is an ordered collection of associations of OvinaColumnSpecifications to boolean (indicating if column should be included in the view)
"
Class {
	#name : #OvinaSheepPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'selectionChangeAction',
		'table',
		'buttonBar',
		'printAll',
		'newRam',
		'editColumns',
		'allColumns'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #specs }
OvinaSheepPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
		add: (SpBoxLayout newHorizontal add: #buttonBar) expand: false fill: true padding: 3;
		yourself
]

{ #category : #examples }
OvinaSheepPresenter class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #initialization }
OvinaSheepPresenter >> activeColumns [
	"return the column names which are active"
	^ (self allColumns  select: #value) collect: #key

]

{ #category : #initialization }
OvinaSheepPresenter >> allColumns [
	allColumns ifNil: [ allColumns := self sheepClass allColumns  collect:[:c| c->true ]].
	^allColumns 

]

{ #category : #initialization }
OvinaSheepPresenter >> allColumns: columns [
	" columns is {colName->bool. colName->bool...} 
	where the booleans indicate if should be included in presentation"
	allColumns := columns.
	self initializeTable.
	self rebuildLayout.
	self updatePresenter 
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> currentSheep: sheep [
	selectionChangeAction ifNotNil: [ selectionChangeAction value: sheep ]
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeButtons [
	 buttonBar 
		add: (self newButton 
			label: 'Print';
			action: [ self printTable ]);
		add: ( self newButton 
			label: 'Ret søjler';
			action: [ OvinaColumnPresenter openOn: self ])
]

{ #category : #initialization }
OvinaSheepPresenter >> initializePresenters [
	 
	self initializeTable.
	buttonBar := self newButtonBar.
	self initializeButtons.
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeTable [
	table := self instantiate: SpTablePresenter.
	self activeColumns  do: [ :col |
		table addColumn: (SpStringTableColumn new
				 title: col dkName ;
				 evaluated: col getter ;
				 sortFunction: [ :s1 :s2 | 
					(s1 perform: col getter)   threeWayCompareTo:  (s2 perform: col  getter)
				] asSortFunction)
	 ].
	table 
		whenSelectedDo: [ :sheep | self currentSheep: sheep ];
		whenNoneSelectedDo: [ self currentSheep: nil ].
	"self updatePresenter."
	
]

{ #category : #initialization }
OvinaSheepPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self title;
		initialExtent: 600 @ 350 
]

{ #category : #printing }
OvinaSheepPresenter >> printHeader: html body: body [
	
	"<meta charset=""UTF-8"">"
	html html5.
	html tag: #html do: [ 
		html 
			tag: #head do: [ 
				html tag: #meta attributes: {'charset'. 'UTF-8'}.
				html tag: #style with: self tableStyle];
			tag: #body do: body
		 ]
	
	
	
]

{ #category : #printing }
OvinaSheepPresenter >> printTable [
	| html fileRef aStream |
	html := ZnHtmlOutputStream on: '' writeStream.
	self printHeader: html body: [
			html 
				tag: #h1 with: 'Udskrift af ', self title;
				tag: #table attributes: {'id'.'sheeps'}
					do: [ self printTableHeaders: html. self printTableRows: html ]
			 ].
	html flush.
	fileRef := 'ovina_print.html' asFileReference.
	fileRef deleteIfAbsent: [ "ignore" ].
	aStream :=  fileRef writeStream .
	aStream nextPutAll: html wrappedStream contents.
	aStream flush;close.
	WebBrowser openOn: (fileRef absolutePath asZnUrl )
	
	
]

{ #category : #printing }
OvinaSheepPresenter >> printTableHeaders: html [
	html tag: #tr
		do: [ self activeColumns  do: [ :col | html tag: #th with: col dkName ] ]
]

{ #category : #printing }
OvinaSheepPresenter >> printTableRows: html [

	"use the order of the table"
	|inOrder|
	"Odd, but this is the best I could come up with"
	inOrder := (1 to: table items size) collect: [ :index | table itemAt: index ].
	inOrder  do: [ :sheep | 
		html
			tag: #tr
			do: [ 
			self activeColumns  do: [ :col | html tag: #td with: (sheep perform: col getter) asString ] ] ] 
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> selectNextSheep [
	"Should select next sheep in the list"
]

{ #category : #'as yet unclassified' }
OvinaSheepPresenter >> selectPreviousSheep [
	"Should select previous sheep in the list"
]

{ #category : #accessing }
OvinaSheepPresenter >> sheepClass [
	^self subclassResponsibility 
]

{ #category : #accessing }
OvinaSheepPresenter >> sheeps [
	"Get the list of all sheeps"
	^ (OvinaSheep sheeps values select: [ :sheep | sheep class = self sheepClass  ]) 
		sort: [ :r1 :r2 | r1 id < r2 id]
]

{ #category : #printing }
OvinaSheepPresenter >> tableStyle [
	^
'#sheeps {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#sheeps td, #sheeps th {
  border: 1px solid #ddd;
  padding: 8px;
}

#sheeps tr:nth-child(even){background-color: #f2f2f2;}

#sheeps tr:hover {background-color: #ddd;}

#sheeps th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #4CAF50;
  color: white;
}'
]

{ #category : #accessing }
OvinaSheepPresenter >> updatePresenter [ 
	super updatePresenter.
	table items: self sheeps
]

{ #category : #enumerating }
OvinaSheepPresenter >> whenSelectedDo: aBlock [
	selectionChangeAction := aBlock
]
