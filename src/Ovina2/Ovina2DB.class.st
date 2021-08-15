Class {
	#name : #Ovina2DB,
	#superclass : #OvinaDB,
	#classInstVars : [
		'current'
	],
	#category : #'Ovina2-Database'
}

{ #category : #'as yet unclassified' }
Ovina2DB class >> currentClose [
	<script>
	current ifNotNil: [
		current unsubscribeFromChangeAnnouncers.
		current close.
		current := nil ]
]

{ #category : #'as yet unclassified' }
Ovina2DB class >> currentOpen [
	<script>
	current ifNil: [ current := self open ].
	current subscribeToChangeAnnouncers.
	^current
]

{ #category : #connecting }
Ovina2DB class >> dbPath [
	^FileLocator imageDirectory parent parent pathString, '/ovina_2_01.db3'
]

{ #category : #migration }
Ovina2DB class >> loadAll [
	<script>
	super loadAll 
]

{ #category : #connecting }
Ovina2DB class >> migrateAll [
	<script>
	OvinaModel initialize.
	self reset.
	Ovina1DB loadAll.
	self storeAll
]

{ #category : #migration }
Ovina2DB class >> reset [
	| conn |
	conn := self open.
	conn resetDB .
	conn close
]

{ #category : #migration }
Ovina2DB class >> storeAll [

	| conn |
	conn := self open.
	conn storeAll.
	conn close
]

{ #category : #loading }
Ovina2DB >> loadAll [

	self
		loadSheeps ;
		loadRegistrations;
		loadEvents.
	
]

{ #category : #loading }
Ovina2DB >> loadEvents [

	| eventRow |
	eventRow := (self execute: 'select * from Events') rows.
	eventRow do: [ :row | 
		| event |
		event := OvinaEvent new
			         id: (row at: #id) asString;
			         registration:
				         (OvinaRegistration registrations at:
						          (row at: #registration) asString);
			         sheep: (OvinaSheep sheeps at: (row at: #sheep));
			         date: (row at: #date) asDate;
			         result: (row at: #result).
		OvinaEvent addEvent: event.
		 ]
]

{ #category : #loading }
Ovina2DB >> loadRegistrations [
	|  regRow |
	regRow := (self execute: 'select * from Registrations') rows.
	regRow do: [ :row | |reg|
		reg := OvinaRegistration  new
			id: (row at: #id) asString;
			kind: (row at: #kind) asLowercase ;
			date: (row at: #date) asDate;
			default: (row at: #defaultResult);
			comment: (row at: #comment).
		OvinaRegistration addRegistration: reg
		].
]

{ #category : #loading }
Ovina2DB >> loadSheeps [
	|sheepRows propertyRows|
	sheepRows := (self execute: 'select * from Sheeps') rows.
	sheepRows do: [ :row | |id sheep|
		id := (row at: #id).
		sheep := (OvinaSheep kindFromId: id) new
			id: id;
			chr: (row at: #chr);
			number: (row at: #number).
		OvinaSheep addSheep: sheep.
		].
	propertyRows := (self execute: 'select * from Properties') rows.
	propertyRows do: [ :row | |sheep|
		sheep := OvinaSheep sheep: (row at: #sheep).
		sheep property: (row at: #name) asSymbol  put: (row at: #value).
		].
]

{ #category : #store }
Ovina2DB >> removeEvent: event [

	| stmt |
	stmt := 'delete from Events where id = {1};' 
		        format: { event id }.
	self execute: stmt
]

{ #category : #store }
Ovina2DB >> removeRegistration: reg [

	| stmt |
	stmt := 'delete from Registrations where id = {1};' 
		        format: { reg id }.
	self execute: stmt
]

{ #category : #store }
Ovina2DB >> removeSheep: sheep [

	| stmt|
	stmt := 'delete from Sheeps where id = {1};' 
		        format: { sheep id printString}.
	self execute: stmt.
	stmt := 'delete from Properties where sheep = {1};' 
		        format: { sheep id printString }.
	self execute: stmt
]

{ #category : #'db handling' }
Ovina2DB >> resetDB [
	self 
		execute: 'delete from Events';
		execute: 'delete from Registrations';
		execute: 'delete from Properties';
		execute: 'delete from Sheeps'
]

{ #category : #store }
Ovina2DB >> storeAll [

	OvinaSheep sheeps 
		valuesDo: [ :sheep | self storeSheep: sheep ].
	OvinaRegistration registrations valuesDo: [ :reg | 
		self storeRegistration: reg ].
	OvinaEvent events 
		valuesDo: [ :event | self storeEvent: event ]
]

{ #category : #store }
Ovina2DB >> storeEvent: event [

	| stmt |
	stmt := 'replace into Events (id, registration, sheep, date, result) values ({1},{2},{3},{4},{5});' 
		        format: { 
				        event id.
				        event registration id.
				        event sheep ovinaDBString.
				        event date ovinaDBString.
				        event result ovinaDBString }.
	self execute: stmt
]

{ #category : #store }
Ovina2DB >> storeRegistration: reg [

	| stmt |
	stmt := 'replace into Registrations (id, kind, date, defaultResult, comment) values ({1},{2},{3},{4},{5});' 
		        format: { 
				        reg id.
				        reg kind ovinaDBString.
				        reg date ovinaDBString.
				        reg default ovinaDBString.
				        reg comment ovinaDBString }.
	self execute: stmt
]

{ #category : #store }
Ovina2DB >> storeSheep: sheep [

	| stmt properties |
	stmt := 'replace into Sheeps (id, chr, number) values ({1}, {2}, {3});' 
		        format: { 
				        sheep id printString.
				        sheep chr.
				        sheep number }.
	self execute: stmt.
	properties := sheep properties associations collect: [ :a | 
		              '({1},	{2},{3})' format: { 
				              sheep id printString.
				              a key asString printString.
				              a value ovinaDBString   } ].

	stmt := 'replace into Properties (sheep, name, value) values {1};' 
		        format: { (properties joinUsing: ',') }.
	self execute: stmt
]

{ #category : #'db handling' }
Ovina2DB >> subscribeToChangeAnnouncers [
	OvinaModel announcer
		when: OvinaModelSheepChanged do: [:ann | self storeSheep: ann sheep];
		when: OvinaModelSheepRemoved do: [ :ann | self removeSheep: ann sheep ];
		
		when: OvinaModelEventChanged do: [:ann | self storeEvent: ann event];
		when: OvinaModelEventRemoved do: [ :ann | self removeEvent: ann event ];
		
		when: OvinaModelRegistrationChanged do: [:ann | self storeRegistration: ann registration];
		when: OvinaModelRegistrationRemoved do: [:ann | self removeRegistration: ann registration]
]

{ #category : #'db handling' }
Ovina2DB >> unsubscribeFromChangeAnnouncers [
	"This is called when the image close down, and as such is a good idea"
	OvinaModel announcer subscriptions reset.
	
]
