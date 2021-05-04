Class {
	#name : #OvinaDB,
	#superclass : #SQLite3Connection,
	#category : #'Ovina2-Database'
}

{ #category : #migration }
OvinaDB class >> loadAll [

	| conn |
	OvinaModel initialize.
	conn := self open.
	conn loadAll.
	conn close
]

{ #category : #connecting }
OvinaDB class >> open [
	"return a connection object for the database"
	|path| 
	path := self dbPath.
	path asFileReference exists ifFalse: [ OvinaError signal: 'database ',path, ' not found' ].
	^self openOn: path
	
]

{ #category : #'as yet unclassified' }
OvinaDB >> connectEventsToSheeps [
	"estblish the event history for each sheep"
]
