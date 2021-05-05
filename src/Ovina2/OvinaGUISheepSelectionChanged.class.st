Class {
	#name : #OvinaGUISheepSelectionChanged,
	#superclass : #OvinaAnnouncement,
	#instVars : [
		'sheep'
	],
	#category : #'Ovina2-Announcements'
}

{ #category : #accessing }
OvinaGUISheepSelectionChanged >> sheep [

	^ sheep
]

{ #category : #accessing }
OvinaGUISheepSelectionChanged >> sheep: anObject [

	sheep := anObject
]
