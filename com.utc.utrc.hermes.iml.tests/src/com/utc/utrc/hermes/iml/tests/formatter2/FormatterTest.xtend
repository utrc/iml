package com.utc.utrc.hermes.iml.tests.formatter2

import com.google.inject.Inject
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import org.junit.Test
import org.eclipse.xtext.serializer.impl.Serializer
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.InjectWith
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.tests.TestHelper
import com.utc.utrc.hermes.iml.iml.NamedType

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class FormatterTest {
	@Inject extension ParseHelper<Model>
	@Inject extension Serializer
	@Inject extension TestHelper
	
	@Test
	def void testFormatterNewLineForEachSymbol() {
		val model = '''
			package p;
		'''.parse
		
		model.symbols.add(ImlCustomFactory.INST.createNamedType => [name = "Int"])
		model.symbols.add(ImlCustomFactory.INST.createSymbolDeclaration => [name = "var1"; 
			type = ImlCustomFactory.INST.createSimpleTypeReference(model.findSymbol("Int") as NamedType)
		])
		
		print(model.serialize)
	}
}