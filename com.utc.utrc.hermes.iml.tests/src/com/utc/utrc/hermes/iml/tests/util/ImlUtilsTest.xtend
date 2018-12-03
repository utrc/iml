/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.hermes.iml.tests.util

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import static org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.utc.utrc.hermes.iml.tests.TestHelper
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.util.HotUtil

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlUtilsTest {
	@Inject extension ParseHelper<Model> 
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Test
	def void testGetTypeNameManually() {
		testGetTypeNameManually("Int", "Int")
		testGetTypeNameManually("Int<Real,Int>", "Int<Real, Int>")
		testGetTypeNameManually("Int[10][]", "Int[][]")
		testGetTypeNameManually("(Int~>Real)", "(Int~>Real)")
		testGetTypeNameManually("(Int,Real)", "(Int, Real)")
	}
	
	def void testGetTypeNameManually(String typeDeclaration, String typeGenerated) {
		val model = '''
			package p;
			type Int;
			type Real;
			v1 :«typeDeclaration»;
		'''.parse
		model.assertNoErrors
		
		val v1 = model.findSymbol("v1") as SymbolDeclaration
		assertEquals(typeGenerated, ImlUtil.getTypeNameManually(v1.type, null))
	}
	
	@Test
	def void testIsSimpleHot() {
		testIsSimpleHot("Int", true)
		testIsSimpleHot("Int[]", true)
		testIsSimpleHot("(Int)", true)
		testIsSimpleHot("(Int, Real)", true)
		testIsSimpleHot("Int[][][]", true)
		testIsSimpleHot("Int->Real", true)
		testIsSimpleHot("Int[]->Real", true)
		testIsSimpleHot("(Int, Real) -> (Real, Int)", true)
		testIsSimpleHot("(Int->Real)->Int", false)
		testIsSimpleHot("Int->(Int->Real)", false)
		testIsSimpleHot("(Int->Real)[]", false)
		testIsSimpleHot("(Int->Real, Int)", false)
	}
	
	def void testIsSimpleHot(String typeDeclaration, boolean isSimpleHot) {
		val model = '''
			package p;
			type Int;
			type Real;
			v1 :«typeDeclaration»;
		'''.parse
		model.assertNoErrors
		
		val v1 = model.findSymbol("v1") as SymbolDeclaration
		assertEquals(isSimpleHot, HotUtil.isSimpleHot(v1.type))
	}
}
