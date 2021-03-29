Extension { #name : #SQLite3Library }

{ #category : #'*Ovina2' }
SQLite3Library >> macLibraryName [
	| pluginDir |
	pluginDir := FileSystem /'usr'/'lib'.
	#('libsqlite3.dylib' 'libsqlite3.0.dylib' 'sqlite3/libtclsqlite3.dylib')
		detect: [ :each | (pluginDir / each) exists ] 
		ifFound: [ :libName | ^ (pluginDir / libName) fullName  ].

	self error: 'Module not found.'
]
