Class {
	#name : #OvinaColumnSelection,
	#superclass : #Model,
	#instVars : [
		'columnSpecs',
		'name'
	],
	#classInstVars : [
		'repository'
	],
	#category : #'Ovina2-GUI Sheep'
}

{ #category : #'as yet unclassified' }
OvinaColumnSelection class >> for: key [
	(self repository includesKey: key)
		ifFalse: [ self repository at: key put: (self new name: key) update ].
	^ (self repository at: key) update
	
]

{ #category : #accessing }
OvinaColumnSelection class >> repository [
	repository ifNil: [ repository := Dictionary new ].
	^repository 
]

{ #category : #initialization }
OvinaColumnSelection >> activeColumns [
	"return the column names which are active"
	^ (self allColumns  select: #value) collect: #key

]

{ #category : #columns }
OvinaColumnSelection >> allColumns [ 
	^columnSpecs 
]

{ #category : #initialization }
OvinaColumnSelection >> allColumns: columns [
	" columns is {colName->bool. colName->bool...} 
	where the booleans indicate if should be included in presentation"
	columnSpecs := columns.
	self announcer announce: (OvinaGUIColumnSelectionChanged new)
]

{ #category : #accessing }
OvinaColumnSelection >> name [

	^ name
]

{ #category : #accessing }
OvinaColumnSelection >> name: anObject [

	name := anObject
]

{ #category : #updating }
OvinaColumnSelection >> update [
	"Re-evaluate allColumnBlock to see if new columns are now relevant.
	But keep old order, and insert new columns at the end"
	|newColumns|
	newColumns := name asSymbol asClass allColumns collect: [:colSpec | colSpec -> true].
	columnSpecs ifNil: [ 
		columnSpecs := newColumns . 
		^ self ].
	"only keep those who are in newColumns"
	newColumns := Dictionary newFromAssociations: newColumns.
	columnSpecs := columnSpecs select: [ :existing | newColumns includesKey: existing key ].
	"add those which are new, which are those in new and not in existing"
	columnSpecs do: [ :assoc | newColumns removeKey: assoc key ifAbsent: [ ] ].
	columnSpecs := columnSpecs , newColumns associations. 
	
]
