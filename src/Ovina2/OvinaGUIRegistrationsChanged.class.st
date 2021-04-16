Class {
	#name : #OvinaGUIRegistrationsChanged,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'registration'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaGUIRegistrationsChanged >> registration [

	^ registration
]

{ #category : #accessing }
OvinaGUIRegistrationsChanged >> registration: anObject [

	registration := anObject
]
