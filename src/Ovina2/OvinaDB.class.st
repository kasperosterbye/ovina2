Class {
	#name : #OvinaDB,
	#superclass : #SQLite3Connection,
	#category : #'Ovina2-Database'
}

{ #category : #connecting }
OvinaDB class >> dbNew [
	^'ovina_2_01.db3'
]

{ #category : #connecting }
OvinaDB class >> dbOld [
	^'ovina3a.db'
]

{ #category : #connecting }
OvinaDB class >> dbPath [
	^'/Users/kasper/tmp/'
]

{ #category : #migration }
OvinaDB class >> loadOldEwes [
	| conn eweRows |
	conn := self openOld.
	eweRows := (conn execute: 'select * from ewes') rows.
	eweRows do: [ :row | |ewe|
		ewe := OvinaEwe new
			id: 'E', (row at: #eweID) asString;
			chr: (row at: #chr) asString;
			number: (row at: #number) asString;
			name: (row at: #name);
			race: (row at: #race ) asLowercase ;
			inDate: (row at: #inDate) yyyymmdd .
		OvinaSheep addSheep: ewe.
		].
	conn close.
]

{ #category : #migration }
OvinaDB class >> loadOldLambs [
	| conn lambRows |
	conn := self openOld.
	lambRows := (conn execute: 'select * from lambs') rows.
	lambRows do: [ :row | |lamb|
		lamb := OvinaLamb new
			id: 'L', (row at: #lambID) asString;
			chr: OvinaSheep maarumlamChr;
			number: (row at: #number) asString;
			dam: (OvinaSheep sheeps at: ('E', (row at: #momFK) asString));
			sire: (OvinaSheep sheeps at: ('R', (row at: #dadFK) asString));
			inDate: (row at: #inDate) yyyymmdd;
			event: (row at: #event);
			sex: (row at: #sex);
			growth: (row at: #growth) asString;
			usage: (row at: #usage);
			color: (row at: #color);
			comment: (row at: #comment).
		OvinaSheep addSheep: lamb.
		].
	conn close.
]

{ #category : #migration }
OvinaDB class >> loadOldRams [
	| conn ramRows |
	conn := self openOld.
	ramRows := (conn execute: 'select * from rams') rows.
	ramRows do: [ :row | |ram|
		ram := OvinaRam new
			id: 'R', (row at: #ramID) asString;
			chr: (row at: #chr) asString;
			number: (row at: #number) asString;
			name: (row at: #name);
			race: (row at: #race ) asLowercase ;
			inDate: (row at: #inDate) yyyymmdd .
		OvinaSheep addSheep: ram.
		].
	conn close.
]

{ #category : #migration }
OvinaDB class >> loadOldRegistrations [
	| conn regRow |
	conn := self openOld.
	regRow := (conn execute: 'select * from descriptors') rows.
	regRow do: [ :row | |reg|
		reg := OvinaRegistration  new
			id: (row at: #descID) asString;
			kind: (row at: #descTag) asLowercase ;
			date: (row at: #descDate);
			comment: (row at: #descComment);
			default: ''.
		OvinaRegistration addRegistration: reg
		].
	
	conn close.
]

{ #category : #migration }
OvinaDB class >> loadOldSheeps [
	self loadOldRams; loadOldEwes ; loadOldLambs 
]

{ #category : #connecting }
OvinaDB class >> migrateAll [
	self migrateRams.
	self migrateEwes.
	self migrateLambs.
	self migrateRegistrations.
	self migrateEvents.
	self migrateProperties.
]

{ #category : #migration }
OvinaDB class >> migrateEvents [

]

{ #category : #migration }
OvinaDB class >> migrateEwes [

]

{ #category : #migration }
OvinaDB class >> migrateLambs [

]

{ #category : #migration }
OvinaDB class >> migrateProperties [

]

{ #category : #migration }
OvinaDB class >> migrateRams [

	self loadOldRams.
	self storeAllSheep.
	
	
	
]

{ #category : #migration }
OvinaDB class >> migrateRegistrations [

]

{ #category : #connecting }
OvinaDB class >> openNew [
	"return a connection object for the old databasedatabase"
	|path| 
	path := self dbPath , self dbNew.
	path asFileReference exists ifFalse: [ OvinaError signal: 'database ',path, ' not found' ].
	^self openOn: path
	
]

{ #category : #connecting }
OvinaDB class >> openOld [
	"return a connection object for the old databasedatabase"
	|path| 
	path := self dbPath , self dbOld.
	path asFileReference exists ifFalse: [ OvinaError signal: 'database ',path, ' not found' ].
	^self openOn: path
	
]

{ #category : #migration }
OvinaDB class >> storeAllSheep [

	| conn |
	conn := self openNew.
	OvinaSheep sheeps valuesDo: [ :sheep |
		conn storeSheep: sheep ].
	conn close.
	
	
	
]

{ #category : #'as yet unclassified' }
OvinaDB >> storeSheep: sheep [
	| stmt properties |
	stmt := 'replace into Sheeps (sheepID, chr, number) values ({1},	{2},{3});' 
		format: { sheep id printString. sheep chr. sheep number }.
	self execute: stmt.
	properties := sheep properties associations collect: [ :a | 
			'({1},	{2},{3})' format: {sheep id printString. a key asString printString. a value printString}].
			
	stmt:= 'replace into Properties (sheepFK, name, value) values {1};'
		format: {properties joinUsing: ','}.
	self execute: stmt.
]
