Class {
	#name : #OvinaModelcheckPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'checks',
		'description',
		'checker'
	],
	#classVars : [
		'HistoryPresenterInstance',
		'ModelcheckPresenter'
	],
	#category : #'Ovina2-GUI General'
}

{ #category : #specs }
OvinaModelcheckPresenter class >> close [
	ModelcheckPresenter  
		ifNotNil: [ :inst |
			inst window close.
			ModelcheckPresenter := nil.
			 ]
]

{ #category : #specs }
OvinaModelcheckPresenter class >> defaultSpec [

	^ self error: 'should not be called by spec as I set layout in initializePresenters'
]

{ #category : #specs }
OvinaModelcheckPresenter class >> open [
	<example>
	ModelcheckPresenter 
		ifNil: [
			ModelcheckPresenter := self new.
			ModelcheckPresenter openWithSpec ] 
]

{ #category : #specs }
OvinaModelcheckPresenter class >> reOpen [
	self close.
	self open
]

{ #category : #initialization }
OvinaModelcheckPresenter >> initializePresenters [
	checker := OvinaModelCheck new.
	checks := { 
		self newRadioButton
			label: 'Fødselsdage';
			whenActivatedDo: [ self show: checker checkLambsBornOnSameDay ].
		self newRadioButton
			label: 'Vægttab';
			whenActivatedDo: [ self show: checker checkLambWeightloss ].
		self newRadioButton
			label: 'Abnorm vægt';
			whenActivatedDo: [ self show: checker checkWeightningsSensible ].
		self newRadioButton
			label: 'Døde';
			whenActivatedDo: [ self show: checker checkThatNumberZeroLambsAreMarkedAsDead ].
		self newRadioButton
			label: 'Slagtede';
			whenActivatedDo: [ self show: checker checkUsageSlaugther ].
		self newRadioButton
			label: 'Kønsforvirring';
			whenActivatedDo: [ self show: checker checkAllLiveLambsHasGenderMarked ].
	}.
	checks first associatedRadioButtons: (checks copyFrom: 2 to: checks size).
	description := self newText.
	self show: checker checkLambsBornOnSameDay.
	self setLayout.
]

{ #category : #initialization }
OvinaModelcheckPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Data check';
		initialExtent: 800 @ 600;
		whenClosedDo: [ ModelcheckPresenter := nil ]
]

{ #category : #initialization }
OvinaModelcheckPresenter >> setLayout [
	|checkLayout|
	checkLayout := SpBoxLayout newTopToBottom.
	checks do: [ :check | checkLayout add: check expand: false ].
	self layout: (SpBoxLayout newLeftToRight
		add: checkLayout expand: false;
		add: description;
		yourself
	) 
		
	
	
]

{ #category : #showing }
OvinaModelcheckPresenter >> show: issueList [
	description text: (issueList joinUsing: String cr)
]
