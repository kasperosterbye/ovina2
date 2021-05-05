Class {
	#name : #OvinaModelRegistrationChanged,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'registration'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaModelRegistrationChanged >> registration [

	^ registration
]

{ #category : #accessing }
OvinaModelRegistrationChanged >> registration: anObject [

	registration := anObject
]
