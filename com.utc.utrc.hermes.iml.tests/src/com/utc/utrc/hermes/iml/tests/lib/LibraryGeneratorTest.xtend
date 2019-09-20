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

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class LibraryGeneratorTest {
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Inject extension LibraryServicesGenerator
	
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
}