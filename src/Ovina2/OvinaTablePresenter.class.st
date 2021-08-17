Class {
	#name : #OvinaTablePresenter,
	#superclass : #SpTablePresenter,
	#category : #'Ovina2-GUI General'
}

{ #category : #api }
OvinaTablePresenter >> items: newItems [
	"Set the items of the list.
	`aSequenceableCollection` is a collection of your domain specific items.
	This resets the collection model and unselects any previously selected item."
	
|selected|
	selected := [self selection selectedItem] on: Error do: [nil].
	model collection: newItems.
	(selected notNil and: [ newItems includes: selected ]) 
		ifTrue: [ 
			self selection selectItem: selected]
]
