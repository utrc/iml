package com.utc.utrc.hermes.iml.tests.generator

import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.XtextRunner
import com.google.inject.Inject
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import org.junit.Test
import com.utc.utrc.hermes.iml.generator.infra.Iml2Symbolic
import org.junit.Before
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ImlInjectorProvider))
class Iml2SymbolicTest {
	
	@Inject extension ParseHelper<Model> 
	@Inject extension ValidationTestHelper
	@Inject Iml2Symbolic iml2Symbolic;
	
	
	
	@Before
	def resetTable() {
		iml2Symbolic.newTable
	}
	
	@Test
	def testEncodeModel() {
		var model = '''
			package p;
			
			type Int;
			
			type T1 {
				var1 : Int;
			}
		'''.parse
		
		iml2Symbolic.encode(model)
		
		assertEquals(2, iml2Symbolic.symbolTable.symbols.size);
	}
	
	@Test
	def testEncodeModel_WithHOT() {
		var model = '''
			package p;
			type Int;
			
			type T1 {
				var1 : Int ~> Int;
			}
		'''.parse
		
		iml2Symbolic.encode(model)
		
		assertEquals(3, iml2Symbolic.symbolTable.symbols.size);
	}
	
	@Test
	def testEncodeModel_WithMultipleSameHOT() {
		var model = '''
			package p;
			type Int;
			
			type T1 {
				var1 : Int ~> Int;
				var2 : Int ~> Int;
			}
		'''.parse
		
		iml2Symbolic.encode(model)
		
		assertEquals(3, iml2Symbolic.symbolTable.symbols.size);
	}
	
	@Test
	def testEncodeModel_WithMultipleDifferentHOT() {
		var model = '''
			package p;
			type Int;
			type Real;
			
			type T1 {
				var1 : Int ~> Int;
				var2 : Int ~>Real;
			}
		'''.parse
		
		iml2Symbolic.encode(model)
		
		assertEquals(4, iml2Symbolic.symbolTable.symbols.size);
	}
	
}