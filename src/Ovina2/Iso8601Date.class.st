Class {
	#name : #Iso8601Date,
	#superclass : #Date,
	#category : #'Ovina2-Model'
}

{ #category : #printing }
Iso8601Date >> printOn: aStream [
	self printOn: aStream format: #(3 2 1 $- 1 1 2)
]
