Class {
	#name : #Ovina1DB,
	#superclass : #OvinaDB,
	#category : #'Ovina2-Database'
}

{ #category : #connecting }
Ovina1DB class >> dbPath [
	^ FileLocator imageDirectory parent parent pathString, '/ovina3a.db'
]

{ #category : #'as yet unclassified' }
Ovina1DB class >> kindReductionDictionary [

	^ Dictionary new
		  at: 'slagtevægt' put: 'slagtevægt';
		  at: 'flytning' put: 'flytning';
		  at: 'veje lam' put: 'vejning';
		  at: 'fødsel' put: 'fødsel';
		  at: '---' put: 'medicin';
		  at: 'vaccination' put: 'medicin';
		  at: 'medicin' put: 'medicin';
		  
		  at: 'noromectin' put: 'medicin';
		  at: 'ormekur' put: 'medicin';
		  at: 'vaccine' put: 'medicin';
		  at: 'flytte får' put: 'flytning';
		  at: 'ormemiddel' put: 'medicin';
		  at: 'yverbetændelse' put: 'syg';
		  at: 'coccidier' put: 'medicin';
		  at: 'alle lam' put: '---';
		  at: 'syg' put: 'syg';
		  at: 'vaccinere' put: 'medicin';
		  at: 'vaccinere ' put: 'medicin ';
		  at: 'vaccinere ogormekur' put: 'medicin';
		  yourself
]

{ #category : #'as yet unclassified' }
Ovina1DB >> eweRaceFromRow: row [
	| id |
	id := 'E', (row at: #eweID) asString.
	
	(#('E22' 'E23' 'E12' 'E4' 'E5' 'E7' 'E8' 'E20') includes: id) 
		ifTrue: [  ^(row at: #race) copyReplaceAll: 'st' with: '1Såne1Texel' ].
		
	(row at: #chr) asString = (OvinaSheep maarumlamChr) asString 
		ifTrue: [ ^nil ].
	
	^row at: #race 
]

{ #category : #'as yet unclassified' }
Ovina1DB >> loadAll [

	self
		loadRams;
		loadEwes;
		loadLambs;
		loadRegistrations;
		loadEvents 
]

{ #category : #migration }
Ovina1DB >> loadEvents [

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
			         date: (row at: #eventDate) parseISO8601  ;
			         result: (row at: #value).
		OvinaEvent addEvent: event ].
]

{ #category : #migration }
Ovina1DB >> loadEwes [
	| eweRows |
	eweRows := (self execute: 'select * from ewes') rows.
	eweRows do: [ :row | |ewe|
		ewe := OvinaEwe new
			id: 'E', (row at: #eweID) asString;
			chr: (row at: #chr) asString;
			number: (row at: #number) asString;
			name: (row at: #name);
			race: (self eweRaceFromRow: row) ;
			inDate: (row at: #inDate);
			outDate: ((row at: #outDate) ifNotNil: [:d | d parseISO8601]). "Oddly stored as text"
		OvinaSheep addSheep: ewe.
		].
]

{ #category : #migration }
Ovina1DB >> loadLambs [
	|  lambRows |
	lambRows := (self execute: 'select * from lambs') rows.
	lambRows do: [ :row | |lamb|
		lamb := OvinaLamb new
			id: 'L', (row at: #lambID) asString;
			chr: OvinaSheep maarumlamChr;
			number: (row at: #number) asString;
			dam: (OvinaSheep sheeps at: ('E', (row at: #momFK) asString));
			sire: (OvinaSheep sheeps at: ('R', (row at: #dadFK) asString));
			inDate: (row at: #inDate);
			event: (row at: #event);
			sex: (row at: #sex);
			growth: (row at: #growth);
			usage: (row at: #usage);
			color: (row at: #color);
			comment: (row at: #comment).
		OvinaSheep addSheep: lamb.
		].
]

{ #category : #migration }
Ovina1DB >> loadRams [
	| ramRows |
	ramRows := (self execute: 'select * from rams') rows.
	ramRows do: [ :row | |ram| 
		ram := OvinaRam new
			id: 'R', (row at: #ramID) asString;
			chr: (row at: #chr) asString;
			number: (row at: #number) asString;
			name: (row at: #name);
			race: (row at: #race ) asLowercase ;
			inDate: (row at: #inDate).
		OvinaSheep addSheep: ram.
		].
]

{ #category : #migration }
Ovina1DB >> loadRegistrations [

	| kinds regRow |
	kinds := self class kindReductionDictionary. 
	regRow := (self execute: 'select * from descriptors') rows.
	regRow do: [ :row | 
		| reg |
		reg := OvinaRegistration new
			       id: (row at: #descID) asString;
			       kind: (kinds at: (row at: #descTag) asLowercase);
			       date: (row at: #descDate) parseISO8601;
			       comment: (row at: #descComment);
			       default: ''.
		OvinaRegistration addRegistration: reg ]
]
