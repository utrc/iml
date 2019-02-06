package com.utc.utrc.hermes.iml.tests

import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.ConstrainedType
/**
 * Test related helper methods
 * @author Ayman Elkfrawy
 */
class TestHelper {
	
	def findSymbol(Model model, String name) {
		model.symbols.findFirst[it.name.equals(name)]	
	}
	
	def findSymbol(ConstrainedType type, String name) {
		type.symbols.findFirst[it.name.equals(name)]	
	}
	
}