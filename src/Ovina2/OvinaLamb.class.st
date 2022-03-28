Class {
	#name : #OvinaLamb,
	#superclass : #OvinaSheep,
	#category : #'Ovina2-Model'
}

{ #category : #accessing }
OvinaLamb class >> all [
	^ self lambs values
]

{ #category : #accessing }
OvinaLamb >> canPromoteToEwe [
	"Check the conditions for promotions is in place"
	
	OvinaSheep ewes values 
		detect:  [ :ewe | ewe number = self number]
		ifFound: [ :ewe | 
			OvinaApp errorMessage: ('Lam ', self number asString, ' er allerede får og hedder ', ewe name). 
			^false ].
		
	self usage = 'avl' ifFalse: 
		[ OvinaApp errorMessage: 'Kun lam udvalgt til avl kan blive får'. 
		^false ].
	^ true
]

{ #category : #'accessing - properties' }
OvinaLamb >> color [
	<sheepColumn:#('Farve' color: #('hvid' 'sort' 'andet'))>
	^ (self property: #color) ifNil: [ '' ]
]

{ #category : #'accessing - properties' }
OvinaLamb >> color: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #color put: val
]

{ #category : #'accessing - properties' }
OvinaLamb >> comment [
	<sheepColumn: #('kommentar' comment:)>
	^ (self property: #comment) ifNil: [ '' ]
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

{ #category : #'accessing - properties' }
OvinaLamb >> defaultPropertyOrder [
	^#(inDate event sex color comment usage outDate dam sire )
]

{ #category : #'accessing - properties' }
OvinaLamb >> event [
	<sheepColumn: #('Fødsel' event: ('let' 'vanskelig') )>
	^ (self property: #event) ifNil: [ '' ]
]

{ #category : #'accessing - properties' }
OvinaLamb >> event: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #event put: val
]

{ #category : #columns }
OvinaLamb >> finalWeight [
	"Estimated live weight in kg on the day it was slaughtered, -1 if not slaughtered"
	<sheepColumn: #('slutvægt')>
	^ self cache: #finalWeight compute: [ self finalWeightCompute  ]
]

{ #category : #'as yet unclassified' }
OvinaLamb >> finalWeightCompute [
	"throw away weights which are zero, 
	or where the lamb has lost or gained more than X percent of growth rathe"
	| weightings latest second deltaDay deltaWeight growthPerDay delta2Days |
	self slaughterAge > 0 ifFalse: [ ^ -1 ].
	weightings := (self events 
		select: [ :e| e kind = 'vejning' ]
		thenCollect: [ :e | e date -> e result asDKNumber ]) asOrderedCollection.
	weightings ifEmpty: [ ^-1 ].
	weightings addLast: (self inDate -> 5). 
	weightings := weightings reject: [ :w | w value = 0 ].
	latest := weightings first.
	second := weightings detect: [ :weighting | weighting value < latest  value].
	deltaDay := (latest key - second key) days.
	deltaWeight := (latest value - second value).
	growthPerDay := deltaWeight / deltaDay.
	delta2Days := self slaughterAge - (latest key - self inDate) days.
	^ (latest value + (delta2Days * growthPerDay)) rounded
]

{ #category : #columns }
OvinaLamb >> gramPerDay [
	"return gram per day based on weight measurements"
	<sheepColumn: #('gram/dag')>
	^self cache: #gramPerDay compute: [ self gramPerDayCompute  ] 
	
	
	
	
]

{ #category : #columns }
OvinaLamb >> gramPerDayCompute [
	"return gram per day based on weight measurements"
	| weightnings lastWeight firstWeight lastDate firstDate deltaDay|
	weightnings := self events select: [ :ev | ev kind = 'vejning' ].
	"Some old lambs do not have events, but might store growth in a property"
	weightnings := weightnings reject: [ :w | w result asDKNumber = 0 ].
	weightnings ifEmpty: [ ^ self growthProperty  ].
	firstWeight := 5.0.
	firstDate := self inDate.
	lastDate := weightnings first date.
	lastWeight := weightnings first result asDKNumber.
	deltaDay := (lastDate - firstDate ) days.
	^ ((lastWeight - firstWeight) * 1000 / deltaDay ) asFloat.
	
	
	
	
]

{ #category : #'accessing - properties' }
OvinaLamb >> growth [

	^ (self property: #growth)  
]

{ #category : #'accessing - properties' }
OvinaLamb >> growth: aStringOrInteger [
	aStringOrInteger ifNil: [ ^self ].
	aStringOrInteger isString 
		ifTrue: [ self property: #growth put: aStringOrInteger asDKNumber  ]
	  	ifFalse: [ self property: #growth put: aStringOrInteger ]
	
]

{ #category : #'accessing - properties' }
OvinaLamb >> growthProperty [
	"read growth property, or return -1"
	| growth |
	growth := ((self property: #growth) ifNil: [ '0' ] ) asDKNumber.
	^ growth > 0 
		ifTrue: [ growth ] 
		ifFalse: [ -1 ]
	
]

{ #category : #caching }
OvinaLamb >> invalidateCache [ 
	super invalidateCache.
	self dam ifNotNil: [ :d | d invalidateCache].
	self sire ifNotNil: [ :s | s invalidateCache].
]

{ #category : #testing }
OvinaLamb >> isLamb [
	^true
]

{ #category : #'accessing - properties' }
OvinaLamb >> kind [
	"return the kind of sheep - Får, Gimmer, Vædderlam, Vædder"
	^ self sex ifNotNil: [self sex ,'lam'] ifNil: 'lam'
]

{ #category : #columns }
OvinaLamb >> meatPercent [
	<sheepColumn: #('slagte%')>
	^ self 
		cache: #meatPercent 
		compute: [ self meatPercentCompute  ]
]

{ #category : #columns }
OvinaLamb >> meatPercentCompute [
	"return the ratio (in %) of meat to final weight, -1 if not slaughtered"
	self slaughterWeight = -1 ifTrue: [ -1 ].
	^ (self slaughterWeight / self finalWeight) * 100
	
]

{ #category : #accessing }
OvinaLamb >> name [
	"self number asString, ' ', self sex first asUppercase asString , ' ',self dam name."
	
	^ self dam name, ' ', self sex first asUppercase asString , ' ',self number asString.
]

{ #category : #rendering }
OvinaLamb >> present [
	"return true if the lamb is still alive. Last years lambs picked for breeding are alive only as ewes"
	self number = 0 ifTrue: [ ^ false ].
	self inDate year = Date today year ifFalse: [ ^false ].
	^self slaughterWeight < 0
]

{ #category : #printing }
OvinaLamb >> printOn: aStream [
	aStream nextPutAll: 'Lamb '.
	super printOn: aStream
]

{ #category : #accessing }
OvinaLamb >> promoteToEwe [
	|nextEweId newEwe|
	self canPromoteToEwe ifFalse: [ ^nil ].
	
	nextEweId := (OvinaSheep ewes keys collect: [ :key | key extractNumber ]) max +1.
	newEwe := OvinaEwe new
		id: 'E', nextEweId asString;
		chr: self chr;
		number: self number;
		inDate: self inDate;
		name: ' Unavngivet '.
	OvinaSheep addSheep: newEwe.
	OvinaModel announcer announce: (OvinaModelSheepChanged new sheep: newEwe ).
	^ newEwe 	
]

{ #category : #'accessing - properties' }
OvinaLamb >> raceCompute [
	^ self dam race + self sire race
]

{ #category : #removing }
OvinaLamb >> remove [
	"remove this lamb from the model, and in the database"
	OvinaSheep sheeps removeKey: self id.
	OvinaModel announcer announce: (OvinaModelSheepRemoved new sheep: self).
	self invalidateCache.
	
]

{ #category : #'accessing - properties' }
OvinaLamb >> sex [
	<sheepColumn:#('køn' sex: ('gimmer' 'vædder'))>
	^ (self property: #sex) ifNil: [ 'X' ]
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

{ #category : #columns }
OvinaLamb >> slaughterAge [
	"return the age of the lamb when it was slaughtered (in days)"
	<sheepColumn: #('slagtealder')>
	^ self cache: #slaughterAge compute: [ self slaughterAgeCompute  ]
]

{ #category : #columns }
OvinaLamb >> slaughterAgeCompute [
	"return the age of the lamb when it was slaughtered (in days)"
	| slaughtered | 
	slaughtered := self events detect: [ :ev | ev kind = 'slagtevægt' ] ifNone: [ ^ -1 ].
	^ (slaughtered date - self inDate ) days
]

{ #category : #'accessing - properties' }
OvinaLamb >> sortingScore [
	^ (number+1) + self dam sortingScore 
]

{ #category : #accessing }
OvinaLamb >> usage [
	<sheepColumn: #('brug' usage: ('avl' 'slagt' 'flaske' 'død'))>
	^ self property: #usage
]

{ #category : #accessing }
OvinaLamb >> usage: val [
	(val isNil or: [ val isEmpty ]) ifTrue: [ ^self ].
	self property: #usage put: val. 
]
