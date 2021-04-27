"
I am the superclass for sheeps.
A sheep has a few intrinsic properties (id, chr, and number).
id is on the form AXXXX, where A is either E,L,R (Ewe, Lamb, Ram), XXXX is an id. This scheme allow us to migrate the old id's to the new database.

In addition, a sheep can have different persistent poperties. Those are stored in a large Dictionary on the class side. SheepID->Dictionary<propertyName,StringValue>.

All sheeps are stored in a sheeps table - Dictionary<ID,Sheep>

"
Class {
	#name : #OvinaSheep,
	#superclass : #Model,
	#instVars : [
		'id',
		'chr',
		'number',
		'properties',
		'cachings'
	],
	#classInstVars : [
		'sheeps'
	],
	#category : #'Ovina2-Model'
}

{ #category : #sheeps }
OvinaSheep class >> addSheep: aSheep [
	(self sheeps includesKey: aSheep id) ifTrue:[self error: 'Double insert???'].
	self sheeps at: aSheep id put: aSheep
]

{ #category : #columns }
OvinaSheep class >> allColumns [
	"return a list of all columns. A column is specified using pragma 
	sheepColumn:#('name in danish' optionalStringSetter:)"
	^ (Pragma allNamed: #sheepColumn: from: self to: OvinaSheep)
		collect: [ :prag | |args|
			args := prag arguments first.
			OvinaColumnSpecification new
				dkName: args first;
				getter: prag method selector;
				setter: (args size > 1 ifTrue: [ args last ] ifFalse: [ nil ])
				]
]

{ #category : #sheeps }
OvinaSheep class >> ewes [
	^ OvinaSheep sheeps select: [ :s| s id first = $E ]
]

{ #category : #sheeps }
OvinaSheep class >> initialize [
	<script>
	sheeps := nil.
	
]

{ #category : #utilities }
OvinaSheep class >> kindFromId: id [
	id first = $L ifTrue:[^OvinaLamb].
	id first = $E ifTrue:[^OvinaEwe].
	id first = $R ifTrue:[^OvinaRam].
	self error: 'Unknow sheep type: ', id
]

{ #category : #sheeps }
OvinaSheep class >> lambs [
	^ OvinaSheep sheeps select: [ :s| s id first = $L ]
]

{ #category : #properties }
OvinaSheep class >> maarumlamChr [
	^ 112633
]

{ #category : #sheeps }
OvinaSheep class >> rams [
	^ OvinaSheep sheeps select: [ :s| s id first = $R ]
]

{ #category : #sheeps }
OvinaSheep class >> sheep: id [
	"return the sheep with id <String>. If id is nil, return nil"
	id ifNil: [ ^nil ].
	^self sheeps at: id
]

{ #category : #sheeps }
OvinaSheep class >> sheeps [
	"return the mapping of ID to sheep"
	sheeps ifNil: [ sheeps := Dictionary new ].
	^sheeps
]

{ #category : #caching }
OvinaSheep >> cache: symbol compute: block [
	^ cachings at: symbol ifAbsentPut: block
	
]

{ #category : #accessing }
OvinaSheep >> chr [
	<sheepColumn: #('chr' chr:)>
	^ chr asInteger 
]

{ #category : #accessing }
OvinaSheep >> chr: aString [

	chr := aString asInteger
]

{ #category : #'accessing - properties' }
OvinaSheep >> computeRace [

	^'todo'
]

{ #category : #history }
OvinaSheep >> events [
	"return all events on me, last first"
	^ self cache: #events 
		compute: [(OvinaEvent events values select: [ :ev | ev sheep = self ]) reversed ].
]

{ #category : #accessing }
OvinaSheep >> id [

	^ id
]

{ #category : #accessing }
OvinaSheep >> id: aString [

	id := aString
]

{ #category : #'accessing - properties' }
OvinaSheep >> inDate [
	<sheepColumn:#('Inddato' inDate:)>
	^(self property: #inDate) 
]

{ #category : #'accessing - properties' }
OvinaSheep >> inDate: date [
	date isString 
		ifTrue: [ ^self property: #inDate put: date parseDKDate  ]
	 	ifFalse: [ ^self property: #inDate put: date   ]
	
]

{ #category : #initialization }
OvinaSheep >> initialize [
	super initialize.
	properties := Dictionary new.
	cachings := Dictionary new.
]

{ #category : #caching }
OvinaSheep >> invalidateCache [
	cachings := Dictionary new.
]

{ #category : #'accessing - properties' }
OvinaSheep >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
OvinaSheep >> noteField [
	<sheepColumn:#('note ____________')>
	^''
]

{ #category : #accessing }
OvinaSheep >> number [
	<sheepColumn: #('nummer' number:)>
	^ number asInteger 
]

{ #category : #accessing }
OvinaSheep >> number: aString [

	number := aString asInteger
]

{ #category : #'accessing - properties' }
OvinaSheep >> outDate [
	<sheepColumn:#('Ud dato' outDate:)>
	^self property: #outDate
]

{ #category : #'accessing - properties' }
OvinaSheep >> outDate: date [
	date isString 
		ifTrue: [ ^self property: #outDate put: date parseDKDate  ]
	 	ifFalse: [ ^self property: #outDate put: date]
]

{ #category : #'as yet unclassified' }
OvinaSheep >> ovinaDBString [ 
	^ id asString printString
]

{ #category : #'accessing - properties' }
OvinaSheep >> present [

	"return true if the sheep is still alive"

	^ self outDate isNil and: [ self slaughterWeight isNil ]
]

{ #category : #printing }
OvinaSheep >> printOn: aStream [
	aStream nextPutAll: '[';
	print: ({ id. chr. number } , (self properties ifNotNil: [ :p | p values ] ifNil: [ #() ]) );
	nextPut: $]
]

{ #category : #properties }
OvinaSheep >> properties [
	"return a property dictionary for this sheep"
	^properties.
]

{ #category : #properties }
OvinaSheep >> property: property [
	"return the value for property or nil"
	^properties at: property ifAbsent: [nil].
]

{ #category : #properties }
OvinaSheep >> property: property put: value [
	"set property to value if property is not nil"
	property ifNil: [ self error: 'Should not store with property name nil' ].
	properties at: property put: value
]

{ #category : #'accessing - properties' }
OvinaSheep >> race [
	|race|
	<sheepColumn: #('race' race:)>
	race := self property: #race.
	race ifNil: [ ^ self computeRace ].
	^ race
]

{ #category : #'accessing - properties' }
OvinaSheep >> race: race [
	^self property: #race put: race
]

{ #category : #history }
OvinaSheep >> slaughterWeight [
	"return the weight of the meat as returned from the slaughter. If not slaughtered, return nil" 
	|event| 
	event := self events 
		detect: [ :ev | ev registration kind asLowercase = 'slagtevægt' ] 
		ifNone: [ ^nil ].
	^ OvinaModel dkNumberFrom: event result
]
