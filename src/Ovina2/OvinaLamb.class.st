Class {
	#name : #OvinaLamb,
	#superclass : #OvinaSheep,
	#category : #Ovina2
}

{ #category : #accessing }
OvinaLamb >> usage [
	^ self class get: #usage for: self.
]

{ #category : #accessing }
OvinaLamb >> usage: value [
	self property: #usage put: value. 
]
