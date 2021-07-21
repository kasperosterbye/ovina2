"
I represent the removal of a registration.
I implicitly assume all the associated events to have been removed already. 

"
Class {
	#name : #OvinaModelRegistrationRemoved,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'registration'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaModelRegistrationRemoved >> registration [

	^ registration
]

{ #category : #accessing }
OvinaModelRegistrationRemoved >> registration: anObject [

	registration := anObject
]
