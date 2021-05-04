Class {
	#name : #OvinaRegistrationChanged,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'registration'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaRegistrationChanged >> registration [

	^ registration
]

{ #category : #accessing }
OvinaRegistrationChanged >> registration: anObject [

	registration := anObject
]
