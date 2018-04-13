package com.utc.utrc.hermes.iml.tests.validation

import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.InjectWith
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import com.google.inject.Inject
import org.junit.Test
import com.utc.utrc.hermes.iml.iml.ImlPackage
import static com.utc.utrc.hermes.iml.validation.ImlValidator.*
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import static extension org.junit.Assert.*

/**
 * Test related helper methods
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlValidatorTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Test
	def testCheckNoDuplicateElement_CT_noDuplicates() {
		val model = '''
			package p;
			type T1;
			type T2;
			
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_duplicates() {
		val model = '''
			package p;
			type T1;
			type T2;
			type T2;
			
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.constrainedType, DUPLICATE_ELEMENT)
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_differentPackages_noDuplicate() {
		val model1 = '''
			package p1;
			type T1;
		'''.parse
		
		val model2 = '''
			package p2;
			type T1;
		'''.parse(model1.eResource.resourceSet)
		
		model1.assertNoErrors
		model2.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_differentPackages_duplicate() {
		val model1 = '''
			package p1;
			type T1;
		'''.parse
		
		val model2 = '''
			package p2;
			import p1;
			type T1;
		'''.parse(model1.eResource.resourceSet)
		
		model1.assertNoErrors
		model2.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_CT_samePackages_differentFiles_duplicate() {
		val model1 = '''
			package p1;
			type T1;
			type x {
				varx : T1;				
			}
		'''.parse
		
		val model2 = '''
			package p1;
			type T1;
			
			type x {
				varx : T1;				
			}
		'''.parse(model1.eResource.resourceSet)
		
		model1.assertNoErrors
		model2.assertNoErrors
		// Check if shadowing work
		val model1T = model1.findSymbol("T1")
		val model1Ref = ((model1.findSymbol("x") as ConstrainedType).findSymbol("varx").type as SimpleTypeReference).ref
		assertSame(model1T, model1Ref)
		
		val model2T = model2.findSymbol("T1")
		val model2Ref = ((model2.findSymbol("x") as ConstrainedType).findSymbol("varx").type as SimpleTypeReference).ref
		assertSame(model2T, model2Ref)
		assertNotSame(model1Ref, model2Ref)
	}
	
	
	@Test
	def testCheckNoDuplicateElement_symbolDeclaration_noDuplicates() {
		val model = '''
			package p;
			type Int;
			type T1 {
				var1 : Int;
				var2 : Int;
			};
			
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckNoDuplicateElement_symbolDeclaration_duplicates() {
		val model = '''
			package p;
			type Int;
			type T1 {
				var1 : Int;
				var2 : Int;
				var2 : Int;
			};
			
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, DUPLICATE_ELEMENT)
	}
	
		@Test
	def testCheckNoDuplicateElement_templateDeclaration() {
		val model = '''
			package p;
			type T1 <type T, type T>;
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.constrainedType, DUPLICATE_ELEMENT)
	}
	
	@Test
	def testCheckTemplateType_valid() {
		val model = '''
			package p;
			type x<type T, type P>;
			
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def testCheckTemplateType_Invalid() {
		testInvalidTemplateType("meta type T")
		testInvalidTemplateType("type T <<v : Int>>")
		testInvalidTemplateType("type T <<>>")
		testInvalidTemplateType("type finite |10| T")
		testInvalidTemplateType("type T <type T2>")
		testInvalidTemplateType("type T extends Int")
		testInvalidTemplateType("type T {var1 : Int;}")
	}
	
	def testInvalidTemplateType(String templates) {
		var model = '''
			package p;
			type Int;
			type x<«templates»>;
		'''.parse
		model.assertError(ImlPackage.eINSTANCE.constrainedType, INVALID_TYPE_PARAMETER);
	}
	
	@Test
	def testCheckExtendsSimpleType_Valid() {
		val model = '''
			package p;
			type Parent;
			
			type Child extends Parent;
		'''.parse
		
		model.assertNoErrors
	}
	
		@Test
	def testCheckExtendsSimpleType_ValidMultipleExtends() {
		val model = '''
			package p;
			type Parent;
			type Parent2;
			
			type Child extends Parent extends Parent2;
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testCheckExtendsSimpleType_Invalid() {
		testInvalidExtends("extends (Parent1, Parent2)")
		testInvalidExtends("extends Parent1~>Parent1")
		testInvalidExtends("extends Parent1[10]")
		testInvalidExtends("extends Parent1 extends Parent1[10]")
	}
	
	def testInvalidExtends(String extensions) {
		val model = '''
			package p;
			type Parent1;
			type Parent2;
			
			type Child «extensions»;
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.relationInstance, INVALID_RELATION)
	}
	
	@Test
	def testNoCycle_Valid() {
		val model = '''
			package p;
			type T1;
			type T2 extends T1;
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def testNoCycle_IncludeDirectCycle() {
		val model = '''
			package p;
			type T1 extends T2;
			type T2 extends T1;
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.constrainedType, CYCLIC_CONSTRAINEDTYPE_HIERARCHY)
	}
	
	@Test
	def testNoCycle_IncludeIndirectCycle() {
		val model = '''
			package p;
			type Tx;
			type T1 extends T2;
			type T2 extends Tx extends T3;
			type T3 extends T1;
		'''.parse
		
		model.assertError(ImlPackage.eINSTANCE.constrainedType, CYCLIC_CONSTRAINEDTYPE_HIERARCHY)
	}
}