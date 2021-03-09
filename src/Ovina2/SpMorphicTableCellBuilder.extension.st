Extension { #name : #SpMorphicTableCellBuilder }

{ #category : #'*Ovina2' }
SpMorphicTableCellBuilder >> addBackgroundColorColumn: aTableColumn item: item toMorph: aMorph [
	aTableColumn displayBackgroundColor ifNotNil: [ :block |
		(block cull: item) ifNotNil: [ :aColor |
			aMorph color: aColor.
			aMorph submorphs do: [:each | each color: aColor]]].
	^ aMorph
]

{ #category : #'*Ovina2' }
SpMorphicTableCellBuilder >> visitStringColumn: aTableColumn [
	| content item |
	
	item := self item.

	content := aTableColumn readObject: item.
	"add properties"
	content := self addColorColumn: aTableColumn item: item to: content.
	content := self addItalicColumn: aTableColumn item: item to: content.
	content := self addBoldColumn: aTableColumn item: item to: content.
	content := self addUnderlineColumn: aTableColumn item: item to: content.
	
	aTableColumn isEditable
		ifTrue: [ self visitStringColumnEditable: aTableColumn on: content ]
		ifFalse: [ "add cell"
			self addCell: content column: aTableColumn.
			].
	"add background (this is a special case of properties, 
			since background needs to be applied to the cell and not to the text)"
			self
				addBackgroundColorColumn: aTableColumn
				item: item
				toMorph: cell 

]

{ #category : #'*Ovina2' }
SpMorphicTableCellBuilder >> visitStringColumnEditable: aTableColumn on: content [

	| presenter morph |
	presenter := SpTextInputFieldPresenter new
		             text: content;
		             yourself.

	aTableColumn acceptAction ifNotNil: [ :valuable | 
		presenter whenSubmitDo: [ 
			valuable cull: self item cull: presenter text ] ].
	"add cell"

	morph := presenter buildWithSpec.
	presenter adapter applyStyle: morph.

	self addCellMorph: morph column: aTableColumn 

]
