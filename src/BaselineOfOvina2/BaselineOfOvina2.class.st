Class {
	#name : #BaselineOfOvina2,
	#superclass : #BaselineOf,
	#category : #BaselineOfOvina2
}

{ #category : #baselines }
BaselineOfOvina2 >> baseline: spec [ 
	<baseline>
	spec
		for: #common
		do: [ spec 
			blessing: #baseline;
			baseline: 'SQLite3' with: [ spec repository: 'github://pharo-rdbms/Pharo-SQLite3/src' ];
			package: 'Ovina2'";
			package: 'Ovina2-Tests'" ]

]
