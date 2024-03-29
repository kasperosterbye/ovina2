"
I am the superclass for sheeps.
A sheep has a few intrinsic properties (id, chr, and number).
id is on the form AXXXX, where A is either E,L,R (Ewe, Lamb, Ram), XXXX is an id. This scheme allow us to migrate the old id's to the new database.

In addition, a sheep can have different persistent poperties. Those are stored in a large Dictionary on the class side. SheepID->Dictionary<propertyName,StringValue>.

All sheeps are stored in a sheeps table - Dictionary<ID,Sheep>

"
Class {
	#name : #OvinaSheep,
	#superclass : #OvinaModelElement,
	#instVars : [
		'id',
		'chr',
		'number',
		'properties'
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

{ #category : #accessing }
OvinaSheep class >> all [
	^ self sheeps values
]

{ #category : #columns }
OvinaSheep class >> allColumns [
	"return a list of all columns. A column is specified using pragma 
	sheepColumn:#('name in danish' optionalSampleStringWidth<String> optionalStringSetter:<Symbol>)"
	^ (Pragma allNamed: #sheepColumn: from: self to: OvinaSheep)
		collect: [ :prag | |args|
			args := prag arguments first.
			args isArray ifFalse: [ ^ self error: 'argument to #sheepColumn pragma must be array' ].
			OvinaColumnSpecification new
				dkName: args first;
				getter: prag method selector;
				setter: args secondOrNil;
				choices: args thirdOrNil]
]

{ #category : #browsing }
OvinaSheep class >> browseAllColumns [
	| all |
	<script>
	all := {OvinaEwe. OvinaLamb. OvinaRam} 
				inject: OrderedCollection new into: [ :allGetters :sheepClass |
					allGetters, (sheepClass allColumns 
						collect: [ :col | sheepClass lookupSelector: col getter])].
	all := all asSet asArray sort: [:a :b | a selector <= b selector].  
	ClyQueryBrowserMorph  browseMethods: all
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

{ #category : #updating }
OvinaSheep >> changed [
	"I have changed, invalidateCache (which notifies using announcer)"
	self invalidateCache.
]

{ #category : #accessing }
OvinaSheep >> chr [
	<sheepColumn: #('chr' chr:)>
	^ chr asInteger 
]

{ #category : #accessing }
OvinaSheep >> chr: value [
	
	chr:= value isString 
		ifTrue: [ value extractNumber  ] 
		ifFalse: [ value ].
	self changed
]

{ #category : #history }
OvinaSheep >> events [
	"return all events on me, last first"
	^ self cache: #events 
		compute: [(OvinaEvent events values select: [ :ev | ev sheep = self ]) sort: [ :a :b | a date > b date ] ].
]

{ #category : #accessing }
OvinaSheep >> id [
	<sheepColumn: #('ID')>
	^ id
]

{ #category : #accessing }
OvinaSheep >> id: aString [
	"Do not notify about change to id - it should only happen once"
	id := aString
]

{ #category : #'accessing - properties' }
OvinaSheep >> inDate [
	<sheepColumn:#('Inddato' inDate:)>
	^(self property: #inDate) asDate
]

{ #category : #'accessing - properties' }
OvinaSheep >> inDate: date [
	| newDate |	
	date isString 
		ifFalse: [ ^self property: #inDate put: date yyyymmdd   ].
	"date string might be incomplete. "
	[ newDate := date parseDKDate yyyymmdd ]
		on: Exception
		do: [ newDate := (self properties at: #inDate ifAbsent: [ Date today yyyymmdd ] ) ].
	^self property: #inDate put: newDate
	 	
	
]

{ #category : #initialization }
OvinaSheep >> initialize [
	super initialize.
	id := 'X0'.
	chr := self class maarumlamChr.
	number := 0.
	properties := Dictionary new.
]

{ #category : #updating }
OvinaSheep >> invalidateCache [ 
	super invalidateCache.
	OvinaModel announcer announce: (OvinaModelSheepChanged new sheep: self)
]

{ #category : #testing }
OvinaSheep >> isEwe [
	^false
]

{ #category : #testing }
OvinaSheep >> isLamb [
	^false
]

{ #category : #testing }
OvinaSheep >> isRam [
	^false
]

{ #category : #'accessing - properties' }
OvinaSheep >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	self subclassResponsibility 
]

{ #category : #accessing }
OvinaSheep >> location [
	<sheepColumn:#('placering')>
	^ self cache: #location
		compute: [ 
			(self events detect: [ :ev | ev kind = 'flytning' ] ifNone: [ nil ])
				ifNotNil: [ :event | (event result ifEmpty:  ['hjemme']) asLowercase  ] 
				ifNil: [ 'hjemme' ]
			 ]
]

{ #category : #accessing }
OvinaSheep >> name [

	<sheepColumn: #('navn' name:)>
	self subclassResponsibility 
]

{ #category : #printing }
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
OvinaSheep >> number: value [

	number := value isString 
		ifTrue: [ value extractNumber  ] 
		ifFalse: [ value ].
	self changed
]

{ #category : #printing }
OvinaSheep >> ovinaDBString [ 
	^ id asString printString
]

{ #category : #rendering }
OvinaSheep >> present [
	"should return true if the sheep is alive"
	self subclassResponsibility 
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
	properties at: property put: value.
	self changed
]

{ #category : #'accessing - properties' }
OvinaSheep >> race [
	<sheepColumn: #('race' race:)>
	^self cache: #race 
		compute: [ self raceCompute  ]
]

{ #category : #'accessing - properties' }
OvinaSheep >> race: race [
	((self property: #race) isNotNil and: [ self chr = OvinaSheep maarumlamChr ])
		ifTrue: [ 
			UIManager default alert: 'Racen er beregnet for dyr født hos os'.
			^self ].
	^self property: #race put: race
]

{ #category : #history }
OvinaSheep >> ramEweLambOrder: otherSheep [
	"I am a threeWayCompareTo: implementation used in OvinaHistSheepSelection"
	"Rams before Ewes before Lambs"
	"Lambs order by mothers number, lambs of same mother as equal"
	^ self sortingScore threeWayCompareTo: otherSheep sortingScore 
	
	
	
]

{ #category : #history }
OvinaSheep >> slaughterWeight [
	"return the weight of the meat as returned from the slaughter. If not slaughtered, return nil" 
	<sheepColumn: #('slagtevægt')>
	^ self 
		cache: #slaughterWeight
	 	compute: [ self slaughterWeightCompute  ]
]

{ #category : #history }
OvinaSheep >> slaughterWeightCompute [
	"return the weight of the meat as returned from the slaughter. If not slaughtered, return -1" 
	|event| 
	event := self events 
		detect: [ :ev | ev kind asLowercase = 'slagtevægt' ] 
		ifNone: [ ^-1 ].
	^ event result asDKNumber 
]

{ #category : #'accessing - properties' }
OvinaSheep >> sortingScore [
	^ self subclassResponsibility 
]
