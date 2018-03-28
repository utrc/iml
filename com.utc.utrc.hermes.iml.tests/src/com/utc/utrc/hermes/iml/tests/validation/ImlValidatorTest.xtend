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
import com.utc.utrc.hermes.iml.validation.ImlValidator

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
		model.assertError(ImlPackage.eINSTANCE.constrainedType, ImlValidator.DUPLICATE_ELEMENT)
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
		'''.parse
		
		val model2 = '''
			package p1;
			type T1;
		'''.parse(model1.eResource.resourceSet)
		
		model1.assertNoErrors
		model2.assertNoErrors
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
		model.assertError(ImlPackage.eINSTANCE.symbolDeclaration, ImlValidator.DUPLICATE_ELEMENT)
	}
	
}