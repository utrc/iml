/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */

package com.utc.utrc.hermes.iml.scoping

import javax.inject.Inject
import javax.inject.Singleton
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy
import org.eclipse.xtext.util.IAcceptor
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.Symbol

@Singleton
class ImlResourceDescriptionsStrategy extends DefaultResourceDescriptionStrategy {
	@Inject extension IQualifiedNameProvider
	
 	override createEObjectDescriptions(EObject eObject, IAcceptor<IEObjectDescription> acceptor) {
		if (eObject instanceof Model) {
			((eObject as Model).symbols.filter(typeof(Symbol))).forEach [
			symbol |
			val fullyQualifiedName = symbol.fullyQualifiedName
			if (fullyQualifiedName !== null)
				acceptor.accept(EObjectDescription::create(fullyQualifiedName, symbol)) 
			]
			true
		}
		else
			false
	}	
}
