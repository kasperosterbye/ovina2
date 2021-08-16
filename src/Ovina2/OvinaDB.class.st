Class {
	#name : #OvinaDB,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'Ovina2-Database'
}

{ #category : #connecting }
OvinaDB class >> dbPath [
	"return the filepath to a database"
	self subclassResponsibility 
]

{ #category : #migration }
OvinaDB class >> loadAll [

	| ovinaDB |
	OvinaModel initialize.
	ovinaDB := self open.
	ovinaDB loadAll.
	ovinaDB close
]

{ #category : #connecting }
OvinaDB class >> open [
	"return a connection object for the database"
	|path| 
	path := self dbPath.
	path asFileReference exists ifFalse: [ OvinaError signal: 'database ',path, ' not found' ].
	^self new openOn: path
	
]

{ #category : #'initialize-release' }
OvinaDB >> close [
	connection close
]

{ #category : #execution }
OvinaDB >> execute: anSQLText [

	"I add a simple exception handling for OvinaDB - in particular I am trying
	to catch errors occuring from not closing and reopening a database between 
	Pharo image save and start"

	[ ^ connection execute: anSQLText ]
		on: SQLite3Misuse
		do: [ :err | 
			connection close.
			self openOn: self class dbPath.
			^ connection execute: anSQLText ]
]

{ #category : #'instance creation' }
OvinaDB >> openOn: aPath [
	connection := SQLite3Connection openOn: aPath.
	^ self
]
