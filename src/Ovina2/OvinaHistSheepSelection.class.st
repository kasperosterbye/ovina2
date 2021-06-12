"
I implement the table of sheeps to select for a registration.

the sheepSelected iv is a dictionary indicating if a sheep is in the current registration
"
Class {
	#name : #OvinaHistSheepSelection,
	#superclass : #OvinaSheepPresenter,
	#instVars : [
		'includeLambs',
		'sheepSelected'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #examples }
OvinaHistSheepSelection class >> open [
	<example>
	self new openWithSpec 
]

{ #category : #accessing }
OvinaHistSheepSelection class >> sheepClass [
	^OvinaSheep 
]

{ #category : #accessing }
OvinaHistSheepSelection >> filter: sheepCollection [
	^ sheepCollection select: [ :sheep | sheep present ]
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> filteredLambsOf: anEwe [
	anEwe isEwe ifFalse: [ ^#() ].
	^ self filter: anEwe lambs
]

{ #category : #initialization }
OvinaHistSheepSelection >> initialize [
	includeLambs := true.
	sheepSelected := Dictionary new.
	
	super initialize.
]

{ #category : #initialization }
OvinaHistSheepSelection >> initializeButtons [
	super initializeButtons.
	buttonBar
		add: (self newButton 
				 icon: (ThemeIcons current iconNamed: #checkboxUnselected) ;
				 label: 'alle';
				 action: [self unselectAll]);
		add: (self newButton 
				 icon: (ThemeIcons current iconNamed: #checkboxSelected) ;
				 label: 'alle';
				 action: [self selectAll]);
		add: (self newCheckBox
				 label: 'Inkluder lam';
				 state: includeLambs ;
				 whenChangedDo: [ :newValue | 
					 includeLambs := newValue.
					 self updatePresenter ]);
		yourself 
]

{ #category : #initialization }
OvinaHistSheepSelection >> initializeTable [
	|selectionColumn|
	super initializeTable.
	selectionColumn := SpCheckBoxTableColumn new
			title: 'vælg' ;
			width: (TextStyle defaultFont widthOfString: 'vælg') + 15;
			evaluated: [ :sheep | sheepSelected at: sheep ifAbsent: [ false ] ] ;
			onActivation: [ :sheep | self selectSheep: sheep];
			onDeactivation: [ :sheep | self unselectSheep: sheep ].
	table sortingBlock: [ :s1 :s2 | s1 ramEweLambOrder: s2 ] asSortFunction.
	table columns: { selectionColumn  }, table columns
]

{ #category : #selection }
OvinaHistSheepSelection >> selectAll [
	self sheeps do: [ :sheep | self selectSheep: sheep ] 
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> selectSheep: sheep [
	sheepSelected at: sheep put: true.
	table selection selectItem: sheep.
	self announce: (OvinaGUIHistSelectorAdded new sheep: sheep).
	(includeLambs & sheep isEwe )
		ifTrue:[ (self filteredLambsOf: sheep) do: [ :lamb | self selectSheep: lamb] ]
	
]

{ #category : #initialization }
OvinaHistSheepSelection >> selected: someSheeps [
	"sendt from history presenter (my owner)"
	sheepSelected := Dictionary new.
	someSheeps do: [ :s | sheepSelected at: s put: true ].
	self updatePresenter.
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> selectedSheeps [
	"return which sheeps are currently selected"
	^(sheepSelected select: [ :bool | bool ]) keys
]

{ #category : #accessing }
OvinaHistSheepSelection >> sheeps [
	^ self filter: OvinaSheep sheeps values
	
]

{ #category : #selection }
OvinaHistSheepSelection >> unselectAll [
	self sheeps do: [ :sheep | self unselectSheep: sheep ] 
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> unselectSheep: sheep [
	sheepSelected at: sheep put: false.
	table selection unselectItem: sheep.
	self announce: (OvinaGUIHistSelectorRemoved new sheep: sheep).
	(includeLambs & sheep isEwe )
		ifTrue:[ ((self filteredLambsOf: sheep) ) do: [ :lamb | self unselectSheep: lamb ] ]
	
]

{ #category : #'as yet unclassified' }
OvinaHistSheepSelection >> updatePresenter [
	table items: self sheeps.
	
	
	
	 
	
]
