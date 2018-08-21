/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.hermes.iml.tests

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.validation.ValidationTestHelper

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlParsingTest {
	@Inject extension ParseHelper<Model> 
	
	@Inject extension ValidationTestHelper
	
	@Test
	def void loadModel() {
		val result = '''
			package p;
		'''.parse
		Assert.assertNotNull(result)
		Assert.assertTrue(result.eResource.errors.isEmpty)
	}
	
	@Test
	def void parsingHigherOrderType() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : Int ~> (Int ~> Int);
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingArrayOfTuple() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : (Int, Int)[];
			}
		'''.parse
		
		model.assertNoErrors
	}
	
		
	@Test
	def void testParsingArrayOfHot() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : (Int ~> Int)[];
			}
		'''.parse
		
		model.assertNoErrors
	}
	
		
	@Test
	def void testParsingArrayOfSimpleType() {
		val model = '''
			package p;
			type Int;
			type t {
				var1 : Int[];
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingShortProperty() {
		val model = '''
			package p;
			type t {
				a1 assertion := True;
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void testParsingMetaProperty() {
		val model = '''
			package p;
			meta type myassertion;
			type Bool;
			type t {
				a1 <<a:myassertion>> : Bool := True;
			}
		'''.parse
		
		model.assertNoErrors
	}
}
