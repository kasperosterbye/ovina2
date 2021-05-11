"
I am a somewhat generic html printer for sheep tables.
"
Class {
	#name : #OvinaTablePrinter,
	#superclass : #Object,
	#instVars : [
		'table',
		'title',
		'columns',
		'columnsSelector'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #accessing }
OvinaTablePrinter >> columns [

	^ columns
]

{ #category : #accessing }
OvinaTablePrinter >> columns: anObject [

	columns := anObject
]

{ #category : #accessing }
OvinaTablePrinter >> columnsSelector [

	^ columnsSelector
]

{ #category : #accessing }
OvinaTablePrinter >> columnsSelector: anObject [

	columnsSelector := anObject
]

{ #category : #printing }
OvinaTablePrinter >> printHeader: html body: body [
	
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
OvinaTablePrinter >> printTable [
	| html fileRef aStream |
	html := ZnHtmlOutputStream on: '' writeStream.
	self printHeader: html body: [
			html 
				tag: #h1 with: title;
				tag: #table attributes: {'id'. 'sheeps'}
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
OvinaTablePrinter >> printTableHeaders: html [
	html tag: #tr
		do: [ table columns  do: [ :col | html tag: #th with: col title ] ]
]

{ #category : #printing }
OvinaTablePrinter >> printTableRows: html [

	"use the order of the table"
	|inOrder|
	"Odd, but this is the best I could come up with"
	inOrder := (1 to: table items size) collect: [ :index | table itemAt: index ].
	inOrder  do: [ :item | 
		html
			tag: #tr
			do: [ 
			table columns   do: [ :col | html tag: #td with: (col evaluation value: item) asString ] ] ] 
]

{ #category : #printing }
OvinaTablePrinter >> printTableRowsOld: html [

	"use the order of the table"
	|inOrder|
	"Odd, but this is the best I could come up with"
	inOrder := (1 to: table items size) collect: [ :index | table itemAt: index ].
	inOrder  do: [ :sheep | 
		html
			tag: #tr
			do: [ 
			columnsSelector activeColumns  do: [ :col | html tag: #td with: (sheep perform: col getter) asString ] ] ] 
]

{ #category : #accessing }
OvinaTablePrinter >> table [

	^ table
]

{ #category : #accessing }
OvinaTablePrinter >> table: anObject [

	table := anObject
]

{ #category : #printing }
OvinaTablePrinter >> tableStyle [
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
OvinaTablePrinter >> title [

	^ title
]

{ #category : #accessing }
OvinaTablePrinter >> title: anObject [

	title := anObject
]
