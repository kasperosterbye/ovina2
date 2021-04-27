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

{ #category : #'as yet unclassified' }
OvinaDB >> connectEventsToSheeps [
	"estblish the event history for each sheep"
]
