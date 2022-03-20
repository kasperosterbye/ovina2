Class {
	#name : #OvinaApp,
	#superclass : #SpApplication,
	#classInstVars : [
		'shaun'
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

{ #category : #'as yet unclassified' }
OvinaApp class >> ovinaMenu: aBuilder [
	<ovinaMenu>
	(aBuilder item: #Ovina)
		order: 500;
		help: 'Ovina menu';
		icon: (self shaun copy scaledToSize: 16@16);
		with: [
			(aBuilder item: #dataCheck)
				order: 10;
				label: 'Check data kvalitet';
				action: [ 1halt ].
			(aBuilder item: #openSheeps)
				order: 20;
				label: 'Åbn får og lam';
				action: [ 1halt ].
			(aBuilder item: #openHistory)
				order: 30;
				label: 'Åbn historik';
				action: [ 1halt ].
			(aBuilder item: #reload)
				order: 40;
				label: 'Genindlæs database';
				action: [ 1halt ].
			(aBuilder item: #saveAndQuitOvina)
				order: 1;
				label: 'Gem og luk';
				action: [ WorldState saveAndQuit ] ]
]

{ #category : #registration }
OvinaApp class >> registerWithSessionManager [
	<script>
	SessionManager default registerUserClassNamed: self name
]

{ #category : #accessing }
OvinaApp class >> shaun [
	shaun ifNil: [ shaun :=(ImageReadWriter formFromFileNamed: '../../Shaun.png') scaledToSize: 256@256].
	^shaun
]

{ #category : #'system startup' }
OvinaApp class >> shutDown: isImageQuitting [
	"false if image was merely saved"
	isImageQuitting 
		ifTrue: [Ovina2DB currentClose].
	
]

{ #category : #'system startup' }
OvinaApp class >> startMe [

	"Use to set the image in production mode"

	<script>
	(self currentWorld submorphs detect: [ :m |m class = ImageMorph ]) delete.
	self currentWorld addMorph: (self shaun asMorph position: 20@20).
	Ovina2DB currentClose.
	OvinaModel initialize.
	Ovina2DB loadAll.
	Ovina2DB currentOpen.
	self registerWithSessionManager.

	OvinaHistoryPresenter open.

	OvinaAllSheepsPresenter open
]

{ #category : #'system startup' }
OvinaApp class >> startUp: isImageStarting [
	"false if the image was just saved"
	isImageStarting ifTrue: [ Ovina2DB currentOpen ]

]

{ #category : #registration }
OvinaApp class >> unregisterWithSessionManager [
	<script>
	SessionManager default unregisterClassNamed: self name
]
