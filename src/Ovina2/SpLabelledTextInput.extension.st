Extension { #name : #SpLabelledTextInput }

{ #category : #'*Ovina2' }
SpLabelledTextInput >> whenTextChanged: aBlock [

	self input whenTextChangedDo: aBlock
]
