Class {
	#name : #OvinaApp,
	#superclass : #SpApplication,
	#classInstVars : [
		'ddd',
		'uuu'
	],
	#category : #'Ovina2-GUI General'
}

{ #category : #beep }
OvinaApp class >> beep [
	SoundSystem current beep
]

{ #category : #'ui requests' }
OvinaApp class >> confirm: question [

	^ SpConfirmDialog new
		  title: 'Bekræft';
		  label: question;
		  acceptLabel: 'Ja';
		  cancelLabel: 'nej';
		  openModalWithSpec
]

{ #category : #accessing }
OvinaApp class >> errorMessage: text [
	
	^ SpInformDialog new
		title: 'Fejl';
		label: text;
		acceptLabel: 'Luk';
		openModalWithSpec
]

{ #category : #registration }
OvinaApp class >> registerWithSessionManager [
	<script>
	SessionManager default registerUserClassNamed: self name
]

{ #category : #'system startup' }
OvinaApp class >> shutDown: dummy [
	"Close GUI"
	Ovina2DB currentClose.
	
]

{ #category : #'system startup' }
OvinaApp class >> startMe [

	"Use to set the image in production mode"

	<script>
	Ovina2DB currentClose.
	OvinaModel initialize.
	Ovina2DB loadAll.
	Ovina2DB currentOpen.
	self registerWithSessionManager.

	OvinaHistoryPresenter open.

	OvinaAllSheepsPresenter open
]

{ #category : #'system startup' }
OvinaApp class >> startUp: dummy [

	Ovina2DB currentOpen

]

{ #category : #registration }
OvinaApp class >> unregisterWithSessionManager [
	<script>
	SessionManager default unregisterClassNamed: self name
]
