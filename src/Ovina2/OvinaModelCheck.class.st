"
I am a consistency checker of the model. 

I produce a issue list of tag->issueText
"
Class {
	#name : #OvinaModelCheck,
	#superclass : #Object,
	#category : #'Ovina2-Model'
}

{ #category : #'as yet unclassified' }
OvinaModelCheck >> checkAllLiveLambsHasGenderMarked [
	| allNumbered wronglyMarked |
	allNumbered := OvinaLamb all select: [ :lamb | lamb number > 0 ].
	wronglyMarked := allNumbered reject: [ :lamb | #('gimmer' 'vædder') includes: lamb sex ].
	^ wronglyMarked collect: [ :lamb |
		'Lam {1} har ikke markeret køn' format: { lamb number asDKString }].
]

{ #category : #'as yet unclassified' }
OvinaModelCheck >> checkLambWeightloss [
	|issues|
	issues := OrderedCollection new.
	OvinaLamb all do: [ :lamb | |weights abnormal|
		weights := lamb events select: [ :ev |ev kind = 'vejning' and: [ ev result asDKNumber > 0 ] ].
		abnormal := weights slidingPairs select: [ :pair |
			pair first result asDKNumber < pair second result asDKNumber ].
		abnormal do: [ :pair | |desc|
			desc := 'lam {1} har tabt {2} kg mellem vejning {3} og {4}'
				format: { pair first sheep number asDKString. 
					(pair second result asDKNumber - pair first result asDKNumber) asDKString.
					pair second date asDKString. 
					pair first date asDKString  }.
			issues add: desc
			 ]
		 ].
	^issues 
	
]

{ #category : #'as yet unclassified' }
OvinaModelCheck >> checkLambsBornOnSameDay [
	"check that siblings are born on the same day"
	|issues|
	issues := OrderedCollection new.
	OvinaEwe all do: [ :ewe | | births |
		births := ewe lambs groupedBy: [ :lamb | lamb inDate ].
		births size = (births keys collect: [:date | date year]) asSet size
			ifFalse: [ |desc|
				desc := '{1} ({2}) har lam med forskellige fødselsdato samme år'
					format: { ewe name. ewe number asDKString}.
				issues add: desc
				]
		 ].
	^ issues
]

{ #category : #'as yet unclassified' }
OvinaModelCheck >> checkSlaughterWeightsRegistered [
	"check that all slaughtered lambs have a weight registration"
	| slaughtered unregistered|
	slaughtered := OvinaLamb all select: [ :lamb | lamb slaughterAge > 0 ].
	unregistered := slaughtered select: [ :lamb | lamb slaughterWeight = 0 ].
	^ unregistered collect: [ :lamb | |slaughterDate |
		slaughterDate := (lamb events detect: [ :e | e kind = 'slagtevægt' ]) date.
		'Lam {1} som blev slagtet {2} har ikke slagtevægten registreret'
			format: { lamb number asDKString . slaughterDate asDKString  } ]
	
	
]

{ #category : #'as yet unclassified' }
OvinaModelCheck >> checkThatNumberZeroLambsAreMarkedAsDead [
	| zeroLambs |
	zeroLambs := OvinaLamb all select: [ :lamb | lamb number = 0 ].
	^ (zeroLambs reject: [:lamb | lamb usage = 'død'])
		collect: [ :lamb |
			'{1}`s lam født {2} døde, men er markeret som {3}'
				format: { lamb dam name. lamb inDate asDKString. lamb usage }]
]

{ #category : #'as yet unclassified' }
OvinaModelCheck >> checkUsageSlaugther [
	"check that all slaughtered lambs are marked with usage=slagt"
	| slaughtered |
	slaughtered := OvinaLamb all select: [ :lamb | lamb slaughterAge > 0 ].
	^ (slaughtered reject: [ :lamb | #('flaske' 'slagt') includes: lamb usage])
		collect: [ :lamb | 
			'Lam nummer {1} er slagtet, men dets anvendelse er sat som {2}.'
				format: { lamb number asDKString. lamb usage  }]
	
]

{ #category : #'as yet unclassified' }
OvinaModelCheck >> checkWeightningsSensible [
	| weightnings strange |
	weightnings := OvinaEvent events values select: [ :ev | ev kind = 'vejning' ].
	weightnings := weightnings reject: [ :w | w result asDKNumber = 0 ].
	strange := weightnings reject:  [ :w | |minWeight|
		minWeight := w date year <= 2017 ifTrue: [ 10 ] ifFalse: [ 30 ].
		w result asDKNumber between: minWeight and: 60 ].
	strange := strange sorted: [ :a :b | a date > b date ].
	^ strange collect: [:w | 
		'Vejning den {1} af lam {2} har værdi: {3}' 
			format: { w date asDKString. w sheep number asDKString. w result }]
]
