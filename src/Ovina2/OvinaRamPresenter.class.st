Class {
	#name : #OvinaRamPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'columns'
	],
	#category : #'Ovina2-GUI'
}

{ #category : #specs }
OvinaRamPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #table;
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
