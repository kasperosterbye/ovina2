Class {
	#name : #OvinaModelEventChanged,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'event'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaModelEventChanged >> event [

	^ event
]

{ #category : #accessing }
OvinaModelEventChanged >> event: anObject [

	event := anObject
]
