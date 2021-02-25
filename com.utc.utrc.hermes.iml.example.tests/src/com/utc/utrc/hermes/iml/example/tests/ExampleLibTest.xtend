package com.utc.utrc.hermes.iml.example.tests

import org.junit.runner.RunWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.InjectWith
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.ImlParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.junit.Test
import org.eclipse.core.runtime.Platform
import com.utc.utrc.hermes.iml.iml.ImlPackage
import com.utc.utrc.hermes.iml.example.validator.ExampleValidator

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ExampleLibTest {
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Test
	def void testMonitorHasAllVariablesSet_Pass(){
		val model = '''
			package p;
			import iml.pc_hardware.*;
			
			a : PersonComputer;
			
			type My4kMonitor exhibits(Monitor) {
				assert { resolution = (1920 , 1080); }; 
				assert { size = 24.0 ; };
			}
			
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def void testMonitorHasAllVariablesSet_MissingSizeDef(){
		val model = '''
			package p;
			import iml.pc_hardware.*;
			
			a : PersonComputer;
			
			type My4kMonitor exhibits(Monitor) {
				assert { resolution = (1920 , 1080); }; 
			}
			
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.namedType, ExampleValidator.UNDEFINED_SYMBOL_ERROR)
	}
}