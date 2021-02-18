Class {
	#name : #RamPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'columns'
	],
	#category : #'Ovina2-GUI'
}

{ #category : #specs }
RamPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
		yourself
]

{ #category : #examples }
RamPresenter class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #initialization }
RamPresenter >> columns [
	columns ifNil: [ columns := #(chr number name race inDate) ].
	^columns 

]

{ #category : #initialization }
RamPresenter >> initializePresenters [
	

 
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
RamPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Væddere';
		initialExtent: 1200 @ 750 
]

{ #category : #accessing }
RamPresenter >> items [
	"Get the list of all rams"
	^ (OvinaSheep sheeps values select: [ :sheep | sheep id first = $R ]) 
		sort: [ :r1 :r2 | r1 id < r2 id]
]
