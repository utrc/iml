/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.tests

import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.NamedType
import org.eclipse.emf.ecore.resource.ResourceSet

/**
 * Test related helper methods
 * @author Ayman Elkfrawy
 */
class TestHelper {
	
	def findSymbol(Model model, String name) {
		model.symbols.findFirst[it.name.equals(name)]	
	}
	
	def findSymbol(ResourceSet rs, String name) {
		rs.resources
			.filter[contents.get(0) instanceof Model]
			.map[(contents.get(0) as Model).symbols]
			.flatten.findFirst[it.name == name]
	}
	
	
	def findSymbol(NamedType type, String name) {
		type.symbols.findFirst[it.name.equals(name)]	
	}
	
}