package com.utc.utrc.hermes.iml.custom

import org.eclipse.xtext.scoping.impl.DefaultGlobalScopeProvider
import org.eclipse.emf.ecore.resource.Resource

class ImlCustomGlobalScope extends DefaultGlobalScopeProvider {
	
	override protected getVisibleContainers(Resource resource) {
		if (resource !== null && resource.resourceSet !== null) {
			
		}
		super.getVisibleContainers(resource)
	}
	
}