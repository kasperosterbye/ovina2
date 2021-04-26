Class {
	#name : #OvinaLabelledTextInput,
	#superclass : #OvinaLabelledContainer,
	#category : #'Ovina2-GUI General'
}

{ #category : #specs }
OvinaLabelledTextInput class >> defaultSpec [
	^ self labelLeft
]

{ #category : #generated }
OvinaLabelledTextInput >> acceptBlock: aBlockWithOneArgument [

	self
		deprecated: 'Use #whenSubmitDo: instead'
		transformWith:
		'`@rec acceptBlock: `@arg' -> '`@rec whenSubmitDo: `@arg'.
	^ self whenSubmitDo: aBlockWithOneArgument
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> beEncrypted [
	^ self input beEncrypted
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> encrypted: aBoolean [
	^self input encrypted: aBoolean
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> entryCompletion: anEntryCompletion [
	^self input entryCompletion: anEntryCompletion
]

{ #category : #initialization }
OvinaLabelledTextInput >> initializePresenters [
	super initializePresenters.
	self content: SpTextInputFieldPresenter.
]

{ #category : #accessing }
OvinaLabelledTextInput >> input [
	^ self subwidget
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> placeholder: aText [
	^ self input placeholder: aText
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> removeEntryCompletion [
	^self input removeEntryCompletion
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> selectAll [
	^self input selectAll
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> text [
	^self input text
]

{ #category : #'api-shortcuts' }
OvinaLabelledTextInput >> text: aText [
	self input text: aText
]

{ #category : #'api-events' }
OvinaLabelledTextInput >> whenSubmitDo: aBlock [

	self input whenSubmitDo: aBlock
]

{ #category : #'as yet unclassified' }
OvinaLabelledTextInput >> whenTextChanged: aBlock [

	self input whenTextChangedDo: aBlock
]

{ #category : #'api-events' }
OvinaLabelledTextInput >> whenTextIsAccepted: aBlock [

	self input whenTextIsAccepted: aBlock
]
