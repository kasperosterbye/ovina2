Extension { #name : #SpMorphicTreeTableDataSource }

{ #category : #'*Ovina2' }
SpMorphicTreeTableDataSource >> cellColumn: column row: rowIndex [
	| cell builder item |
	
	item := self elementAt: rowIndex.
	cell := FTIndentedCellMorph new.
	(self isFirstColumn: column) ifTrue: [
		cell indentBy: (self cellIndentFor: item).
		cell addMorphBack: (self buttonFor: item) ].

	builder := SpMorphicTreeTableCellBuilder on: self.
	builder 
		cell: cell;
		item: item data;
		visit: column model.
	
	^ cell 
]
