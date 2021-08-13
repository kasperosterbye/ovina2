Class {
	#name : #OvinaTestCase,
	#superclass : #TestCase,
	#category : #'Ovina2-Tests-Model'
}

{ #category : #running }
OvinaTestCase >> setUp [
	super setUp.
	"Make sure we do not write to the database"
	Ovina2DB currentClose.
]
