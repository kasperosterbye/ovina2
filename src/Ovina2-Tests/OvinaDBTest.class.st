"
An OvinaDBTest is a test class for testing the behavior of OvinaDB
"
Class {
	#name : #OvinaDBTest,
	#superclass : #TestCase,
	#category : #'Ovina2-Tests-Database'
}

{ #category : #tests }
OvinaDBTest >> testConnectToOldDB [
	
	|con|	
	con := Ovina2DB open.
	self assert: con isOpen
]
