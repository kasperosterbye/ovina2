"
I am holding a few global methods to handle the Ovina model as a whole.
In particular initialize before loading a new model from database.

## Announcement
Any change to any model element is announced using my global announcer


"
Class {
	#name : #OvinaModel,
	#superclass : #Object,
	#classInstVars : [
		'announcer'
	],
	#category : #'Ovina2-Model'
}

{ #category : #accessing }
OvinaModel class >> announcer [
	announcer ifNil: [ announcer := Announcer new ].
	^ announcer
]

{ #category : #'as yet unclassified' }
OvinaModel class >> dkNumberFrom: aStringOrNil [
	aStringOrNil ifNil: [ ^0 ].
	aStringOrNil ifEmpty: [ ^0 ].
	^ (aStringOrNil copyReplaceAll: ',' with: '.' ) asNumber 

]

{ #category : #'class initialization' }
OvinaModel class >> initialize [
	"Remove all cached information in Ovina model"
	<script>
	OvinaSheep initialize.
	OvinaEvent initialize.
	OvinaRegistration initialize.
	announcer := nil.
]
