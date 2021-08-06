Class {
	#name : #OvinaModelEventRemoved,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'event'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaModelEventRemoved >> event [

	^ event
]

{ #category : #accessing }
OvinaModelEventRemoved >> event: anObject [

	event := anObject
]
