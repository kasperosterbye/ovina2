"
I implement the table of sheeps to select for a registration.

the sheepSelected iv is a dictionary indicating if a sheep is in the current registration
"
Class {
	#name : #OvinaHistSheepSelection,
	#superclass : #OvinaSheepPresenter,
	#instVars : [
		'includeLambs',
		'onlyLambs',
		'sheepSelected',
		'buttonBar2'
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
	"return a filtered sheepCollection"
	| filtered | 
	filtered := super filter: sheepCollection.
	onlyLambs ifTrue: [ filtered := filtered select: [ :sheep | sheep isLamb ]].
	^filtered
]

{ #category : #accessing }
OvinaHistSheepSelection >> filteredLambsOf: anEwe [
	anEwe isEwe ifFalse: [ ^#() ].
	^ self filter: anEwe lambs
]

{ #category : #initialization }
OvinaHistSheepSelection >> initialize [
	includeLambs := true.
	onlyLambs := false.
	sheepSelected := Dictionary new.
	
	super initialize.
]

{ #category : #initialization }
OvinaHistSheepSelection >> initializeButtons [

	super initializeButtons.
	buttonBar2 := self newButtonBar.
	buttonBar2
		add: (self newCheckBox 
				 label: 'kun lam';
				 state: onlyLambs ;
				 whenChangedDo: [ :newValue | 
					onlyLambs := newValue. 
					self updatePresenter ]);
		add: (self newCheckBox
				 label: '+lam';
				 state: includeLambs;
				 whenChangedDo: [ :newValue | 
					 includeLambs := newValue.
					 self updatePresenter ]);
		add: (self newButton
				 icon: (Smalltalk ui icons iconNamed: #checkboxUnselected);
				 label: 'alle';
				 action: [ self unselectAll ]);
		add: (self newButton
				 icon: (Smalltalk ui icons iconNamed: #checkboxSelected);
				 label: 'alle';
				 action: [ self selectAll ])
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

{ #category : #selection }
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

{ #category : #selection }
OvinaHistSheepSelection >> selectedSheeps [
	"return which sheeps are currently selected"
	^(sheepSelected select: [ :bool | bool ]) keys
]

{ #category : #initialization }
OvinaHistSheepSelection >> setLayout [ 
	super setLayout.
	self layout 
		add: (SpBoxLayout newHorizontal add: buttonBar2) expand: false fill: true padding: 3
	
]

{ #category : #accessing }
OvinaHistSheepSelection >> sheeps [
	^ self filter: OvinaSheep sheeps values
	
]

{ #category : #selection }
OvinaHistSheepSelection >> unselectAll [
	"cannot just unselect all selectedSheeps, as unselecting an Ewe might unselect its lambs, making iteration over selectedSheeps unstable"
	self sheeps do: [ :sheep | self unselectSheep: sheep ] 
]

{ #category : #selection }
OvinaHistSheepSelection >> unselectSheep: sheep [
	"sheep might not be selected"
	(sheepSelected includesKey: sheep) ifFalse: [ ^self ].
	sheepSelected at: sheep put: false.
	table selection unselectItem: sheep.
	self announce: (OvinaGUIHistSelectorRemoved new sheep: sheep).
	(includeLambs & sheep isEwe )
		ifTrue:[ ((self filteredLambsOf: sheep) ) do: [ :lamb | self unselectSheep: lamb ] ]
	
]

{ #category : #initialization }
OvinaHistSheepSelection >> updatePresenter [
	table items: self sheeps.
	
	
	
	 
	
]
