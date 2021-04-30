Class {
	#name : #OvinaLamb,
	#superclass : #OvinaSheep,
	#category : #'Ovina2-Model'
}

{ #category : #'accessing - properties' }
OvinaLamb >> color [

	^ (self property: #color)
]

{ #category : #'accessing - properties' }
OvinaLamb >> color: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #color put: val
]

{ #category : #'accessing - properties' }
OvinaLamb >> comment [
	<sheepColumn: #('kommentar' comment:)>
	^ (self property: #comment)
]

{ #category : #'accessing - properties' }
OvinaLamb >> comment: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #comment put: val
]

{ #category : #'accessing - properties' }
OvinaLamb >> dam [

	^ OvinaSheep sheep: (self property: #dam)
]

{ #category : #'accessing - properties' }
OvinaLamb >> dam: dam [

	self property: #dam put: dam id
]

{ #category : #'accessing - properties' }
OvinaLamb >> damName [
	<sheepColumn: #('mor')>
	^ self dam name
]

{ #category : #'as yet unclassified' }
OvinaLamb >> defaultPropertyOrder [
	^#(inDate event sex color comment usage outDate dam sire )
]

{ #category : #'accessing - properties' }
OvinaLamb >> event [

	^ (self property: #event)
]

{ #category : #'accessing - properties' }
OvinaLamb >> event: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #event put: val
]

{ #category : #'accessing - properties' }
OvinaLamb >> growth [

	^ (self property: #growth)
]

{ #category : #'accessing - properties' }
OvinaLamb >> growth: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #growth put: val
]

{ #category : #'accessing - properties' }
OvinaLamb >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	^ self sex capitalized ,'lam'
]

{ #category : #accessing }
OvinaLamb >> name [
	"self number asString, ' ', self sex first asUppercase asString , ' ',self dam name."
	
	^ self dam name, ' ', self sex first asUppercase asString , ' ',self number asString.
]

{ #category : #'accessing - properties' }
OvinaLamb >> outDate [
	| d |
	d := super outDate.
	^d
	
]

{ #category : #rendering }
OvinaLamb >> present [
	"return true if the lamb is still alive. Last years lambs picked for breeding are alive only as ewes"
	self inDate year = Date today year ifFalse: [ ^false ].
	self slaughterWeight ifNil: [ ^false ].
	^true
]

{ #category : #printing }
OvinaLamb >> printOn: aStream [
	aStream nextPutAll: 'Lamb '.
	super printOn: aStream
]

{ #category : #'accessing - properties' }
OvinaLamb >> raceCompute [
	^ self dam race + self sire race
]

{ #category : #'accessing - properties' }
OvinaLamb >> sex [

	^ (self property: #sex)
]

{ #category : #'accessing - properties' }
OvinaLamb >> sex: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #sex put: val
]

{ #category : #'accessing - properties' }
OvinaLamb >> sire [
	^ OvinaSheep sheep: (self property: #sire)
]

{ #category : #'accessing - properties' }
OvinaLamb >> sire: ram [
	self property: #sire put: ram id
]

{ #category : #'accessing - properties' }
OvinaLamb >> sireName [
	<sheepColumn: #('far')>
	^ self sire name
]

{ #category : #'accessing - properties' }
OvinaLamb >> slagtevægt [
	"return -1 if not slaughtered"
	|slagt|
	self usage ~= 'slagt' ifTrue: [ ^ -1 ].
	slagt := self events select: [ :ev | ev registration kind = 'slagtevægt' ].
	^ slagt ifEmpty: [ -1 ] 
		ifNotEmpty: [ |res| 
			res:= slagt last result.
			res ifEmpty: [ -1 ] 
				ifNotEmpty: [ res asNumber ] ]
]

{ #category : #accessing }
OvinaLamb >> usage [
	<sheepColumn: #('brug' usage:)>
	^ self property: #usage
]

{ #category : #accessing }
OvinaLamb >> usage: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #usage put: val. 
]
