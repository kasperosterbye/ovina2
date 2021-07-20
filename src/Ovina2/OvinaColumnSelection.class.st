"
I represent which columns are selected. 
On the class side I maintain instances for each of Ewe, Ram and Lambs in the class instance variable repository.

My two instance variable are used as:
* columnSpecs - An array of associations OvinaColumnSpecification->Boolean
* name - name of the class (I.e. Ewe) I represent. The name is used in the `update` method to update me when new columns are defined in the classes.
"
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

{ #category : #accessing }
OvinaColumnSelection class >> defaultOrder [
	^{
#id->false. 
#number->true.
#name -> true.
#chr->false.
#inDate->true.
#outDate->false.
#age->false.
#race->false.
#color->false.
#location->false}

]

{ #category : #'as yet unclassified' }
OvinaColumnSelection class >> for: sheepClassName [
	(self repository includesKey: sheepClassName)
		ifFalse: [ self repository at: sheepClassName put: (self new name: sheepClassName) updateColumns ].
	^ (self repository at: sheepClassName) updateColumns 
	
]

{ #category : #accessing }
OvinaColumnSelection class >> repository [
	repository ifNil: [ repository := Dictionary new ].
	^repository 
]

{ #category : #initialization }
OvinaColumnSelection class >> resetRepository [
	<script>
	repository := Dictionary new
]

{ #category : #initialization }
OvinaColumnSelection >> activeColumns [
	"return the columns which are active"
	^ (self allColumns select: #value) collect: #key

]

{ #category : #columns }
OvinaColumnSelection >> allColumns [ 
	^columnSpecs 
]

{ #category : #initialization }
OvinaColumnSelection >> allColumns: columns [
	" columns is Array of {colName->bool. colName->bool...} 
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
OvinaColumnSelection >> updateColumns [ 
	"check my class to see if new columns are now relevant.
	But keep old order, and insert new columns at the end.
	noteField is a special case and should always be last."
	|allByGetter existingOrder new noteField|
	"existing order maps getter names to true/false"
	existingOrder := OrderedDictionary newFrom: (columnSpecs 
	 	ifNil: [  self class defaultOrder]
		ifNotNil: [ columnSpecs collect: [:assoc | assoc key getter -> assoc value]]).
	existingOrder removeKey: #noteField ifAbsent: [  ].
	
	allByGetter := Dictionary newFromAssociations: 
		(name asSymbol asClass allColumns collect: [:col | col getter -> col]).
	noteField := allByGetter at: #noteField.
	allByGetter removeKey: #noteField ifAbsent: [  ].
		
	new := OrderedDictionary new.
	existingOrder associationsDo: [ :assoc |	
		(allByGetter includesKey: assoc key)
			ifTrue: [ new at: (allByGetter at: assoc key) put: assoc value.
				allByGetter removeKey: assoc key ] ].
	allByGetter valuesDo: [ :col |
		new at: col put: false ].
	"Add noteField to the end"
	new at: noteField  put: false.
	columnSpecs := new associations
	
]

{ #category : #updating }
OvinaColumnSelection >> update_old [
	"check my class to see if new columns are now relevant.
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
