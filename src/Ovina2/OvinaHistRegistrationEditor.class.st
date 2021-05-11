Class {
	#name : #OvinaHistRegistrationEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'kindExisting',
		'kindNew',
		'date',
		'comment',
		'default'
	],
	#category : #'Ovina2-GUI History'
}

{ #category : #specs }
OvinaHistRegistrationEditor class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal 
			add: (SpBoxLayout newVertical 
				add: (SpLabelPresenter new label: 'Type') expand: false fill: true padding: 1;
				add: #kindExisting expand: false fill: true padding: 1 ; 
				add: #kindNew )
			expand: true fill: true padding: 2;
			add: (SpBoxLayout newVertical 
					add: (SpLabelPresenter new label: 'Dato') expand: false fill: true padding: 1;
					add: #date expand: false fill: true padding: 3; 
					add: #default )
				expand: true fill: true padding: 2)
			height: 92; 
		add: (SpBoxLayout newVertical
			add: (SpLabelPresenter new label: 'Kommentar') expand: false fill: nil padding: 1;
			add: #comment expand: true fill: true padding: 1)
		expand: true fill: true padding: 1;
		yourself
]

{ #category : #description }
OvinaHistRegistrationEditor >> comment [
	^ comment text asString
]

{ #category : #accessing }
OvinaHistRegistrationEditor >> comment: aStringOrText [

	comment text: aStringOrText asString
]

{ #category : #description }
OvinaHistRegistrationEditor >> date [
	^ date text 
]

{ #category : #accessing }
OvinaHistRegistrationEditor >> date: string [

	date text: string
]

{ #category : #description }
OvinaHistRegistrationEditor >> default [
	^ default text asString
]

{ #category : #accessing }
OvinaHistRegistrationEditor >> default: aStringOrText [

	default text: aStringOrText asString
]

{ #category : #'as yet unclassified' }
OvinaHistRegistrationEditor >> initializePresenters [
	"actionBar kindExisting kindNew date comment default"
	kindExisting := (self instantiate: SpDropListPresenter )
		items: OvinaRegistration  kinds, #('-- ny --').
	kindNew := (self instantiate: OvinaLabelledTextInput )
		layout: OvinaLabelledContainer labelTop;
		label: 'Ny type'.
	date := self newTextInput 
		text: (Date today printString).
	default := (self instantiate: OvinaLabelledTextInput )
		layout: OvinaLabelledContainer labelTop;
		label: 'Default værdi'.
	comment := (self instantiate: SpTextPresenter )
]

{ #category : #initialization }
OvinaHistRegistrationEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Ny registrering';
		initialExtent: 350@260
]

{ #category : #description }
OvinaHistRegistrationEditor >> kind [
	"return the result from kindExisting, or if '-- ny --', the input from the kindNew"
	kindExisting selectedItem = '-- ny --'
		ifTrue: [ ^ kindNew text asString ].
	^ kindExisting selectedItem asString
]

{ #category : #accessing }
OvinaHistRegistrationEditor >> kindExisting [

	^ kindExisting asString
]

{ #category : #accessing }
OvinaHistRegistrationEditor >> kindExisting: item [

	kindExisting selectItem: item
]
