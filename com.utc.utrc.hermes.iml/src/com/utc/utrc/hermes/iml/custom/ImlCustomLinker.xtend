/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.custom

import org.eclipse.xtext.linking.lazy.LazyLinker
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.diagnostics.IDiagnosticConsumer
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import com.utc.utrc.hermes.iml.iml.Model

class ImlCustomLinker extends LazyLinker {
	
	@Inject ImlStdLib imlStdLib;
	
	override protected doLinkModel(EObject model, IDiagnosticConsumer consumer) {
		super.doLinkModel(model, consumer)
		if (model instanceof Model) {
			imlStdLib.populate(model)
		}
	}
	
}