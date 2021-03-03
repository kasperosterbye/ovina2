Class {
	#name : #OvinaDB,
	#superclass : #SQLite3Connection,
	#category : #'Ovina2-Database'
}

{ #category : #connecting }
OvinaDB class >> dbPath [
	^'/Users/kasper/tmp/ovina_2_01.db3'
]

{ #category : #migration }
OvinaDB class >> loadAll [
	| conn |
	OvinaModel initialize.
	conn := self open.
	conn loadAll.
	conn close
]

{ #category : #connecting }
OvinaDB class >> migrateAll [

	OvinaDBOld loadAll.
	self storeAll
]

{ #category : #connecting }
OvinaDB class >> open [
	"return a connection object for the old databasedatabase"
	|path| 
	path := self dbPath.
	path asFileReference exists ifFalse: [ OvinaError signal: 'database ',path, ' not found' ].
	^self openOn: path
	
]

{ #category : #migration }
OvinaDB class >> reset [

	| conn |
	conn := self open.
	conn resetDB .
	conn close
]

{ #category : #migration }
OvinaDB class >> storeAll [

	| conn |
	conn := self open.
	conn storeAll.
	conn close
]

{ #category : #'as yet unclassified' }
OvinaDB >> connectLineage [

	"tie connection from lamb to ewe and ram"
	"assumes all sheeps to be loaded"
	OvinaSheep lambs do: [ :lamb | 
		lamb dam addLamb: lamb.
		lamb sire addLamb: lamb]
]

{ #category : #migration }
OvinaDB >> loadAll [

	self
		loadSheeps ;
		loadRegistrations;
		loadEvents 
]

{ #category : #migration }
OvinaDB >> loadEvents [

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
			         date: (row at: #date);
			         result: (row at: #result).
		OvinaEvent addEvent: event.
		 ]
]

{ #category : #'as yet unclassified' }
OvinaDB >> loadRegistrations [
	|  regRow |
	regRow := (self execute: 'select * from Registrations') rows.
	regRow do: [ :row | |reg|
		reg := OvinaRegistration  new
			id: (row at: #id) asString;
			kind: (row at: #kind) asLowercase ;
			date: (row at: #date);
			default: (row at: #defaultResult);
			comment: (row at: #comment).
		OvinaRegistration addRegistration: reg
		].
]

{ #category : #'as yet unclassified' }
OvinaDB >> loadSheeps [
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
	self connectLineage
]

{ #category : #migration }
OvinaDB >> resetDB [
	self 
		execute: 'delete from Events';
		execute: 'delete from Registrations';
		execute: 'delete from Properties';
		execute: 'delete from Sheeps'
]

{ #category : #store }
OvinaDB >> storeAll [

	OvinaSheep sheeps 
		valuesDo: [ :sheep | self storeSheep: sheep ].
	OvinaRegistration registrations valuesDo: [ :reg | 
		self storeRegistration: reg ].
	OvinaEvent events 
		valuesDo: [ :event | self storeEvent: event ]
]

{ #category : #store }
OvinaDB >> storeEvent: event [

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
OvinaDB >> storeRegistration: reg [

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
OvinaDB >> storeSheep: sheep [

	| stmt properties |
	stmt := 'replace into Sheeps (id, chr, number) values ({1},	{2},{3});' 
		        format: { 
				        sheep id printString.
				        sheep chr.
				        sheep number }.
	self execute: stmt.
	properties := sheep properties associations collect: [ :a | 
		              '({1},	{2},{3})' format: { 
				              sheep id printString.
				              a key asString printString.
				              a value ovinaDBString } ].

	stmt := 'replace into Properties (sheep, name, value) values {1};' 
		        format: { (properties joinUsing: ',') }.
	self execute: stmt
]
