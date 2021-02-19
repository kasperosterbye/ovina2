Class {
	#name : #OvinaRamPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'columns',
		'tableBox',
		'table',
		'columnPicker',
		'printAll',
		'newRam',
		'editColumns'
	],
	#category : #'Ovina2-GUI'
}

{ #category : #specs }
OvinaRamPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
		add: (SpBoxLayout newHorizontal add: #printAll; add: #newRam; add: #editColumns) 
			expand: false fill: true padding: 3;
		yourself
]

{ #category : #examples }
OvinaRamPresenter class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #initialization }
OvinaRamPresenter >> columns [
	columns ifNil: [ columns := #(chr number name race inDate) ].
	^columns 

]

{ #category : #initialization }
OvinaRamPresenter >> initializePresenters [
	 
	self initializeTable.
	printAll := self newButton 
		label: 'Print';
		action: [ self printTable ].
	newRam := self newButton 
		label: 'ny vædder';
		action: [ self halt. ].
	editColumns := self newButton 
		label: 'Ret søjler';
		action: [ self halt. ].
	
]

{ #category : #initialization }
OvinaRamPresenter >> initializeTable [
	 
	table := self instantiate: SpTablePresenter.
	self columns do: [ :col |
		table addColumn: (SpStringTableColumn new
				 title: col;
				 evaluated: col asSymbol ;
				 sortFunction: [ :s1 :s2 | 
					(s1 perform: col)   threeWayCompareTo:  (s2 perform: col  )
				] asSortFunction)
	 ].
	table items: self items
	
]

{ #category : #initialization }
OvinaRamPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Væddere';
		initialExtent: 600 @ 350 
]

{ #category : #accessing }
OvinaRamPresenter >> items [
	"Get the list of all rams"
	^ (OvinaSheep sheeps values select: [ :sheep | sheep id first = $R ]) 
		sort: [ :r1 :r2 | r1 id < r2 id]
]

{ #category : #printing }
OvinaRamPresenter >> printHeader: html body: body [
	
	"<meta charset=""UTF-8"">"
	html html5.
	html tag: #html do: [ 
		html 
			tag: #head do: [ html tag: #meta attributes: {'charset'. 'UTF-8'}];
			tag: #body do: body
		 ]
	
	
	
]

{ #category : #printing }
OvinaRamPresenter >> printTable [
	| html fileRef aStream |
	html := ZnHtmlOutputStream on: '' writeStream.
	self printHeader: html body: [
			html 
				tag: #h1 with: 'Udskrift af væddere';
				tag: #table attributes: {'style'.'text-align: right; width:100%'}
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
OvinaRamPresenter >> printTableHeaders: html [
	html tag: #tr
		do: [ columns do: [ :col | html tag: #th with: col asString ] ]
]

{ #category : #printing }
OvinaRamPresenter >> printTableRows: html [

	"use the order of the table"
	|inOrder|
	inOrder := (1 to: table items size) collect: [ :index | table itemAt: index ].
	self halt.
	inOrder  do: [ :sheep | 
		html
			tag: #tr
			do: [ 
			columns do: [ :col | html tag: #td with: (sheep perform: col) asString ] ] ] 
]
