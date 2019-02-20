package com.utc.utrc.hermes.iml.scoping

import org.eclipse.xtext.scoping.impl.ImportUriGlobalScopeProvider
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.core.runtime.Platform
import java.nio.file.Files
import java.nio.file.Paths

class ImlImportUriGlobalScopeProvider extends ImportUriGlobalScopeProvider {
	
	override protected getImportedUris(Resource resource) { 
		val importedUris = super.getImportedUris(resource)
		val bundle = Platform.getBundle("com.utc.utrc.hermes.iml")
		if (bundle !== null) { // UI environment
			val entries = bundle.findEntries("imllib/iml/", "*.iml", true)
			while (entries.hasMoreElements) {
				val entry = entries.nextElement
				importedUris.add(URI.createURI("platform:/plugin/com.utc.utrc.hermes.iml" + entry.path))
			}
		} else if (this.getClass().classLoader.getResource("./iml/") !== null) { // Standalone environment
			val imlLibUrl = this.getClass().classLoader.getResource("./iml/").path
			Files.walk(Paths.get(imlLibUrl)).filter[Files.isRegularFile(it) && it.toFile().getName().endsWith(".iml")]
					.forEach[importedUris.add(URI.createFileURI(it.toFile.absolutePath))]
		}
		
		return importedUris
	}
}