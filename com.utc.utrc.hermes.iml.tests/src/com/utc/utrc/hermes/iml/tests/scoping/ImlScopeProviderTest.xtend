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
			assertScope(ImlPackage::eINSTANCE.atomicTerm_Symbol, "var1")
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
			assertScope(ImlPackage::eINSTANCE.atomicTerm_Symbol, "var1, varp")
		];
		return
	}
	
	
	def private assertScope(EObject context, EReference ref, String expected) {
		context.assertNoErrors
		expected.toString.assertEquals(
			context.getScope(ref).allElements.map[name].join(", ")
		)
	}
	
}