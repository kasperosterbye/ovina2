"
Ovina is our sheep administration system.

Deployment is this:

* Database & csv files in imageDirectory.
* To deploy, 
	- **copy** imageDirectory to icloud 
	- drag image to dock
"
Class {
	#name : #ManifestOvina2,
	#superclass : #PackageManifest,
	#category : #'Ovina2-Manifest'
}

{ #category : #'code-critics' }
ManifestOvina2 class >> ruleReAsClassRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#Ovina2)) #'2021-05-11T10:00:34.756476+02:00') )
]

{ #category : #'code-critics' }
ManifestOvina2 class >> ruleRefersToClassRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'OvinaSheep class' #allColumns #true)) #'2021-02-26T09:49:42.065553+01:00') )
]
