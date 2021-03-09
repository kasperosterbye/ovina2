Class {
	#name : #OvinaDBOld,
	#superclass : #SQLite3Connection,
	#category : #'Ovina2-Database'
}

{ #category : #connecting }
OvinaDBOld class >> dbPath [
	^'/Users/kasper/tmp/ovina3a.db'
]

{ #category : #migration }
OvinaDBOld class >> loadAll [

	| conn |
	
	OvinaModel initialize.
	conn := self open.
	conn loadAll.
	conn close
]

{ #category : #connecting }
OvinaDBOld class >> open [
	"return a connection object for the old databasedatabase"
	|path| 
	path := self dbPath.
	path asFileReference exists ifFalse: [ OvinaError signal: 'database ',path, ' not found' ].
	^self openOn: path
	
]

{ #category : #'as yet unclassified' }
OvinaDBOld >> loadAll [

	self
		loadRams;
		loadEwes;
		loadLambs;
		loadRegistrations;
		loadEvents 
]

{ #category : #migration }
OvinaDBOld >> loadEvents [

	| eventRow |
	eventRow := (self execute: 'select * from events') rows.
	eventRow do: [ :row | 
		| event |
		event := OvinaEvent new
			         id: (row at: #eventID) asString;
			         registration:
				         (OvinaRegistration registrations at:
						          (row at: #descFK) asString);
			         sheep: (OvinaSheep sheeps at:
						          (row at: #sheepKind) first asString
						          , (row at: #sheepFK) asString);
			         date: (row at: #eventDate);
			         result: (row at: #value).
		OvinaEvent addEvent: event ].
]

{ #category : #migration }
OvinaDBOld >> loadEwes [
	| eweRows |
	eweRows := (self execute: 'select * from ewes') rows.
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
]

{ #category : #migration }
OvinaDBOld >> loadLambs [
	|  lambRows |
	lambRows := (self execute: 'select * from lambs') rows.
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
]

{ #category : #migration }
OvinaDBOld >> loadRams [
	| ramRows |
	ramRows := (self execute: 'select * from rams') rows.
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
]

{ #category : #migration }
OvinaDBOld >> loadRegistrations [
	|  regRow |
	regRow := (self execute: 'select * from descriptors') rows.
	regRow do: [ :row | |reg|
		reg := OvinaRegistration  new
			id: (row at: #descID) asString;
			kind: (row at: #descTag) asLowercase ;
			date: (row at: #descDate);
			comment: (row at: #descComment);
			default: ''.
		OvinaRegistration addRegistration: reg
		].
]