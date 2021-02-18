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

{ #category : #'as yet unclassified' }
OvinaDB class >> loadOldRams [
	| conn ramRows |
	conn := self openOld.
	ramRows := (conn execute: 'select * from rams') rows.
	ramRows do: [ :row | |ram|
		ram := OvinaRam new
			id: 'R', (row at: #ramID) asString;
			chr: (row at: #chr);
			number: (row at: #number);
			name: (row at: #name);
			race: (row at: #race ) asLowercase ;
			inDate: (row at: #inDate) yyyymmdd .
		OvinaSheep addSheep: ram.
		].
	conn close.
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

{ #category : #accessing }
OvinaDB class >> old [
	"return a connection to the old db"
	old ifNil: [ old := self openOld  ].
	^old
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
