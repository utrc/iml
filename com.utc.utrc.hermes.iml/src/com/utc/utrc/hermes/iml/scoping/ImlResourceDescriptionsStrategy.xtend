//	Copyright (C) 2014, United Technologies Research Center
//	All rights reserved.
//
//	The content of this file has been developed under the DARPA STO Program
//	"Communications in Contested Environments (C2E)" by the United Technologies 
//  Research Center (UTRC) (contract number N65236-14-C-2822).
//
//  DISTRIBUTION STATEMENT D: Distribution authorized to the Department of 
//	Defense (DoD) and U.S. DoD contractors; Administrative or Operational Use, 
//	March 1, 2014.  Other requests for this document shall be referred to DARPA, 
//	Security and Intelligence Directorate, 675 N. Randolph St., Arlington, 
//	Virginia 22203-2114.  
//	Authors:
//	Gerald Wang (wangg2@utrc.utc.com)

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
