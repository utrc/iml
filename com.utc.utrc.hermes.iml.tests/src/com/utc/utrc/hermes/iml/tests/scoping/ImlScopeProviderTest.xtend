package com.utc.utrc.hermes.iml.tests.scoping

import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import com.google.inject.Inject
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.junit.Test
import com.utc.utrc.hermes.iml.scoping.ImlScopeProvider
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.ImlPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EObject
import static extension org.junit.Assert.*
import com.utc.utrc.hermes.iml.iml.AtomicTerm
import java.util.Arrays
import java.util.List

/**
 * 
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlScopeProviderTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension ImlScopeProvider
	
	@Inject extension TestHelper
	
	
	@Test
	def scopeForMemberSelection() {
		val model = '''
			package p;
			type Int;
			type t1 {
				var1 : Int;
			}
			
			type t2 {
				var2 : t1;
				varx : Int := var2->var1;
			}
		'''.parse;
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as TermMemberSelection) => [
			assertScope(ImlPackage::eINSTANCE.atomicTerm_Symbol, Arrays.asList("var1"))
		];
		return
	}
	
	@Test
	def scopeForMemberSelection_WithExtension() {
		val model = '''
			package p;
			type Int;
			type Parent {
				varp : Int;
			}
			type t1 extends Parent {
				var1 : Int;
			}
			
			type t2 {
				var2 : t1;
				varx : Int := var2->var1;
			}
		'''.parse;
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as TermMemberSelection) => [
			assertScope(ImlPackage::eINSTANCE.atomicTerm_Symbol, Arrays.asList("var1", "varp"))
		];
		return
	}
	
	@Test
	def scopeForAtomicMember_WithParent() {
		val model = '''
			package p;
			type Int;
			type Parent {
				varp : Int;
			}
			type t1 extends Parent {
				var1 : Int;
				varx : Int := var1;
			}
		'''.parse;
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as AtomicTerm) => [
			assertScope(ImlPackage::eINSTANCE.atomicTerm_Symbol, 
				Arrays.asList("var1", "varp", "Int", "Parent", "Parent.varp", 
						"t1.var1", "t1.varx", "varx", "t1"))
		];
		return
	}
	
	@Test
	def scopeForAtomicMember_MutliplePackages() {
		var model = '''
			package p1;
			type P1T1;
		'''.parse;
		
		model = '''
			package p2;
			import p1.*;
			type Int;
			type P2T1 {
				var1 : Int;
				varx : Int := var1;
			}
		'''.parse(model.eResource.resourceSet)
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as AtomicTerm) => [
			assertScope(ImlPackage::eINSTANCE.atomicTerm_Symbol, 
				Arrays.asList("var1", "varx", "P2T1", "P2T1.var1", "P2T1.varx", 
						"Int", "P1T1", "p1.P1T1"))
		];
		return
	}
	
	def private assertScope(EObject context, EReference ref, List<String> expected) {
		context.assertNoErrors
		val scope = context.getScope(ref).allElements.map[name.toString].toList
		assertEquals(expected.size, scope.size)
		assertTrue(expected.containsAll(scope))
	}
	
}