Class {
	#name : #Ovina2DB,
	#superclass : #OvinaDB,
	#category : #'Ovina2-Database'
}

{ #category : #connecting }
Ovina2DB class >> dbPath [
	^'/Users/kasper/tmp/ovina_2_01.db3'
]

{ #category : #migration }
Ovina2DB class >> loadAll [
	| conn |
	OvinaModel initialize.
	conn := self open.
	conn loadAll.
	conn close
]

{ #category : #connecting }
Ovina2DB class >> migrateAll [

	Ovina1DB loadAll.
	self storeAll
]

{ #category : #connecting }
Ovina2DB class >> open [
	"return a connection object for the old databasedatabase"
	|path| 
	path := self dbPath.
	path asFileReference exists ifFalse: [ OvinaError signal: 'database ',path, ' not found' ].
	^self openOn: path
	
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

{ #category : #'as yet unclassified' }
Ovina2DB >> connectLineage [

	"tie connection from lamb to ewe and ram"
	"assumes all sheeps to be loaded"
	OvinaSheep lambs do: [ :lamb | 
		lamb dam addLamb: lamb.
		lamb sire addLamb: lamb]
]

{ #category : #migration }
Ovina2DB >> loadAll [

	self
		loadSheeps ;
		loadRegistrations;
		loadEvents 
]

{ #category : #migration }
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
			         date: (row at: #date);
			         result: (row at: #result).
		OvinaEvent addEvent: event.
		 ]
]

{ #category : #'as yet unclassified' }
Ovina2DB >> loadRegistrations [
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
	self connectLineage
]

{ #category : #migration }
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
