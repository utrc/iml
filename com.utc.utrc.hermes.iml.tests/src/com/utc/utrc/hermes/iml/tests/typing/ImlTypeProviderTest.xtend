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
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

/**
 * Test related helper methods
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlTypeProviderTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Test
	def testTermExpressionType_withAddition_int() {
		assertFormulaType("5 + 6", ImlTypeProvider.Int);
	}
	
	@Test
	def testTermExpressionType_withAddition_real() {
		assertFormulaType("5 * 6.5", ImlTypeProvider.Real);
	}
	
	@Test
	def testTermExpressionType_withAddition_realDiv() {
		assertFormulaType("5 / 6", ImlTypeProvider.Real);
	}
	
	@Test
	def testTermExpressionType_withAddition_boolean() {
		assertFormulaType("5 = 6", ImlTypeProvider.Bool);
	}
	
	def assertFormulaType(String formula, HigherOrderType type) {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : Int := «formula»;
			}
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val context = TypingServices.createBasicType(t1)
		
		assertEquals(ImlTypeProvider.termExpressionType(folForm, context), type)
		
	}
	
	@Test
	def testTermExpressionType() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : Int := var2;
				var2 : t2;
			}
			
			type t2;
			
		'''.parse
		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		var t2 = model.findSymbol("t2") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val context = TypingServices.createBasicType(t1)
		
		val exprType = ImlTypeProvider.termExpressionType(folForm, context)
		
		assertEquals((exprType.domain as SimpleTypeReference).ref, t2)
	}
	
	@Test
	def testTermExpressionType_withTermSelection() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : Int := var2->varx;
				var2 : t2;
			}
			
			type t2 {
				varx : Int;	
			};
			
		'''.parse
//		model.assertNoErrors
		
		var t1 = model.findSymbol("t1") as ConstrainedType
		var intType = model.findSymbol("Int") as ConstrainedType
		val var1 = t1.findSymbol("var1") 
		val folForm = var1.definition
		
		val context = TypingServices.createBasicType(t1)
		
		val exprType = ImlTypeProvider.termExpressionType(folForm, context)
		
		assertEquals((exprType.domain as SimpleTypeReference).ref, intType)
	}
	
}