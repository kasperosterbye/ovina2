Extension { #name : #SpPresenter }

{ #category : #'*Ovina2' }
SpPresenter >> withLabelAtTop: labelString [
	^ OvinaLabeledPresenter new
		label: labelString;
		input: self;
		yourself 
]
