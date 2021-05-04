Class {
	#name : #OvinaApp,
	#superclass : #SpApplication,
	#classInstVars : [
		'ddd',
		'uuu'
	],
	#category : #'Ovina2-GUI General'
}

{ #category : #'instance creation' }
OvinaApp class >> open [
	self todo
]

{ #category : #'system startup' }
OvinaApp class >> shutDown: dummy [
	"Close GUI"
	Ovina2DB currentClose.
	
]

{ #category : #'system startup' }
OvinaApp class >> startUp: dummy [
	"OvinaModel initialize."
	"Ovina2DB loadAll.
	Ovina2DB currentOpen."
	"Start GUI"
	
]
