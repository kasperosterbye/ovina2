Class {
	#name : #OvinaEventChanged,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'event'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaEventChanged >> event [

	^ event
]

{ #category : #accessing }
OvinaEventChanged >> event: anObject [

	event := anObject
]
