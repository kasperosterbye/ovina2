Extension { #name : #Date }

{ #category : #'*Ovina2' }
Date >> asDKDateString [
 	"Format the date in ISO 8601 standard like '2002-10-22'
	The result is of fixed size 10 characters long.."
 	"(Date year: 2018 month: 9 day: 28) ovinaDate >>> '28.09.2018'"
	
 	^ String new: 10 streamContents: [ :aStream |
		self printOn: aStream format: #(1 2 3 $. 1 1 2) ]
	
	
]

{ #category : #'*Ovina2' }
Date >> ovinaDBString [ 
	^ self yyyymmdd printString
]

{ #category : #'*Ovina2' }
Date >> printOn: aStream [
 	"Change default date print to Danish"
 	self printOn: aStream format: #(1 2 3 $.  1 1 2 )
]
