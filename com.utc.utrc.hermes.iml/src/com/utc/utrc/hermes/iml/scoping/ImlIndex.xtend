
package com.utc.utrc.hermes.iml.scoping

import com.google.inject.Inject
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.eclipse.xtext.resource.IContainer
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass
import com.utc.utrc.hermes.iml.iml.ImlPackage

/**
 * @author Ayman Elkfrawy
 */
class ImlIndex {

	@Inject ResourceDescriptionsProvider rdp
	@Inject IContainer$Manager cm
	
	def getVisibleEObjectDescriptions(EObject o) {
		o.getVisibleContainers.map[ container |
			container.getExportedObjects
		].flatten
	}

	def getVisibleEObjectDescriptions(EObject o, EClass type) {
		o.getVisibleContainers.map[ container |
			container.getExportedObjectsByType(type)
		].flatten
	}

	def getVisibleNamedTypeDescriptions(EObject o) {
		o.getVisibleEObjectDescriptions(ImlPackage::eINSTANCE.namedType)
	}
	

	def getVisibleContainers(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		val rd = index.getResourceDescription(o.eResource.getURI)
		if (rd !== null)
			cm.getVisibleContainers(rd, index)
		else
			emptyList
	}
	
	def getResourceDescription(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.getURI)
	}

	def getExportedEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjects
	}
	
	
}
