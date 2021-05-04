Class {
	#name : #OvinaSheepChanged,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'sheep'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaSheepChanged >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaSheepChanged >> sheep: anObject [

	sheep := anObject
]
