"
An OvinaDBTest is a test class for testing the behavior of OvinaDB
"
Class {
	#name : #OvinaDBTest,
	#superclass : #TestCase,
	#category : #'Ovina2-Tests'
}

{ #category : #tests }
OvinaDBTest >> testConnectToOldDB [
	
	|con|	
	con := OvinaDB openOld.
	self assert:  con tableNames notEmpty
]
