"
I am the toplevel presenter for managing the history of events.
I have three sup-presenters 
* Selecting sheeps for a registration `OvinaHistSheepSelection`
* table of registrations `OvinaHistRegistrations`
* table of events `OvinaHistEvents`
"
Class {
	#name : #OvinaHistoryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'selections',
		'registrations',
		'events'
	],
	#classVars : [
		'HistoryPresenterInstance'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #specs }
OvinaHistoryPresenter class >> close [
	HistoryPresenterInstance 
		ifNotNil: [ :inst |
			inst window close.
			HistoryPresenterInstance := nil.
			 ]
]

{ #category : #specs }
OvinaHistoryPresenter class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		addFirst: #selections;
		addSecond: (SpPanedLayout newVertical
			addFirst: #registrations; 
			addSecond: #events)
]

{ #category : #specs }
OvinaHistoryPresenter class >> open [
	<example>
	HistoryPresenterInstance
		ifNil: [
			HistoryPresenterInstance := self new.
			HistoryPresenterInstance openWithSpec ] 
]

{ #category : #specs }
OvinaHistoryPresenter class >> reOpen [
	self close.
	self open
]

{ #category : #initialization }
OvinaHistoryPresenter >> connectPresenters [ 
	
	registrations announcer 
		when: OvinaGUIRegistrationsChanged 
		do: [ self registrationChanged   ].
	selections announcer 
		when: OvinaGUIHistSelectorAdded 
		do: [:add | events sheepAdded: add sheep].
	selections announcer 
		when: OvinaGUIHistSelectorRemoved 
		do: [ :rem | events sheepRemoved: rem sheep ].
	events registration:  registrations selectedRegistration . 
]

{ #category : #initialization }
OvinaHistoryPresenter >> initializePresenters [
	 
	super initializePresenters.
	registrations := self instantiate: OvinaHistRegistrations.
	events := self instantiate: OvinaHistEvents.
	selections := self instantiate: OvinaHistSheepSelection.
	
	

	
]

{ #category : #initialization }
OvinaHistoryPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Historik';
		initialExtent: 1200 @ 950;
		whenClosedDo: [ 
			HistoryPresenterInstance := nil.
			self removeAnnouncements ]
]

{ #category : #events }
OvinaHistoryPresenter >> registrationChanged [
	"callback from registrations"
	events registration: registrations selectedRegistration.
	selections selected: (events events collect: #sheep)
	
]

{ #category : #removing }
OvinaHistoryPresenter >> removeAnnouncements [
	{ registrations. selections. events  } do: [ :presenter |
		presenter announcer unsubscribe: self]
]

{ #category : #events }
OvinaHistoryPresenter >> selectedSheeps [
	^ selections selectedSheeps 
]

{ #category : #events }
OvinaHistoryPresenter >> sheepsChanged [ 
	"callback from sheep selection"
	
]
