package com.utc.utrc.hermes.iml.tests.lib

import org.junit.runner.RunWith
import org.eclipse.xtext.testing.XtextRunner
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.ImlParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.junit.Test
import com.utc.utrc.hermes.iml.lib.LibraryServicesGenerator
import com.utc.utrc.hermes.iml.lib.OntologicalServices
import static org.junit.Assert.assertTrue

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class LibraryGeneratorTest {
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Inject extension LibraryServicesGenerator
	
	@Inject extension OntologicalServices
	
	@Test
	def void testGenerateServicesMethods() {
		val model = '''
		package com.p;
		
		trait Runnable;
		trait Colonable;
		type Int;
		annoation Test;		
		'''.parse(false)
		
		print(generateMethods(model.symbols))
	}
	
	@Test
	def void testServicesGetTrait() {
		val model = '''
		package p;
		import iml.synchdf.ontological.*;
		
		type A exhibits (Synchronous) {
			
		}
		'''.parse
		
		assertTrue(model.symbols.get(0).synchronous)
	}
}