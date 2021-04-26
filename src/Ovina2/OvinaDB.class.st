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

{ #category : #initialization }
OvinaDB >> setOutDatesFromHistory [
	self todo.
]

{ #category : #initialization }
OvinaDB >> setSheepPropertiesFromHistory [
	self setOutDatesFromHistory
]
