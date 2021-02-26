"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestOvina2,
	#superclass : #PackageManifest,
	#category : #'Ovina2-Manifest'
}

{ #category : #'code-critics' }
ManifestOvina2 class >> ruleRefersToClassRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'OvinaSheep class' #allColumns #true)) #'2021-02-26T09:49:42.065553+01:00') )
]
