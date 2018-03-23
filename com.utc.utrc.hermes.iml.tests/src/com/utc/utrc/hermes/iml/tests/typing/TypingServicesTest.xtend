package com.utc.utrc.hermes.iml.tests.typing

import org.junit.runner.RunWith
import org.eclipse.xtext.testing.XtextRunner
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import com.google.inject.Inject
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import org.junit.Test
import static org.junit.Assert.*
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import com.utc.utrc.hermes.iml.typing.TypingServices
import com.utc.utrc.hermes.iml.iml.ConstrainedType


@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class TypingServicesTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	
	@Test
	def testIsEqual_HigherOrderType() {
		val model = '''
			package p;
			type Int;
			type t1 {
				var1 : Int;
				var2 : Int;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTemplate() {
		val model = '''
			package p;
			type TemType<type T, type P>;
			type Int;
			type Float;
			type t1 {
				var1 : TemType<Int, Float>;
				var2 : TemType<Int, Float>;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTemplate_DifferentTypes() {
		val model = '''
			package p;
			type TemType<type T, type P>;
			type Int;
			type Float;
			type t1 {
				var1 : TemType<Float, Int>;
				var2 : TemType<Int, Float>;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithArray() {
		val model = '''
			package p;
			type Int;
			type t1 {
				var1 : Int[10];
				var2 : Int[20];
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithArray_DifferentTypes() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : Boolean[10];
				var2 : Int[20];
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithArray_DifferentDiminsions() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : Int[10][20];
				var2 : Int[20];
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTuples() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (Int, Boolean);
				var2 : (Int, Boolean);
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTuples_DifferentTypes() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (Boolean, Int);
				var2 : (Int, Boolean);
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_WithTuples_DifferentSize() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (Int, Boolean, Boolean);
				var2 : (Int, Boolean);
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_Range() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (Int, Boolean) ~> Int;
				var2 : (Int, Boolean) ~> Int;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertTrue(TypingServices.isEqual(var1.type, var2.type))
	}
	
	@Test
	def testIsEqual_HigherOrderType_Range_DifferentTypes() {
		val model = '''
			package p;
			type Int;
			type Boolean;
			type t1 {
				var1 : (Int, Boolean) ~> Int;
				var2 : (Int, Boolean) ~> Boolean;
			}
		'''.parse
		
		model.assertNoErrors
		val var1 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var1")
		val var2 = (model.findSymbol("t1") as ConstrainedType).findSymbol("var2")
		
		assertFalse(TypingServices.isEqual(var1.type, var2.type))
	}
	
}