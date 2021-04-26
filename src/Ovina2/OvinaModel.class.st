"
I am holding a few global methods to handle the Ovina model as a whole.
In particular initialize before loading a new model from database.


"
Class {
	#name : #OvinaModel,
	#superclass : #Object,
	#category : #'Ovina2-Model'
}

{ #category : #'as yet unclassified' }
OvinaModel class >> initialize [
	"Remove all cached information in Ovina"
	<script>
	OvinaSheep initialize.
	OvinaEvent initialize.
	OvinaRegistration initialize.
]
