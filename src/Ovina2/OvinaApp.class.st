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

{ #category : #'as yet unclassified' }
OvinaApp class >> ensureShaunmorph [
	|shaunMorph|
	self currentWorld submorphs 
		detect: [ :m |m class = ImageMorph ]
		ifFound: [ :m | m delete].
	shaunMorph := self shaun asMorph position: 20@20.
	shaunMorph assureExtension locked: true.
	self currentWorld addMorphBack: (shaunMorph).
]

{ #category : #accessing }
OvinaApp class >> errorMessage: text [
	
	^ SpInformDialog new
		title: 'Fejl';
		label: text;
		acceptLabel: 'Luk';
		openModalWithSpec
]

{ #category : #accessing }
OvinaApp class >> message: text [
	
	^ SpInformDialog new
		title: 'Besked';
		label: text;
		acceptLabel: 'Luk';
		openModalWithSpec
]

{ #category : #'as yet unclassified' }
OvinaApp class >> ovinaMenu: aBuilder [
	<ovinaMenu>
	"WorldState desktopMenuPragmaKeyword: #'ovinaMenu'.
	MenubarMorph initialize."
	(aBuilder item: #Ovina)
		order: 500;
		help: 'Ovina menu';
		icon: (self shaun copy scaledToSize: 16@16);
		with: [
			(aBuilder item: #dataCheck)
				order: 10;
				label: 'Check data kvalitet';
				action: [ :e | OvinaModelcheckPresenter reOpen ].
			(aBuilder item: #openSheeps)
				order: 20;
				label: 'Åbn får og lam';
				action: [ OvinaAllSheepsPresenter reOpen ].
			(aBuilder item: #openHistory)
				order: 30;
				label: 'Åbn historik';
				action: [ OvinaHistoryPresenter reOpen ].
			(aBuilder item: #reload)
				order: 40;
				label: 'Genindlæs database';
				action: [ self restartMe ].
			(aBuilder item: #saveAndQuitOvina)
				order: 50;
				label: 'Gem og luk';
				action: [ WorldState saveAndQuit ] ]
]

{ #category : #registration }
OvinaApp class >> registerWithSessionManager [
	<script>
	SessionManager default registerUserClassNamed: self name
]

{ #category : #'system startup' }
OvinaApp class >> restartMe [
	<script>
	OvinaAllSheepsPresenter close.
	OvinaHistoryPresenter close.
	Ovina2DB currentClose.
	Ovina2DB loadAll.
	Ovina2DB currentOpen.
	OvinaAllSheepsPresenter open.
	OvinaHistoryPresenter open.
	self registerWithSessionManager.

]

{ #category : #accessing }
OvinaApp class >> shaun [
	shaun ifNil: [ shaun :=(ImageReadWriter formFromFileNamed: '../../Shaun.png') scaledToSize: 256@256].
	^shaun
]

{ #category : #'system startup' }
OvinaApp class >> shutDown: isImageQuitting [

	isImageQuitting ifFalse: [ ^ self ].
	OvinaAllSheepsPresenter close.
	OvinaHistoryPresenter close.
	Ovina2DB currentClose
]

{ #category : #'system startup' }
OvinaApp class >> startMe [
	"Use to set the image in production mode"

	<script>
	self ensureShaunmorph.
	WorldState desktopMenuPragmaKeyword: #'ovinaMenu'.
	MenubarMorph initialize.
	OvinaModel initialize.
	Ovina2DB loadAll.
	Ovina2DB currentOpen.
	OvinaAllSheepsPresenter reOpen.
	OvinaHistoryPresenter reOpen.
	self registerWithSessionManager.

]

{ #category : #'system startup' }
OvinaApp class >> startUp: isImageStarting [
	"false if the image was just saved"
	isImageStarting ifFalse: [ ^self ].
	OvinaModel initialize.
	Ovina2DB loadAll.
	Ovina2DB currentOpen

]

{ #category : #registration }
OvinaApp class >> unregisterWithSessionManager [
	<script>
	SessionManager default unregisterClassNamed: self name
]
