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
import com.utc.utrc.hermes.iml.iml.Assertion
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.util.Phi
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import org.eclipse.xtext.resource.XtextResource
import com.utc.utrc.hermes.iml.util.TermExtractor

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
		testGetTypeNameManually("(Int->Real)", "Int->Real")
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
		assertEquals(isSimpleHot, ImlUtil.isFirstOrderFunction(v1.type))
	}
	
	@Test
	def void testToCNF() {
		val model = '''
		package p ;
		type Bool ;
		type Int ;
		type A {
			v1 : Bool ;
			v2 : Bool ;
			v3 : Bool ;
			v4 : Bool ;
			//assert a { (v1 || v2) && (v3 || v4) && (v1 || v4) };
			assert a { ( v1 && v2 && (v1 => v3) ) || ! ( v4 => v1 ) };
		}
		'''.parse
		model.assertNoErrors
		val A = (model.findSymbol("A") as NamedType)
		val a = A.findSymbol("a") as Assertion;
		val f = Phi.toCNF((a.definition as SequenceTerm).^return);
		val st = ImlCustomFactory.INST.createSequenceTerm
		val newa = ImlCustomFactory.INST.createAssertion
		st.^return = f ;
		newa.definition = st
		newa.name = "acnf"
		A.symbols.add(newa)
		
		System.out.println( ( model.eResource as XtextResource).getSerializer().serialize(model)) ;
	}
	
	@Test
	def void testToCNF1() {
		val model = '''
		package p ;
		type Bool ;
		type Int ;
		type A {
			v1 : Int-> Bool ;
			v2 : Bool ;
			v3 : Int-> Bool ;
			v4 : Bool ;
			//assert a { (v1(0) || v2) && (v3(2) || v4) && (v1(1) || v4) };
			assert a { ( v1(0) && v2 && (v1 => v3(2)) ) || ! ( v4 => v1(1) ) };
		}
		'''.parse
		model.assertNoErrors
		val A = (model.findSymbol("A") as NamedType)
		val a = A.findSymbol("a") as Assertion;
		val f = Phi.toCNF((a.definition as SequenceTerm).^return);
		val st = ImlCustomFactory.INST.createSequenceTerm
		val newa = ImlCustomFactory.INST.createAssertion
		st.^return = f ;
		newa.definition = st
		newa.name = "acnf"
		A.symbols.add(newa)
		
		System.out.println( ( model.eResource as XtextResource).getSerializer().serialize(model)) ;
	}
	
	@Test
	def void testTermExtractor() {
		val model = '''
		package p ;
		type Bool ;
		type Int ;
		type A {
			v1 : Int-> Bool ;
			v2 : Bool ;
			v3 : Int-> Bool ;
			v4 : Bool ;
			v5 : Int ;
			//assert a { (v1(0) || v2) && (v3(2) || v4) && (v1(1) || v4) };
			assert a { ( v1(v5) && v2 && (v1 => v3(2)) ) || ! ( v4 => v1(1) ) };
		}
		'''.parse
		model.assertNoErrors
		val A = (model.findSymbol("A") as NamedType)
		val a = A.findSymbol("a") as Assertion;
		val tl = TermExtractor.extractFrom(a.definition);	
		print(tl)
//		System.out.println( ( model.eResource as XtextResource).getSerializer().serialize(model)) ;
	}
	
	@Test
	def void testTermExtractorWithTermMemberSelection() {
		val model = '''
		package p ;
		type Bool ;
		type Int ;
		type A {
			v1 : B ;
			assert a { v1 = v1 && v1.vx;};
		}
		
		type B {
			vx: Bool;
		}
		'''.parse
		model.assertNoErrors
		val A = (model.findSymbol("A") as NamedType)
		val a = A.findSymbol("a") as Assertion;
		val tl = TermExtractor.extractFrom(a.definition);	
		print(tl)
//		System.out.println( ( model.eResource as XtextResource).getSerializer().serialize(model)) ;
	}
	
	
}
