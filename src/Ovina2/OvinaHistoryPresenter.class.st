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
	#category : #'Ovina2-GUI History'
}

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
	self new openWithSpec 
]

{ #category : #initialization }
OvinaHistoryPresenter >> connectPresenters [ 
	
	registrations announcer when: OvinaGUIRegistrationsChanged do: [ self registrationChanged   ].
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
		initialExtent: 1200 @ 950 
]

{ #category : #'as yet unclassified' }
OvinaHistoryPresenter >> registrationChanged [
	"callback from registrations"
	events registration: registrations selectedRegistration.
	selections selected: (events events collect: #sheep)
	
]

{ #category : #'as yet unclassified' }
OvinaHistoryPresenter >> selectedSheeps [
	^ selections selectedSheeps 
]

{ #category : #'as yet unclassified' }
OvinaHistoryPresenter >> sheepsChanged [ 
	"callback from sheep selection"
	
]
